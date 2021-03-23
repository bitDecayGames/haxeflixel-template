package entities;

import input.InputCalcuator;
import input.BasicControls;
import flixel.util.FlxColor;
import flixel.FlxSprite;

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
		trace(inputDir);
		if (inputDir != null) {
			inputDir.asVector(velocity).scale(speed);
		} else {
			velocity.set();
		}
	}
}
