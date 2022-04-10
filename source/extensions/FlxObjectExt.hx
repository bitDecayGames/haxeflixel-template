package extensions;

import flixel.math.FlxPoint;
import flixel.FlxObject;

/**
 * General helpers for adding convenience functions onto FlxObject
 */
class FlxObjectExt {
	/**
	 * Sets the FlxObject position such that the midpoint is at (x,y)
	 *
	 * @param   x   The new x position for midpoint
	 * @param   y   The new x position for midpoint
	 */
	static public function setPositionMidpoint(o:FlxObject, x:Float, y:Float) {
		o.setPosition(x - o.width / 2, y - o.height / 2);
	}

	/**
	 * Sets the FlxObject position from the given point
	 *
	 * @param p	The point for the new position
	 */
	static public function setPositionPoint(o:FlxObject, p:FlxPoint) {
		o.setPosition(p.x, p.y);
	}
}
