package;

import debug.TestTool;
import achievements.GameEvents;
import haxe.Timer;
import openfl.ui.Keyboard;
import openfl.events.KeyboardEvent;
import openfl.utils.Assets;
import openfl.text.Font;
import openfl.display.Sprite;
import bitdecay.flixel.debug.tools.btree.BTreeInspector;
import bitdecay.flixel.debug.tools.draw.DebugDraw;
import bitdecay.flixel.debug.DebugSuite;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.system.debug.log.LogStyle;
import flixel.util.FlxColor;
import audio.FmodPlugin;
import achievements.Achievements;
import config.Configure;
import debug.DebugLayers;
import helpers.Storage;
import states.SplashScreenState;
import misc.FlxTextFactory;
import misc.Macros;
import states.MainMenuState;
#if play
import states.PlayState;
#end
#if credits
import states.CreditsState;
#end

class Main extends Sprite {
	public function new() {
		super();
		Configure.initAnalytics(false);
		Storage.load();
		GameEvents.init();
		Achievements.initAchievements();

		var startingState:Class<FlxState> = SplashScreenState;
		#if play
		startingState = PlayState;
		#elseif credits
		startingState = CreditsState;
		#else
		if (Macros.isDefined("SKIP_SPLASH")) {
			startingState = MainMenuState;
		}
		#end
		FlxG.signals.preGameStart.add(() -> {
			configureFlixel();
			configureDebug();
			configureLogging();

			// GameEvents.listen(START_LEVEL(null), (e) -> {
			// 	trace('player started level ${e}');
			// });

			// GameEvents.listen(PLAYER_DIED(null), (e) -> {
			// 	switch e {
			// 		case PLAYER_DIED(cause):
			// 			switch cause {
			// 				case ENEMY(name):
			// 					trace('idiot killed by a ${name}');
			// 				case FALL:
			// 					trace('idiot fell to their death');
			// 				case TRAP(name):
			// 					trace('idiot stepped in a ${name} trap');
			// 			}
			// 		default:
			// 	}
			// });

			// var fallStart:Float = -1.0;
			// GameEvents.listen(PLAYER_MOVE(null), (e) -> {
			// 	switch e {
			// 		case PLAYER_MOVE(type):
			// 			switch type {
			// 				case START_FALL(y):
			// 					fallStart = y;
			// 				case LAND(y):
			// 					var dist = y - fallStart;
			// 					trace('idiot fell ${dist} pixels');
			// 			}
			// 		default:
			// 	}
			// });
			// GameEvents.subscribe(events.gen.PlayerSpawn, (ps) -> {
			// 	trace(ps.posX);
			// 	trace(ps.posY);
			// });
		});
		addChild(new FlxGame(0, 0, startingState, 60, 60, true, false));

		trace('Build Hash: ${Macros.getGitCommitShortHash()}');
	}

	private function configureFlixel() {
		FlxG.fixedTimestep = false;

		#if html5
		// Disable right-click menu on web
		stage.showDefaultContextMenu = false;
		#end

		// FMOD will be all of our audio stuff
		FlxG.plugins.addPlugin(new FmodPlugin());

		// Disable flixel volume controls as we don't use them because of FMOD
		FlxG.sound.muteKeys = null;
		FlxG.sound.volumeUpKeys = null;
		FlxG.sound.volumeDownKeys = null;

		// Set up basic transitions. To override these see `transOut` and `transIn` on any FlxTransitionable states
		FlxTransitionableState.defaultTransIn = new TransitionData(FADE, FlxColor.BLACK, 0.35);
		FlxTransitionableState.defaultTransOut = new TransitionData(FADE, FlxColor.BLACK, 0.35);

		// Set any default font you want to be the default
		// FlxTextFactory.defaultFont = AssetPaths.Brain_Slab_8__ttf;
		FlxTextFactory.defaultSize = 24;
	}

	private function configureDebug() {
		#if debug
		DebugSuite.init(new DebugDraw(Type.allEnums(DebugLayers)), new BTreeInspector(), new TestTool());

		var fnt = Assets.getFont(AssetPaths.Brain_Slab_8__ttf);
		Font.registerFont(fnt);
		DebugSuite.tool(DebugDraw, (t) -> {
			t.setDrawFont(fnt.fontName, 10);
		});
		FlxG.debugger.visible = true;

		// When debugging, it's nice to have the game stay running when it loses focus
		FlxG.autoPause = false;

		// This lets the slash key auto-focus the input console in the debugger when pressed
		FlxG.stage.addEventListener(KeyboardEvent.KEY_UP, function(e:KeyboardEvent) {
			if (FlxG.debugger.visible && FlxG.game.debugger.console.visible && e.keyCode == Keyboard.SLASH) {
				@:privateAccess
				FlxG.stage.focus = FlxG.game.debugger.console.input;
			}
		});
		#end
	}

	private function configureLogging() {
		#if FLX_DEBUG
		LogStyle.WARNING.openConsole = true;
		LogStyle.WARNING.onLog.add((data, ?pos) -> {
			// Make sure we open the logger if a log triggered
			FlxG.game.debugger.log.visible = true;
		});

		LogStyle.ERROR.openConsole = true;
		LogStyle.ERROR.onLog.add((data, ?pos) -> {
			// Make sure we open the logger if a log triggered
			FlxG.vcr.pause();
			FlxG.game.debugger.log.visible = true;
		});
		#end
	}
}
