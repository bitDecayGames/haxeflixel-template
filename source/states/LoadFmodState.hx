package states;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import misc.FlxTextFactory;
import misc.Macros;
import signals.Lifecycle;

/**
 * @author Tanner Moore
 * For games that are deployed to html5, the FMOD audio engine must be loaded before starting the game.
 */
class LoadFmodState extends FlxState {
	private var frameCount:Int = 0;
	private var inited:Bool = false;

	override public function create():Void {
		FmodManager.Initialize();

		var loadingText = FlxTextFactory.make("Loading...", FlxG.width / 2, FlxG.height / 2, 60, FlxTextAlign.CENTER);
		loadingText.x = (FlxG.width / 2) - loadingText.width / 2;
		loadingText.y = (FlxG.height / 2) - loadingText.height / 2;
		add(loadingText);
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);

		if (!inited && frameCount++ > 2) {
			// XXX: FlxG doesn't update all key presses until the second time through update
			inited = true;
			Lifecycle.startup.dispatch();
		}

		if (FmodManager.IsInitialized() && inited) {
			#if play
			FlxG.switchState(new PlayState());
			#else
			// Once FMOD is ready, and we've dispatched our startup
			if (Macros.isDefined("SKIP_SPLASH")) {
				FlxG.switchState(new MainMenuState());
			} else {
				FlxG.switchState(new SplashScreenState());
			}
			#end
		}
	}
}
