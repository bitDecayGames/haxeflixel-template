package states;

import flixel.tweens.misc.VarTween;
import flixel.tweens.FlxTween;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxG;

class SplashScreenState extends FlxState {
	var frame = 0;
	var frames:Array<FlxSprite> = [];

	var timer = 0.0;
	var frameDuration = 3.0;

	override public function create():Void {
		super.create();

		FlxG.debugger.drawDebug = true;

		// List splash screen frames here
		loadFrames([
			AssetPaths.bitdecaygamesinverted__png,
			AssetPaths.ld_logo__png
		]);

		timer = frameDuration;
		FlxTween.tween(frames[0], { alpha: 1 }, 1);
	}

	private function loadFrames(paths:Array<String>) {
		for (p in paths) {
			var splashSprite = new FlxSprite(0, 0, p);
			splashSprite.scale.x = FlxG.width / splashSprite.frameWidth;
			splashSprite.scale.y = FlxG.height / splashSprite.frameHeight;
			splashSprite.updateHitbox();
			add(splashSprite);
			splashSprite.alpha = 0;
			frames.push(splashSprite);
		}
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		timer -= elapsed;
		if (timer < 0)
			nextFrame();
	}

	public function nextFrame() {
		var tween:VarTween = FlxTween.tween(frames[frame], { alpha: 0 }, 0.5);

		frame += 1;
		timer = frameDuration;

		if (frame < frames.length) {
			var splash = frames[frame];
			tween.then(FlxTween.tween(splash, { alpha: 1 }, 1));
		} else {
			tween.onComplete = (t) -> {
					FlxG.switchState(new MainMenuState());
			};
		}
	}
}
