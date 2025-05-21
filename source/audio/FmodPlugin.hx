package audio;

import flixel.FlxBasic;

using FmodEventEnum.FmodEvent;

/**
 * Simple plugin to make sure FmodManager.update() gets called each frame.
 * Provides some helper functions to make playing events as simple as possible.
 * Feel free to make calls directly to `FmodManager` if desired.
**/
class FmodPlugin extends FlxBasic {
	static var ME:FmodPlugin;

	public function new() {
		super();
		ME = this;
	}

	/**
	 * Helper to play song and automatically convert the enum to an event string
	**/
	public static function playSong(song:FmodSong) {
		FmodManager.PlaySong(song.event());
	}

	/**
	 * Helper to play sfx and automatically convert the enum to an event string
	**/
	public static function playSFX(sfx:FmodSFX) {
		FmodManager.PlaySoundOneShot(sfx.event());
	}

	/**
	 * Helper to play sfx and automatically convert the enum to an event string
	 * 
	 * @returns the generated reference ID
	 * @see FmodManager.PlaySoundWithReference()
	**/
	public static function playSFXWithRef(sfx:FmodSFX):String {
		return FmodManager.PlaySoundWithReference(sfx.event());
	}

	/**
	 * Helper to play sfx and automatically convert the enum to an event string
	 * and assigns the provided ID
	 * 
	 * @returns the reference ID
	 * @see FmodManager.PlaySoundAndAssignID()
	**/
	public static function PlaySoundAndAssignId(sfx:FmodSFX, id:String):String {
		return FmodManager.PlaySoundAndAssignId(sfx.event(), id);
	}

	override function update(elapsed:Float) {
		super.update(elapsed);
		FmodManager.Update();
	}
}
