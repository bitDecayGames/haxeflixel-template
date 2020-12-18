package;

import misc.FlxTextFactory;
import flixel.input.keyboard.FlxKey;
import flixel.input.FlxInput;
import config.Configure;
import flixel.util.FlxColor;
import flixel.addons.transition.TransitionData;
import flixel.addons.transition.FlxTransitionableState;
import flixel.FlxG;
import flixel.FlxGame;
import openfl.display.Sprite;
import states.LoadFmodState;

class Main extends Sprite
{
	public function new()
	{
		super();
		FlxG.fixedTimestep = false;

		#if debug
		FlxG.autoPause = false;
		#end

		FlxTextFactory.defaultFont = AssetPaths.Brain_Slab_8__ttf;

		FlxTransitionableState.defaultTransIn = new TransitionData(FADE, FlxColor.BLACK, 0.35);
		FlxTransitionableState.defaultTransOut = new TransitionData(FADE, FlxColor.BLACK, 0.35);
		addChild(new FlxGame(0, 0, LoadFmodState, 1, 60, 60, true, false));

		// Disable flixel volume controls as we don't use them because of FMOD
		FlxG.sound.muteKeys = null;
		FlxG.sound.volumeUpKeys = null;
		FlxG.sound.volumeDownKeys = null;

		// Don't use the flixel cursor
		FlxG.mouse.useSystemCursor = true;

		signals.Lifecycle.startup.add(() -> {
			var disableAnalytics = false;
			if (FlxG.keys.pressed.M) {
				trace("!!!!!!! Dev analytics override started. No metrics will be reported !!!!!!!");
				disableAnalytics = true;
			}

			Configure.initAnalytics(disableAnalytics);
		});
	}
}
