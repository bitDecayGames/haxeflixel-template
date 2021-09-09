package input;

import flixel.FlxG;
import flixel.input.keyboard.FlxKey;
import flixel.input.gamepad.FlxGamepadInputID;

/**
 * A Simple controller class to get you started
 * Mimics a famicom controller in scope.
 *
 * Lovingly adapted from https://github.com/01010111/flixel-template
 */
class SimpleController {
	static var key_bindings:Array<Map<Button, Array<FlxKey>>> = [
		// PLAYER ONE
		[
			UP => [FlxKey.UP, FlxKey.W],
			DOWN => [FlxKey.DOWN, FlxKey.S],
			LEFT => [FlxKey.LEFT, FlxKey.A],
			RIGHT => [FlxKey.RIGHT, FlxKey.D],
			A => [FlxKey.V],
			B => [FlxKey.C, FlxKey.B],
			START => [FlxKey.ENTER],
			BACK => [FlxKey.ESCAPE],
		],
		// PLAYER TWO
		[
			UP => [FlxKey.U],
			DOWN => [FlxKey.J],
			LEFT => [FlxKey.H],
			RIGHT => [FlxKey.K],
			A => [FlxKey.PERIOD],
			B => [FlxKey.SLASH],
		],
	];

	static var pad_bindings:Map<Button, Array<FlxGamepadInputID>> = [
		UP => [DPAD_UP],
		DOWN => [DPAD_DOWN],
		LEFT => [DPAD_LEFT],
		RIGHT => [DPAD_RIGHT],
		A => [A, Y],
		B => [B, X],
		START => [START],
		BACK => [BACK],
	];

	public static function pressed(button:Button, player:Int = 0):Bool {
		return pressed_key(button, player) || pressed_pad(button, player);
	}

	static function pressed_key(button:Button, player:Int):Bool {
		return FlxG.keys.anyPressed(key_bindings[player][button]);
	}

	static function pressed_pad(button:Button, player:Int):Bool {
		var gamepads = FlxG.gamepads.getActiveGamepads();
		if (gamepads.length < player || gamepads[player] == null)
			return false;
		return gamepads[player].anyPressed(pad_bindings[button]);
	}

	public static function just_pressed(button:Button, player:Int = 0):Bool {
		return just_pressed_key(button, player) || just_pressed_pad(button, player);
	}

	static function just_pressed_key(button:Button, player:Int):Bool {
		return FlxG.keys.anyJustPressed(key_bindings[player][button]);
	}

	static function just_pressed_pad(button:Button, player:Int):Bool {
		var gamepads = FlxG.gamepads.getActiveGamepads();
		if (gamepads.length < player || gamepads[player] == null)
			return false;
		return gamepads[player].anyJustPressed(pad_bindings[button]);
	}

	public static function just_released(button:Button, player:Int = 0):Bool {
		return just_released_key(button, player) || just_released_pad(button, player);
	}

	static function just_released_key(button:Button, player:Int):Bool {
		return FlxG.keys.anyJustReleased(key_bindings[player][button]);
	}

	static function just_released_pad(button:Button, player:Int):Bool {
		var gamepads = FlxG.gamepads.getActiveGamepads();
		if (gamepads.length < player || gamepads[player] == null)
			return false;
		return gamepads[player].anyJustReleased(pad_bindings[button]);
	}
}

enum Button {
	UP;
	DOWN;
	LEFT;
	RIGHT;
	A;
	B;
	START;
	BACK;
}

enum ButtonState {
	JUST_PRESSED;
	PRESSED;
	JUST_RELEASED;
}
