package states;

import flixel.FlxG;
import flixel.FlxState;

using extensions.FlxStateExt;

class PlayState extends FlxState {
	override public function create() {
		super.create();
        FlxG.camera.pixelPerfectRender = true;
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
