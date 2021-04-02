package preload;

import openfl.Lib;
import openfl.display.Bitmap;
import openfl.display.Sprite;
import openfl.display.BitmapData;
import flixel.system.FlxBasePreloader;

@:bitmap("assets/images/preloader/loadingIcon.png") class LogoImage extends BitmapData {}
@:bitmap("assets/images/preloader/loaderBar.png") class LoadBarImage extends BitmapData {}

/**
 * Custom preloader
 */
class BitdecayPreloader extends FlxBasePreloader {
	// Various hard-coded vars based on the embedded preloader images
	private static inline var LOADING_ICON_HEIGHT = 64;
	private static inline var LOADING_ICON_WIDTH = 128;
	private static inline var LOADING_BAR_HEIGHT = 10;

	private static inline var LOADING_BAR_OFFSET_X = 40;
	private static inline var LOADING_BAR_OFFSET_Y = 50;
	private static inline var LOADING_BAR_MAX_WIDTH = 80;

	private static inline var MARGINS = 30;

	private static inline var FADE_TIME = 0.5;

	var logo:Sprite;
	var loadBar:Sprite;
	var ratio:Float;

	var alphaFadeIncrement:Float;
	var fadeFinished:Bool;
	var loadCalled:Bool;

	public function new(MinDisplayTime:Float = 0, ?AllowedURLs:Array<String>) {
		// super(MinDisplayTime, ["https://bitdecaygames.itch.io/*", FlxBasePreloader.LOCAL]);
		super(1, AllowedURLs);
	}

	override function create():Void {
		super.create();
		fadeFinished = false;
		loadCalled = false;
		// FMOD must be initialized before the game starts for audio to work properly
		FmodManager.Initialize();

		// we want the icon to take one quarter of the width of the screen
		ratio = Lib.current.stage.stageWidth / 4 / LOADING_ICON_WIDTH;
		alphaFadeIncrement = 1.0 / (Lib.current.stage.frameRate * FADE_TIME);

		logo = new Sprite();
		logo.addChild(new Bitmap(new LogoImage(0, 0)));
		logo.scaleX = logo.scaleY = ratio;
		logo.x = Lib.current.stage.stageWidth - ((LOADING_ICON_WIDTH + MARGINS) * ratio);
		logo.y = Lib.current.stage.stageHeight - ((LOADING_ICON_HEIGHT + MARGINS) * ratio);
		addChild(logo); // Adds the graphic to the NMEPreloader's buffer.

		loadBar = new Sprite();
		loadBar.addChild(new Bitmap(new LoadBarImage(0, 0)));
		loadBar.scaleX = logo.scaleY = ratio;
		loadBar.x = logo.x + LOADING_BAR_OFFSET_X * ratio;
		loadBar.y = logo.y + LOADING_BAR_OFFSET_Y * ratio;
		addChild(loadBar); // Adds the graphic to the NMEPreloader's buffer.
	}

	override function update(percent:Float) {
		super.update(percent);
		loadBar.scaleX = LOADING_BAR_MAX_WIDTH * percent * ratio;

		if (percent >= 1 && !fadeFinished) {
			logo.alpha -= alphaFadeIncrement;
			loadBar.alpha -= alphaFadeIncrement;
			if (logo.alpha <= 0) {
				logo.alpha = 0;
				loadBar.alpha = 0;
				fadeFinished = true;
			}
		}

		if (fadeFinished && loadCalled && FmodManager.IsInitialized()) {
			// Everything is good to go. Consider ourselves loaded
			_loaded = true;
		}
	}

	// We overload this to allow the fade to happen properly
	override function onLoaded() {
		super.onLoaded();
		_loaded = false;
		loadCalled = true;
	}
}
