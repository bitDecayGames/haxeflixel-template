package helpers;

import flixel.util.FlxSave;
import achievements.Achievements;

/**
 * Responsible for basic storage of game data.
**/
class Storage {
	private static var saveName:String = "SAVE";

	private static var achievements:Array<String>;
	private static var highscore:Float;

	private static var gameSave:FlxSave;

	public static function load():Void {
		gameSave = new FlxSave(); // initialize
		gameSave.bind(saveName); // bind to the named save slot
		var dirty = false;

		#if clearStorage
		gameSave.erase();
		#end

		// if gameSave.data.____ does not exist, initialize the starting value
		if (gameSave.data.highscore == null) {
			gameSave.data.highscore = 0.0;
			dirty = true;
		}
		if (gameSave.data.achievements == null) {
			gameSave.data.achievements = new Array<String>();
			dirty = true;
		}
		if (dirty) {
			#if !debug
			gameSave.flush();
			#end
		}

		highscore = gameSave.data.highscore;
		achievements = gameSave.data.achievements;
	}

	/**
	 * Loads a given key from storage, returning whatever is stored.
	 * Returns null if the key is not present.
	**/
	public static function get(key:String):Dynamic {
		var d:haxe.DynamicAccess<Dynamic> = gameSave.data;
		return d.get(key);
	}

	/**
	 * Sets a storage key to the provided value. Optionally flushes
	 * to storage immediately
	**/
	public static function set(key:String, value:Dynamic, flush:Bool = false):Void {
		var d:haxe.DynamicAccess<Dynamic> = gameSave.data;
		d.set(key, value);
		if (flush) {
			gameSave.flush();
		}
	}

	public static function delete():Void {
		gameSave.erase();
		achievements = [];
		Achievements.clearAchievements();
	}

	public static function saveHighscore(newHighscore:Float):Void {
		if (highscore < newHighscore) {
			highscore = newHighscore;
			gameSave.data.highscore = newHighscore;
			gameSave.flush();
		}
	}

	public static function saveAchievement(achievementKey:String):Void {
		if (!achievements.contains(achievementKey)) {
			achievements.push(achievementKey);
			gameSave.data.achievements = achievements;
			gameSave.flush();
		}
	}

	public static function hasAchievement(achievementKey:String):Bool {
		return achievements != null && achievements.contains(achievementKey);
	}
}
