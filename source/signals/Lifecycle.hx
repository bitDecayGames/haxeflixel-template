package signals;

import flixel.util.FlxSignal;

class Lifecycle {
	/**
	 * Startup signals will be called once the game is loaded and Flixel is initialized
	 */
	public static var startup:FlxSignal = new FlxSignal();
}
