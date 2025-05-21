package entities;

import bitdecay.flixel.spacial.Cardinal;
import flixel.math.FlxRect;
import flixel.FlxObject;

class CameraTransition extends FlxObject {
	public var zone:FlxRect;
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
