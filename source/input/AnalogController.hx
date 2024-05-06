package input;

import flixel.input.gamepad.FlxGamepadInputID;
import flixel.FlxG;

class AnalogController {
	public static function analog(axis:Axis, player:Int = 0):Float {
		var gamepads = FlxG.gamepads.getActiveGamepads();
		if (gamepads.length < player || gamepads[player] == null)
			return 0;
		return switch axis {
			case LEFT_STICK_X:
				gamepads[player].getXAxis(FlxGamepadInputID.LEFT_ANALOG_STICK);
			case LEFT_STICK_Y:
				gamepads[player].getYAxis(FlxGamepadInputID.LEFT_ANALOG_STICK);
			case RIGHT_STICK_X:
				gamepads[player].getXAxis(FlxGamepadInputID.RIGHT_ANALOG_STICK);
			case RIGHT_STICK_Y:
				gamepads[player].getYAxis(FlxGamepadInputID.RIGHT_ANALOG_STICK);
			case LEFT_TRIGGER:
				gamepads[player].getAxis(FlxGamepadInputID.LEFT_TRIGGER);
			case RIGHT_TRIGGER:
				gamepads[player].getAxis(FlxGamepadInputID.RIGHT_TRIGGER);
		};
	}
}

enum Axis {
	LEFT_STICK_X;
	LEFT_STICK_Y;
	RIGHT_STICK_X;
	RIGHT_STICK_Y;
	LEFT_TRIGGER;
	RIGHT_TRIGGER;
}
