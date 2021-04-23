package ui;

import flixel.FlxSprite;

class MenuCursor extends FlxSprite {
	public function new() {
		super();
		loadGraphic(AssetPaths.pointer__png, true, 32, 32);
		animation.add("play", [0, 1], 3);
		animation.play("play");
	}
}