package entities;

import behavior.PickRandomLocation;
import js.html.IntersectionObserver;
import bitdecay.behavior.tree.composite.Parallel;
import bitdecay.behavior.tree.composite.Parallel.Condition;
import bitdecay.behavior.tree.composite.Sequence;
import bitdecay.behavior.tree.leaf.util.Wait;
import bitdecay.behavior.tree.decorator.basic.Invert;
import bitdecay.behavior.tree.decorator.Repeater;
import bitdecay.behavior.tree.decorator.Repeater.RepeatType;
import bitdecay.behavior.tree.BTree;
import flixel.FlxSprite;

import input.InputCalcuator;
import input.SimpleController;
import loaders.Aseprite;
import loaders.AsepriteMacros;

class ShooterEnemy extends FlxSprite {
	public static var anims = AsepriteMacros.tagNames("assets/aseprite/characters/player.json");
	public static var layers = AsepriteMacros.layerNames("assets/aseprite/characters/player.json");
	public static var eventData = AsepriteMacros.frameUserData("assets/aseprite/characters/player.json", "Layer 1");

	var speed:Float = 30;
	var playerNum = 0;

	public function new() {
		super();
		// This call can be used once https://github.com/HaxeFlixel/flixel/pull/2860 is merged
		// FlxAsepriteUtil.loadAseAtlasAndTags(this, AssetPaths.player__png, AssetPaths.player__json);
		Aseprite.loadAllAnimations(this, AssetPaths.player__json);
		animation.play(anims.right);
		animation.callback = (anim, frame, index) -> {
			if (eventData.exists(index)) {
				trace('frame $index has data ${eventData.get(index)}');
			}
		};

		var btree = new BTree(new Repeater(
			new Sequence([
				new Sequence([
					new Wait(0.5, 1),
					new PickRandomLocation(),
					new Parallel(ON_FIRST_FAIL, [
						new Repeater(UNTIL_FAIL,
							new Invert(new CloseToMouse())
						),
						new MoveToLocation()
					])
				]),
				new Sequence([
					new CloseToMouse(),
					new PickLocationAwayFromMouse(),
					new MoveToLocation(),
				])
			])
		));
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
