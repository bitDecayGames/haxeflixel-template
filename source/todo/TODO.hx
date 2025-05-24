package todo;

import flixel.FlxG;

/**
 * A development helper class to make finding needed assets easier
**/
class TODO {
	#if debug
	// Config
	static var MAX_CALLS = 5;
	static var TIME_WINDOW_MS = 1000;

	// Map of name -> list of timestamps
	static var callTimes = new Map<String, Array<Int>>();
	static var previouslyWarned = new Map<String, Bool>();
	#end

	public static inline function sfx(name:String) {
		#if debug
		if (previouslyWarned.exists(name)) {
			return;
		}
		var now = FlxG.game.ticks;

		if (!callTimes.exists(name)) {
			callTimes.set(name, []);
		}

		var times = callTimes.get(name);

		// Remove old entries
		times = times.filter(t -> now - t <= TIME_WINDOW_MS);
		callTimes.set(name, times); // Reassign filtered list

		if (times.length >= MAX_CALLS) {
			QLog.warn('SFX "$name" called too often. Make sure this is not in a tight loop');
			previouslyWarned.set(name, true);
			return;
		}

		times.push(now);
		#else
		QLog.warn('SFX "$name" yet to be implemented');
		#end
	}

	public static inline function music(name:String) {
		#if debug
		// TODO... make the TODO
		#else
		QLog.warn('Music "$name" yet to be implemented');
		#end
	}
}
