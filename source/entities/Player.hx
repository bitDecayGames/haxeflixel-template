package entities;

import input.InputCalcuator;
import input.BasicControls;
import flixel.util.FlxColor;
import flixel.FlxSprite;

using extensions.FlxObjectExt;

class Player extends FlxSprite {
	var speed:Float = 30;
	var controls:BasicControls;

	public function new() {
		super();
		makeGraphic(20, 20, FlxColor.BLUE);

		controls = new BasicControls();
	}

	override public function update(delta:Float) {
		super.update(delta);

		var inputDir = InputCalcuator.getInputCardinal(controls);
		if (inputDir != NONE) {
			inputDir.asVector(velocity).scale(speed);
		} else {
			velocity.set();
		}
	}
}
