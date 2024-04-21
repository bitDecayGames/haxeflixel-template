package entities;

import flixel.util.FlxColor;
import bitdecay.behavior.tree.BTContext;
import behavior.PickLocationAwayFromMouse;
import behavior.MoveToLocation;
import behavior.CloseToMouse;
import behavior.PickRandomLocation;
import js.html.IntersectionObserver;
import bitdecay.behavior.tree.composite.Parallel;
import bitdecay.behavior.tree.composite.Parallel.Condition;
import bitdecay.behavior.tree.composite.Sequence;
import bitdecay.behavior.tree.composite.Selector;
import bitdecay.behavior.tree.composite.Selector.SelectorType;
import bitdecay.behavior.tree.leaf.util.Wait;
import bitdecay.behavior.tree.leaf.util.Success;
import bitdecay.behavior.tree.leaf.util.Failure;
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
	var speed:Float = 30;

	var behavior:BTree;
	
	public function new() {
		super();
		makeGraphic(20,20, FlxColor.RED);

		behavior = new BTree(new Repeater(FOREVER,
			new Sequence([
				new Sequence([
					new Wait(0.5, 1),
					new PickRandomLocation(),
					new Parallel(UNTIL_FIRST_SUCCESS, [
						new Repeater(UNTIL_SUCCESS,
							new CloseToMouse()
						),
						new MoveToLocation()
					])
				]),
				new Sequence([
					new CloseToMouse(),
					new PickLocationAwayFromMouse(),
					new MoveToLocation(),
				]),
				// TODO: Need to create an actual use case for this (i.e. some sort of enemy that randomly chooses what to do)
				new Selector(RANDOM([0.3, 0.5, 0.2]), [
					new Failure(),
					new Success(),
					new Success(),
				])
			])
		));

		var ctx = new BTContext();
		ctx.set("self", this);
		behavior.init(ctx);
	}

	override public function update(delta:Float) {
		super.update(delta);

		var status = behavior.process(delta);
		if (status != RUNNING) {
			trace('behavior ended with: ${status}');
		}
	}
}
