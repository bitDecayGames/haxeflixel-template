package states;

import flixel.util.FlxTimer;
import flixel.util.FlxSpriteUtil;
import input.SimpleController;
import flixel.FlxSprite;
import bitdecay.flixel.transitions.TransitionDirection;
import bitdecay.flixel.transitions.SwirlTransition;
import states.AchievementsState;
import com.bitdecay.analytics.Bitlytics;
import flixel.FlxG;
import flixel.addons.transition.FlxTransitionableState;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import haxefmod.flixel.FmodFlxUtilities;

using states.FlxStateExt;

class MainMenuState extends FlxTransitionableState {
	var startButton:FlxButton;
	var handleInput = true;

	override public function create():Void {
		super.create();
		bgColor = FlxColor.TRANSPARENT;
		FlxG.camera.pixelPerfectRender = true;

		var bgImage = new FlxSprite(AssetPaths.title_image__png);
		add(bgImage);

		// This can be swapped out for an image instead
		startButton = new FlxButton("Play", clickPlay);
		startButton.screenCenter(X);
		startButton.y = FlxG.height * .6;
		add(startButton);

		FmodManager.PlaySong(FmodSongs.LetsGo);

		// we will handle transitions manually
		transOut = null;
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);

		if (FlxG.keys.pressed.D && FlxG.keys.justPressed.M) {
			// Keys D.M. for Disable Metrics
			Bitlytics.Instance().EndSession(false);
			FmodManager.PlaySoundOneShot(FmodSFX.MenuSelect);
			trace("---------- Bitlytics Stopped ----------");
		}

		if (handleInput && SimpleController.just_pressed(START)) {
			handleInput = false;
			FlxSpriteUtil.flicker(startButton, 0, 0.25);
			new FlxTimer().start(1, (t) -> {
				clickPlay();
			});
		}
	}

	function clickPlay():Void {
		FmodManager.StopSong();
		var swirlOut = new SwirlTransition(TransitionDirection.OUT, () -> {
			// make sure our music is stopped;
			FmodManager.StopSongImmediately();
			FlxG.switchState(new PlayState());
		}, FlxColor.GRAY, 0.75);
		openSubState(swirlOut);
	}

	// If we want to add a way to go to credits from main menu, call this
	function clickCredits():Void {
		FmodFlxUtilities.TransitionToState(new CreditsState());
	}

	// If we want to add a way to go to achievements from main menu, call this
	function clickAchievements():Void {
		FmodFlxUtilities.TransitionToState(new AchievementsState());
	}

	override public function onFocusLost() {
		super.onFocusLost();
		this.handleFocusLost();
	}

	override public function onFocus() {
		super.onFocus();
		this.handleFocus();
	}
}
