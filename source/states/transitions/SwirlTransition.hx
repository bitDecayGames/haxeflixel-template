package states.transitions;

import openfl.display.BitmapDataChannel;
import openfl.display.BitmapDataChannel;
import openfl.geom.Point;
import openfl.geom.ColorTransform;
import openfl.display.BitmapData;
import openfl.display.Graphics;
import openfl.display.Sprite;
import openfl.geom.Rectangle;
import flixel.util.FlxColor;
import flixel.FlxSubState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxTimer;

using Math;
using extensions.FlxPointExt;

/**
 *  A FlxSubState that creates a swirl effect then closes
 */
class SwirlTransition extends FlxSubState {
	/**
	 *  Creates a new substate that creates a swirl effect and closes
	 *  @param dir			transition direction
	 *  @param onFinish	function to call when transition is complete
	 *  @param color		a color to show in place of black
	 *  @param duration		how long the transition should take to complete
	 */
	public function new(dir:Trans, onFinish:Void->Void, color:Int = 0xff000000, duration:Float = 2) {
		super();

		var s:FlxSprite = new FlxSprite();
		s.makeGraphic(FlxG.width, FlxG.height, 0x00ffffff);
		s.scrollFactor.set();
		add(s);

		var t = 0.0;
		var totalCircles = (FlxG.width).round();
		var timePerCircle = duration / totalCircles;

		var maxDistance = FlxG.width * 0.8;
		var spacingDegs = 5;

		var totalSwirls = (totalCircles * spacingDegs) / 360;
		var minSpaceBetweenSwirls = maxDistance / totalSwirls;

		var positionGetter:(num:Int) -> Float;
		var diameterGetter:(num:Int) -> Float;
		var drawColor:Int;

		var drawStyle:DrawStyle = {
			smoothing: false
		};

		switch (dir) {
			case IN:
				// TODO: This doesn't work until we can figure out how transparency can be
				//       made to work.
				// SEE: http://coinflipstudios.com/devblog/?p=421 (though it doesn't seem to work)
				FlxSpriteUtil.fill(s, color);
				drawColor = 0x3300ffff;
				drawStyle.blendMode = SUBTRACT;
				positionGetter = (num:Int) -> {
					return maxDistance * (num / totalCircles);
				}
				diameterGetter = (num:Float) -> {
					// add a little extra to prevent gaps between circles and to smooth things out
					minSpaceBetweenSwirls / 2 + (maxDistance * (num / totalCircles) / 5);
				};
			case OUT:
				FlxSpriteUtil.fill(s, 0x00ffffff);
				drawColor = color;
				drawStyle.blendMode = NORMAL;
				positionGetter = (num:Int) -> {
					return maxDistance * ((totalCircles - num) / totalCircles);
				}
				diameterGetter = (num:Float) -> {
					// add a little extra to prevent gaps between circles and to smooth things out
					minSpaceBetweenSwirls / 2 + (maxDistance * ((totalCircles - num) / totalCircles) / 5);
				};
		}

		// Opting to go with many timers instead of one timer that loops many times as a timer can only
		// trigger once per update, meaning 'loops' may be dropped causing a less smooth swirl
		for (i in 0...totalCircles) {
			new FlxTimer().start(i * timePerCircle + 0.01).onComplete = function(t:FlxTimer) {
				var p = FlxPoint.get(FlxG.width * 0.5, FlxG.height * 0.5).pointOnCircumference(i * spacingDegs, positionGetter(i));
				FlxSpriteUtil.drawCircle(s, p.x, p.y, diameterGetter(i), drawColor, null, drawStyle);
			}
			t += timePerCircle;
		}

		new FlxTimer().start(t + 0.01).onComplete = function(t:FlxTimer) {
			onFinish();
			if (dir == IN) {
				// Only really need to close this on transitioning in to a state
				close();
			}
		}
	}

	function invertedAlphaMaskFlxSprite(sprite:FlxSprite, mask:FlxSprite, output:FlxSprite):FlxSprite {
		// Solution based on the discussion here:
		// https://groups.google.com/forum/#!topic/haxeflixel/fq7_Y6X2ngY

		// NOTE: The code below is the same as FlxSpriteUtil.alphaMaskFlxSprite(),
		// except it has an EXTRA section below.

		sprite.drawFrame();
		var data:BitmapData = sprite.pixels.clone();
		data.copyChannel(mask.pixels, new Rectangle(0, 0, sprite.width, sprite.height), new Point(), BitmapDataChannel.ALPHA, BitmapDataChannel.ALPHA);

		// EXTRA:
		// this code applies a -1 multiplier to the alpha channel,
		// turning the opaque circle into a transparent circle.
		// data.colorTransform(new Rectangle(0, 0, sprite.width, sprite.height), new ColorTransform(0,0,0,-1,0,0,0,255));
		// end EXTRA

		output.pixels = data;
		return output;
	}
}
