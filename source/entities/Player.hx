package entities;

import loaders.Aseprite;
import loaders.AsepriteAnimations;
import input.SimpleController;
import input.InputCalcuator;
import flixel.FlxSprite;

class Player extends FlxSprite {
	public static var anims = AsepriteAnimations.loadNames("assets/images/characters/player.json");

	var speed:Float = 30;
	var playerNum = 0;

	public function new() {
		super();
		Aseprite.loadAllAnimations(this, AssetPaths.player__png, AssetPaths.player__json);
		animation.play(anims.left);
	}

	override public function update(delta:Float) {
		super.update(delta);

		var inputDir = InputCalcuator.getInputCardinal(playerNum);
		if (inputDir != NONE) {
			inputDir.asVector(velocity).scale(speed);
		} else {
			velocity.set();
		}

		if (SimpleController.just_pressed(Button.A, playerNum)) {
			color = color ^ 0xFFFFFF;
		}
	}
}
