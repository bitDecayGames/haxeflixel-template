package ui;

import spacial.Cardinal;
import haxe.ui.core.Component;
import flixel.FlxSprite;

using extensions.FlxObjectExt;
using ui.ComponentExt;

class MenuCursor extends FlxSprite {
	public function new() {
		super();
		// TODO: Allow passing in of the sprite image
		loadGraphic(AssetPaths.pointer__png, true, 32, 32);
		animation.add("play", [0, 1], 3);
		animation.play("play");
	}

	public function alignWith(c:Component, alignment:Cardinal) {
		var cPos = c.recursivePosition();
		switch (alignment) {
			case NE | E | SE:
				cPos.x -= width;
			case NW | W | SW:
				cPos.x += c.width;
			default:
				cPos.x += Math.abs(c.width / 2 - width / 2);
		}
		switch (alignment) {
			case NE | N | NW:
				cPos.y -= height;
			case SE | S | SW:
				cPos.y += c.height;
			default:
				cPos.y -= Math.abs(c.height / 2 - height / 2);
		}
		this.setPositionPoint(cPos);
		cPos.put();
	}
}
