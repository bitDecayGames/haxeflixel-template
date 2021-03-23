package input;

import flixel.math.FlxVector;
import spacial.Cardinal;

class InputCalcuator {
	private static var temp = FlxVector.get();

	/**
	 * Gets the closest cardinal direction as defined by the Cardinal enum, or null
	 * if no direction is pressed
	**/
	public static function getInputCardinal(controls:BasicControls):Cardinal {
		temp.set();

		if (controls.up.check()) {
			temp.add(0, -1);
		}

		if (controls.down.check()) {
			temp.add(0, 1);
		}

		if (controls.left.check()) {
			temp.add(-1, 0);
		}

		if (controls.right.check()) {
			temp.add(1, 0);
		}

		if (temp.length == 0) {
			return null;
		}

		return Cardinal.closest(temp);
	}
}
