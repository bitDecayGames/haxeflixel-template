package extensions;

import config.Configure;
import com.bitdecay.analytics.Bitlytics;
import flixel.FlxG;
import flixel.FlxState;

/**
 * General helpers for adding convenience functions onto FlxState
 */
class FlxStateExt {
	/**
	 * Handles any common cleanup needed when focus is lost, including
	 * FMOD and Bitlytics properly paused
	 */
	public static function handleFocusLost(state:FlxState) {
		#if debug
		trace("lost focus: ignoring due to debug");
		#else
		Bitlytics.Instance().Pause();
		FmodManager.PauseAllSounds();
		#end
	}

	/**
	 * Handles any common cleanup needed when focus is regained, including
	 * FMOD and Bitlytics properly resuming
	 */
	public static function handleFocus(state:FlxState) {
		#if debug
		trace("regain focus: ignoring due to debug");
		#else
		Bitlytics.Instance().Resume();
		FmodManager.UnpauseAllSounds();
		#end

		FlxG.mouse.visible = Configure.config.mouse.cursorVisible;
		FlxG.mouse.useSystemCursor = Configure.config.mouse.useSystemCursor;
	}
}
