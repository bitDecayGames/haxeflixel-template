package;

import achievements.Achievements;
import bitdecay.flixel.debug.DebugSuite;
import bitdecay.flixel.debug.tools.btree.BTreeInspector;
import bitdecay.flixel.debug.tools.draw.DebugDraw;
import events.EventBus;
import audio.FmodPlugin;
import config.Configure;
import debug.DebugLayers;
import debug.events.EventLog;
import events.MetricReducer;
import events.derivers.DistanceClickDeriver;
import events.derivers.SpeedClickDeriver;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.system.debug.log.LogStyle;
import flixel.util.FlxColor;
import helpers.Analytics;
import helpers.Storage;
import misc.FlxTextFactory;
import misc.Macros;
import openfl.display.Sprite;
import openfl.events.KeyboardEvent;
import openfl.text.Font;
import openfl.ui.Keyboard;
import openfl.utils.Assets;
import states.MainMenuState;
import states.SplashScreenState;
#if play
import states.PlayState;
#end
#if credits
import states.CreditsState;
#end
#if FLX_DEBUG
import plugins.GlobalDebugPlugin;
#end

class Main extends Sprite {
	public function new() {
		super();
		Configure.initAnalytics(false);
		Storage.load();

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
			initEvents();
			Achievements.initAchievements();
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
		DebugSuite.init(new DebugDraw(Type.allEnums(DebugLayers)), new BTreeInspector(), new EventLog());

		#if debug
		var fnt = Assets.getFont(AssetPaths.Brain_Slab_8__ttf);
		Font.registerFont(fnt);
		DS.get(DebugDraw).setDrawFont(fnt.fontName, 10);

		fnt = Assets.getFont(AssetPaths.NeomatrixCode__ttf);
		Font.registerFont(fnt);

		FlxG.debugger.visible = true;

		// When debugging, it's nice to have the game stay running when it loses focus
		FlxG.autoPause = false;

		// This lets the slash key auto-focus the input console in the debugger when pressed
		FlxG.stage.addEventListener(KeyboardEvent.KEY_UP, function(e:KeyboardEvent) {
			if (FlxG.debugger.visible && e.keyCode == Keyboard.SLASH) {
				if (!FlxG.game.debugger.console.visible) {
					FlxG.game.debugger.console.visible = true;
				}

				@:privateAccess
				FlxG.stage.focus = FlxG.game.debugger.console.input;
			}
		});

		FlxG.plugins.addPlugin(new GlobalDebugPlugin());
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

	private function initEvents() {
		EventBus.init();
		EventBus.registerDeriver(new SpeedClickDeriver(2000));
		EventBus.registerDeriver(new DistanceClickDeriver(100));
		MetricReducer.init();

		Analytics.initEventReporting();
	}
}
