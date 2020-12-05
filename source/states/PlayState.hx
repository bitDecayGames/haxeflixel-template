package states;

import flixel.FlxState;

using extensions.FlxStateExt;

class PlayState extends FlxState {
	override public function create() {
		super.create();
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
