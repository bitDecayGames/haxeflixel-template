package states;

import flixel.system.FlxAssets.FlxGraphicAsset;
import config.Configure;
import haxefmod.flixel.FmodFlxUtilities;
import flixel.tweens.misc.VarTween;
import flixel.tweens.FlxTween;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxG;

class SplashScreenState extends FlxState {
	public static inline var PLAY_ANIMATION = "play";

	var index = 0;
	var splashImages:Array<FlxSprite> = [];

	var timer = 0.0;
	var splashDuration = 3.0;

	override public function create():Void {
		super.create();

		// List splash screen image paths here
		loadSplashImages([
			new SplashImage(AssetPaths.bitdecaygamesinverted__png),
			new SplashImage(AssetPaths.ld_logo__png)
		]);

		timer = splashDuration;
		fadeIn(index);

		Configure.initAnalytics();
	}

	private function loadSplashImages(splashes:Array<SplashImage>) {
		for (s in splashes) {
			add(s);
			s.alpha = 0;
			splashImages.push(s);
		}
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		timer -= elapsed;
		if (timer < 0)
			nextSplash();
	}

	private function fadeIn(index:Int):VarTween {
		var splash = splashImages[index];
		var fadeInTween = FlxTween.tween(splash, { alpha: 1 }, 1);
		if (splash.animation.getByName(PLAY_ANIMATION) != null) {
			fadeInTween.onComplete = (t) -> splash.animation.play(PLAY_ANIMATION);
			splash.animation.callback = (name, frameNumber, frameIndex) -> {
				// Can add sfx or other things here
			}
		}
		return fadeInTween;
	}

	public function nextSplash() {
		var tween:VarTween = FlxTween.tween(splashImages[index], { alpha: 0 }, 0.5);

		index += 1;
		timer = splashDuration;

		if (index < splashImages.length) {
			tween.then(fadeIn(index));
		} else {
			tween.onComplete = (t) -> {
				FmodFlxUtilities.TransitionToState(new MainMenuState());
			};
		}
	}
}

class SplashImage extends FlxSprite{

	public function new(gfx:FlxGraphicAsset, width:Int = 0, height:Int = 0, startFrame:Int = 0, endFrame:Int = -1, rate:Int = 10) {
		super(gfx);
		var animated = width != 0 && height != 0;
		loadGraphic(gfx, animated, width, height);
		animation.add(SplashScreenState.PLAY_ANIMATION, [for (i in startFrame...endFrame) i], rate, false);

		if (animated) {
			scale.set(FlxG.width / width, FlxG.height / height);
		} else {
			scale.set(FlxG.width / frameWidth, FlxG.height / frameHeight);
		}
		
		updateHitbox();
	}
}
