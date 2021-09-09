package states.transitions;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.math.FlxPoint;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxTimer;
import openfl.display.BitmapData;
import openfl.display.BitmapDataChannel;
import openfl.geom.Point;
import openfl.geom.Rectangle;

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
		var radiusGetter:(num:Int) -> Int;
		var circleDrawer:(p:FlxPoint, d:Int) -> Void;
		var drawColor:Int;

		var drawStyle:DrawStyle = {
			smoothing: false
		};

		switch (dir) {
			case IN:
				FlxSpriteUtil.fill(s, color);
				drawColor = 0x00ffffff;
				drawStyle.blendMode = SUBTRACT;
				positionGetter = (num:Int) -> {
					return maxDistance * (num / totalCircles);
				}
				radiusGetter = (num:Int) -> {
					// add a little extra to prevent gaps between circles and to smooth things out
					return Std.int(minSpaceBetweenSwirls / 2 + (maxDistance * (num / totalCircles) / 5));
				};
				circleDrawer = (p, r) -> {
					// The provided circle drawing utilties don't respect alpha, so we need to use the `setPixel32` below.
					// This is using the formula for a half-cirlce to determine the pixels needed to be set to transparent
					// as a workaround.
					var sinInput = 0.0;
					var xOffset = 0;
					var height = 0;
					for (i in 0...2 * r) {
						sinInput = i / r * Math.PI;
						height = Std.int(Math.sqrt(Math.pow(r, 2) - Math.pow(i - r, 2)));
						xOffset = i - r;
						for (j in -height...height) {
							s.pixels.setPixel32(Std.int(p.x) + xOffset, Std.int(p.y) + j, drawColor);
						}
					}
				}
			case OUT:
				FlxSpriteUtil.fill(s, 0x00ffffff);
				drawColor = color;
				drawStyle.blendMode = NORMAL;
				positionGetter = (num:Int) -> {
					return maxDistance * ((totalCircles - num) / totalCircles);
				}
				radiusGetter = (num:Float) -> {
					// add a little extra to prevent gaps between circles and to smooth things out
					return Std.int(minSpaceBetweenSwirls / 2 + (maxDistance * ((totalCircles - num) / totalCircles) / 5));
				};
				circleDrawer = (p, r) -> {
					FlxSpriteUtil.drawCircle(s, p.x, p.y, r, drawColor, null, drawStyle);
				}
		}

		// Opting to go with many timers instead of one timer that loops many times as a timer can only
		// trigger once per update, meaning 'loops' may be dropped causing a less smooth swirl
		for (i in 0...totalCircles) {
			new FlxTimer().start(i * timePerCircle + 0.01).onComplete = function(t:FlxTimer) {
				var p = FlxPoint.get(FlxG.width * 0.5, FlxG.height * 0.5).pointOnCircumference(i * spacingDegs, positionGetter(i));
				circleDrawer(p, radiusGetter(i));
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
}
