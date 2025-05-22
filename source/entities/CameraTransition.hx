package entities;

import bitdecay.flixel.spacial.Cardinal;
import flixel.math.FlxRect;
import flixel.FlxObject;

/**
 * A zone to facilitate moving between camera bounding zones
**/
class CameraTransition extends FlxObject {
	/**
	 * the world-space zone that drives the transition
	**/
	public var zone:FlxRect;

	/**
	 * The camera bounding boxes associated with which sides of the `zone`
	**/
	public var camGuides = new Map<Cardinal, FlxRect>();

	public function new(area:FlxRect) {
		super(area.x, area.y);
		setSize(area.width, area.height);

		zone = area;
	}

	public function addGuideTrigger(dir:Cardinal, zone:FlxRect) {
		camGuides.set(dir, zone);
	}
}
