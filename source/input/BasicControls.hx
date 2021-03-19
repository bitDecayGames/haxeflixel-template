package input;

import flixel.FlxG;
import flixel.input.actions.FlxAction.FlxActionDigital;
import flixel.input.actions.FlxActionManager;

class BasicControls {
	static var actions:FlxActionManager;

	public var up:FlxActionDigital;
	public var down:FlxActionDigital;
	public var left:FlxActionDigital;
	public var right:FlxActionDigital;

	public var mainAction:FlxActionDigital;
	public var secondaryAction:FlxActionDigital;

	public var pause:FlxActionDigital;

	public function new()
	{
		up = new FlxActionDigital("up");
		down = new FlxActionDigital("down");
		left = new FlxActionDigital("left");
		right = new FlxActionDigital("right");

		mainAction = new FlxActionDigital("mainAction");
		secondaryAction = new FlxActionDigital("secondaryAction");

		pause = new FlxActionDigital("pause");

		if (actions == null)
		{
			actions = FlxG.inputs.add(new FlxActionManager());
		}
		actions.addActions([up, down, left, right, mainAction, secondaryAction, pause]);

		up.addKey(W, PRESSED);
		up.addKey(UP, PRESSED);
		down.addKey(S, PRESSED);
		down.addKey(DOWN, PRESSED);
		left.addKey(A, PRESSED);
		left.addKey(LEFT, PRESSED);
		right.addKey(D, PRESSED);
		right.addKey(RIGHT, PRESSED);

		mainAction.addKey(Z, PRESSED);
		mainAction.addKey(M, PRESSED);

		secondaryAction.addKey(X, PRESSED);
		secondaryAction.addKey(N, PRESSED);

		pause.addGamepad(START, PRESSED);

		#if !FLX_NO_GAMEPAD
		up.addGamepad(DPAD_UP, PRESSED);
		down.addGamepad(DPAD_DOWN, PRESSED);
		left.addGamepad(DPAD_LEFT, PRESSED);
		right.addGamepad(DPAD_RIGHT, PRESSED);

		mainAction.addGamepad(A, PRESSED);
		secondaryAction.addGamepad(B, PRESSED);

		pause.addGamepad(START, PRESSED);
		#end
	}
}
