package newgrounds;

import flixel.util.FlxTimer;

import flixel.FlxG;
import flixel.util.FlxSignal;
import flixel.util.FlxStringUtil;

import io.newgrounds.Call.CallError;
import io.newgrounds.NG;
import io.newgrounds.NGLite.LoginOutcome;
import io.newgrounds.objects.Score;
import io.newgrounds.objects.SaveSlot;
import io.newgrounds.objects.SaveSlot.SaveSlotOutcome;
import io.newgrounds.objects.events.Outcome;

import newgrounds.NGEnv;

typedef NGMedalID = Int;
typedef NGScoreboardID = Int;

// Lovingly adapted from GeoKureli's repo here
// https://github.com/Geokureli/Newgrounds/blob/master/test/openfl-swf/Source/io/newgrounds/test/SimpleTest.hx
class Newgrounds {
	public static var slotLoadedSignal(default, null) = new FlxTypedSignal<Int->Void>();
	public static var loginSignal(default, null) = new FlxSignal();
	public static var scoreboardLoadedSignal(default, null) = new FlxTypedSignal<Int->Void>();

	// Returns true if Newgrounds was properly configured, false otherwise. Register signals prior to calling
	// this to avoid missing signals
	public static function init():Bool {
		if (FlxStringUtil.isNullOrEmpty(NGEnv.getNGAppID())) {
			#if debug
			trace('no NG app id found. Skipping NG init');
			#end

			NG.create();
			return false;
		}

		var debug = false;
		#if debug
		trace("connecting to newgrounds");

		// Use debug so medal unlocks and scoreboards reset after this session
		debug = true;
		#end

		NG.createAndCheckSession(NGEnv.getNGAppID(), debug);
		if (debug) {
			NG.core.verbose = true;
		}

		NG.core.setupEncryption(NGEnv.getNGEncryptKey(), AES_128, BASE_64);

		if (NG.core.attemptingLogin) {
			/* a session_id was found in the loadervars, this means the user is playing on newgrounds.com
			 * and we should login shortly. lets wait for that to happen
			 */
			trace('existing session found, waiting for login to complete');
			NG.core.onLogin.add(onNGLogin);
		}
		return true;
	}

	public static function requestLogin(?onSuccess:Void->Void, ?onCancel:Void->Void) {
		if (!NG.core.loggedIn) {
			/* They are NOT playing on newgrounds.com, no session id was found. We must start one manually, if we want to.
			 * Note: This will cause a new browser window to pop up where they can log in to newgrounds
			 */
			NG.core.requestLogin((r:LoginOutcome)-> {
				switch (r) {
					case FAIL(error):
						onCancel();
					case SUCCESS:
						onSuccess();
						onNGLogin();
				}
			});
		} else {
			trace('requested login while already logged in. Ignoring');
		}
	}

	static function onNGLogin() {
		#if debug
		trace ('logged in! user:${NG.core.user.name}');
		#end

		loginSignal.dispatch();

		NG.core.scoreBoards.loadList(onNGBoardsFetch);
		NG.core.medals.loadList(onNGMedalsFetch);
		NG.core.saveSlots.loadList(onNGSaveSlotsFetch);
	}

	static function onNGBoardsFetch(outcome:Outcome<CallError>) {
		#if debug
		outcome.assert('Error loading score boards:');
		#end

		// Reading scoreboard info
		for (id in NG.core.scoreBoards.keys()) {
			var board = NG.core.scoreBoards[id];
			#if debug
			trace('loaded scoreboard id:$id, name:${board.name}');
			#end
			board.requestScores(10, 0, ALL, null, null, null, dispatchScoreboardOnSuccess(id));
		}
	}

	private static function dispatchScoreboardOnSuccess(boardId:NGScoreboardID):(Outcome<CallError>)->Void {
		return (outcome:Outcome<CallError>) -> {
			#if debug
			outcome.assert('Error loading board scores for ${boardId}');
			#end

			switch (outcome) {
				case FAIL(error):
					// TODO: Handle error
					trace('failed to fetch board scores for ${boardId}: $error');
				case SUCCESS:
					scoreboardLoadedSignal.dispatch(boardId);
			}
		}
	}

	static function onNGMedalsFetch(outcome:Outcome<CallError>) {
		#if debug
		outcome.assert('Error loading medals:');

		// Reading scoreboard info
		for (id in NG.core.medals.keys()) {
			var medal = NG.core.medals[id];
			trace('loaded medal id:$id, name:${medal.name}');
			trace('   medal img: ${medal.icon}');
		}
		#end

		switch (outcome) {
			case FAIL(error):
				// TODO: Handle error
				trace('failed to fetch medals: $error');
			case SUCCESS:
				// Storage.syncNGMedals(NG.core.medals);
				#if (ngdebug || debug)
				NGVerify.verifyMedals(NG.core.medals);
				#end 
		}
	}

	static function onNGSaveSlotsFetch(outcome:Outcome<CallError>) {
		#if debug
		outcome.assert('Error loading save slots:');

		for (id in NG.core.saveSlots.keys()) {
			var slot = NG.core.saveSlots[id];
			if (slot.url != null) {
				trace('loading save slot id:$id, name:${slot.datetime}');
				slot.load((outcome:SaveSlotOutcome) -> {
					switch (outcome) {
						case FAIL(error):
							// TODO: Handle error
							trace('failed to load slot: $slot.id: $error');
						case SUCCESS(contents):
							trace('    slot contents:${contents}');
					}
				});
			} else {
				trace('save slot "${slot.id}" has no data');
			}
		}
		#end

		switch (outcome) {
			case FAIL(error):
				// TODO: Handle error
				trace('failed to fetch save slots: $error');
			case SUCCESS:
				for (i in 0...NG.core.saveSlots.length) {
					if (i > 2) {
						// we only support a max of 3 slots at the moment
						break;
					}
					// These come 1-based
					var slot = NG.core.saveSlots[i+1];
					if (slot.url != null) {
						slot.load(onSingleSlotLoaded(slot));
					} else {
						#if debug
						trace('save slot "${slot.id}" has no data');
						#end
						// Storage.loadSlotFromNG(slot);
						slotLoadedSignal.dispatch(slot.id-1);
					}
				}
		}
	}

	private static function onSingleSlotLoaded(slot:SaveSlot):(SaveSlotOutcome -> Void) {
		return (outcome) -> {
			switch (outcome) {
				case FAIL(error):
					trace('failed to load slot: $error');
				case SUCCESS(contents):
					// Storage.loadSlotFromNG(slot);
					slotLoadedSignal.dispatch(slot.id-1);
			}
		}
	}

	static function onNGScoresFetch(id:Int) {
		return () -> {
			for (score in NG.core.scoreBoards[id].scores)
				trace('board: \'$id\' score loaded user:${score.user.name}, score:${score.formattedValue}');
		}
	}

	public static function reportBoardScore(boardId:NGScoreboardID, time:Float) {
		if (NG.core == null || !NG.core.loggedIn) {
			return;
		}

		var board = NG.core.scoreBoards[boardId];
		board.postScore(Math.round(time * 1000));

		// add an update listener so we know when we get the new scores
		// board.onUpdate.add(onNGScoresFetch(boardId));
		// board.requestScores(10);
		// more info on scores --- http://www.newgrounds.io/help/components/#scoreboard-getscores
	}

	public static function reportMedal(m:NGMedalID) {
		if (NG.core == null || !NG.core.loggedIn) {
			return;
		}

		var medal = NG.core.medals[m];

		if (medal.unlocked) {
			#if debug
			trace('unlock medal is already unlocked: ${medal.id} - ${medal.name}');
			#end
			return;
		}

		#if debug
		trace('unlock medal: ${medal.id} - ${medal.name}');
		#end

		#if ngdebug
		medal.sendDebugUnlock();
		#else
		medal.sendUnlock();
		#end
	}
}
