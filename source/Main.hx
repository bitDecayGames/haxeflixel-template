package;

import openfl.utils.Assets;
import openfl.text.Font;
import debug.DebugLayers;
import flixel.system.debug.log.LogStyle;
import haxe.Timer;
import audio.FmodPlugin;
import achievements.Achievements;
import helpers.Storage;
import states.SplashScreenState;
import misc.Macros;
import states.MainMenuState;
import flixel.FlxState;
import config.Configure;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.util.FlxColor;
import misc.FlxTextFactory;
import openfl.display.Sprite;
import bitdecay.flixel.debug.DebugDraw;
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
		addChild(new FlxGame(0, 0, startingState, 60, 60, true, false));

		#if html5
		// Disable right-click menu on web
		stage.showDefaultContextMenu = false;
		#end

		configureFlixel();
		configureDebug();
		configureLogging();

		trace('Build Hash: ${Macros.getGitCommitShortHash()}');
	}

	private function configureFlixel() {
		FlxG.fixedTimestep = false;

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
		DebugDraw.init(Type.allEnums(DebugLayers));

		#if debug
		var fnt = Assets.getFont(AssetPaths.Brain_Slab_8__ttf);
		Font.registerFont(fnt);
		DebugDraw.ME.setDrawFont(fnt.fontName, 10);
		FlxG.debugger.visible = true;

		// When debugging, it's nice to have the game stay running when it loses focus
		FlxG.autoPause = false;
		#end
	}

	private function configureLogging() {
		#if FLX_DEBUG
		LogStyle.WARNING.openConsole = true;
		LogStyle.WARNING.callbackFunction = () -> {
			// Make sure we open the logger if a log triggered
			FlxG.game.debugger.log.visible = true;
		};

		LogStyle.ERROR.openConsole = true;
		LogStyle.ERROR.callbackFunction = () -> {
			// Make sure we open the logger if a log triggered
			FlxG.vcr.pause();
			FlxG.game.debugger.log.visible = true;
		};
		#end
	}
}
