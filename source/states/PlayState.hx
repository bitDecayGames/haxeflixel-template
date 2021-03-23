package states;

import entities.Player;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxState;

using extensions.FlxStateExt;

class PlayState extends FlxState {
	var player:FlxSprite;

	override public function create() {
		super.create();
		FlxG.camera.pixelPerfectRender = true;

		player = new Player();
		add(player);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
	}

	override public function onFocusLost() {
		super.onFocusLost();
		this.handleFocusLost();
	}

	override public function onFocus() {
		super.onFocus();
		this.handleFocus();
	}
}
