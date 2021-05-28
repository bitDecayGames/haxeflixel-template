package states;

import config.Configure;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.tweens.FlxTween;
import flixel.tweens.misc.VarTween;
import haxefmod.flixel.FmodFlxUtilities;

using extensions.FlxStateExt;

class SplashScreenState extends FlxState {
	public static inline var PLAY_ANIMATION = "play";

	var index = 0;
	var splashImages:Array<FlxSprite> = [];

	var timer = 0.0;
	var splashDuration = 3.0;

	var currentTween:FlxTween = null;
	var splashesOver:Bool = false;
	var fadingOut:Bool = false;

	override public function create():Void {
		super.create();

		// List splash screen image paths here
		loadSplashImages([
			new SplashImage(AssetPaths.bitdecaygamesinverted__png),
			new SplashImage(AssetPaths.ld_logo__png)
		]);

		timer = splashDuration;
		currentTween = getFadeIn(index);
	}

	// A function that returns if the current splash should be skipped or not
	// Customize this to check whatever we want (controller, mouse, etc)
	private function checkForSkip():Bool {
		var skip = false;
		if (Configure.config.menus.keyboardNavigation) {
			skip = skip || FlxG.keys.justPressed.SPACE || FlxG.keys.justPressed.ENTER;
		}
		if (Configure.config.menus.controllerNavigation) {
			var gamepad = FlxG.gamepads.lastActive;
			if (gamepad != null) {
				skip = skip || gamepad.justPressed.A;
			}
		}
		return skip || FlxG.mouse.justPressed;
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
		var playerSkipped = !fadingOut && !splashesOver && Configure.config.splashScreens.allowClickToSkip && checkForSkip();
		if (timer < 0 || playerSkipped) {
			nextSplash();
		}
	}

	private function getFadeIn(index:Int):VarTween {
		var splash = splashImages[index];
		var fadeInTween = FlxTween.tween(splash, {alpha: 1}, 1);
		fadeInTween.onStart = (t) -> {
			fadingOut = false;
		};
		if (splash.animation.getByName(PLAY_ANIMATION) != null) {
			fadeInTween.onComplete = (t) -> splash.animation.play(PLAY_ANIMATION);
			splash.animation.callback = (name, frameNumber, frameIndex) -> {
				// Can add sfx or other things here
			};
		}
		return fadeInTween;
	}

	public function nextSplash() {
		if (splashesOver) {
			// nothing more to do
			return;
		}

		if (currentTween != null && !currentTween.finished) {
			currentTween.cancel();
		}

		fadingOut = true;
		currentTween = FlxTween.tween(splashImages[index], {alpha: 0}, 0.5);

		index += 1;
		timer = splashDuration;

		if (index < splashImages.length) {
			currentTween.then(getFadeIn(index));
		} else {
			splashesOver = true;
			currentTween.onComplete = (t) -> {
				FmodFlxUtilities.TransitionToState(new MainMenuState());
			};
		}
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

class SplashImage extends FlxSprite {
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
