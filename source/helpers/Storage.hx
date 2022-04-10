package helpers;

import flixel.util.FlxSave;
import achievements.Achievements;

class Storage {
	private static var saveName:String = "SAVE";

	private static var achievements:Array<String>;
	private static var highscore:Float;

	private static var gameSave:FlxSave;

	public static function load():Void {
		gameSave = new FlxSave(); // initialize
		gameSave.bind(saveName); // bind to the named save slot
		var dirty = false;

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

	public static function delete():Void {
		gameSave.erase();
		achievements = [];
		Achievements.clearAchievements();
	}

	public static function saveHighscore(newHighscore:Float):Void {
		if (highscore < newHighscore) {
			highscore = newHighscore;
			gameSave.data.highscore = newHighscore;
			#if !debug
			gameSave.flush();
			#end
		}
	}

	public static function saveAchievement(achievementKey:String):Void {
		if (!achievements.contains(achievementKey)) {
			achievements.push(achievementKey);
			gameSave.data.achievements = achievements;
			#if !debug
			gameSave.flush();
			#end
		}
	}

	public static function hasAchievement(achievementKey:String):Bool {
		return achievements != null && achievements.contains(achievementKey);
	}
}
