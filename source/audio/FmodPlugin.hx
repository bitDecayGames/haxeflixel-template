package audio;

import flixel.FlxBasic;

// Simple plugin to make sure FmodManager.update() gets called each frame
class FmodPlugin extends FlxBasic {
	override function update(elapsed:Float) {
		super.update(elapsed);
		FmodManager.Update();
	}
}
