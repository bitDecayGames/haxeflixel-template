package preload;

import flixel.system.FlxBasePreloader;

/**
 * Custom preloader
 */
class BitdecayPreloader extends FlxBasePreloader {
	private var frameCount:Int = 0;
	private var inited:Bool = false;

	public function new(MinDisplayTime:Float = 0, ?AllowedURLs:Array<String>) {
		super(MinDisplayTime, ["https://bitdecaygames.itch.io/", FlxBasePreloader.LOCAL]);
	}

	override function create():Void {
		super.create();
		// FMOD must be initialized before the game starts for audio to work properly
		FmodManager.Initialize();
	}

	override function onLoaded() {
		super.onLoaded();
		_loaded = _loaded && FmodManager.IsInitialized();
	}
}
