package entities;

import bitdecay.flixel.graphics.Aseprite;
import bitdecay.flixel.graphics.AsepriteMacros;
import flixel.FlxSprite;

class Item extends FlxSprite {
	public static var slices = AsepriteMacros.sliceNames("assets/aseprite/items.json");

	public function new() {
		super();
		Aseprite.loadSlice(this, AssetPaths.items__json, slices.item1_0);
	}

	override public function update(delta:Float) {
		super.update(delta);
	}
}
