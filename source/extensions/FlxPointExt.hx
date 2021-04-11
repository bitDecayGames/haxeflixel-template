package extensions;

import flixel.math.FlxAngle;
import flixel.math.FlxPoint;

class FlxPointExt {
	/**
	 *  returns a new point on the circumference of a circle
	 *  @param point	center point
	 *  @param angle	angle from center in degrees
	 *  @param radius	radius/distance from center
	 *  @return			FlxPoint
	 */
	public static inline function pointOnCircumference(point:FlxPoint, angle:Float, radius:Float):FlxPoint {
		return FlxPoint.get(point.x + radius * Math.cos(angle * FlxAngle.TO_RAD), point.y + radius * Math.sin(angle * FlxAngle.TO_RAD));
	}
}
