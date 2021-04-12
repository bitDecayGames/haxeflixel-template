package states.transitions;

import flixel.FlxSubState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;

/**
 *  A FlxSubState that Fades in or out
 */
class FadeTransition extends FlxSubState {
	/**
	 *  Creates a new substate that fades in and closes
	 *  @param time			the amount of time to fade in
	 *  @param color		a color to show in place of black
	 *  @param onFinish		function to call once fade has finished
	 */
	public function new(dir:Trans, time:Float = 0.5, ?color:Int = 0xff000000, ?onFinish:() -> Void) {
		super();
		var fader = new FlxSprite();
		fader.makeGraphic(FlxG.width, FlxG.height, color);
		fader.scrollFactor.set();
		add(fader);

		var targetAlpha:Float;

		switch (dir) {
			case IN:
				fader.alpha = 1;
				targetAlpha = 0;
			case OUT:
				fader.alpha = 0;
				targetAlpha = 1;
		}

		FlxTween.tween(fader, {alpha: targetAlpha}, time).onComplete = function(t:FlxTween) {
			if (onFinish != null) {
				onFinish();
			}

			if (dir == IN) {
				close();
			}
		}
	}
}
