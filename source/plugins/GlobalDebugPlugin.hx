package plugins;

import states.demo.DemoSelectorState;
import flixel.FlxG;
import flixel.FlxBasic;

#if FLX_DEBUG
/**
 * Gives an entry point for any debug features we want available globally
 * while running the game.
**/
class GlobalDebugPlugin extends FlxBasic {
	override function update(elapsed:Float) {
		super.update(elapsed);

		if (FlxG.keys.justPressed.P) {
			FlxG.state.openSubState(new DemoSelectorState());
		}
	}
}
#end
