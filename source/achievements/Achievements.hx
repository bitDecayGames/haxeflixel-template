package achievements;

import flixel.util.FlxSignal.FlxTypedSignal;
import achievements.AchievementToast;
import helpers.Analytics;
import helpers.Storage;

typedef AchievementID = Int;

class Achievements {
	public static var ACHIEVEMENT_NAME_HERE:AchievementDef;

	public static var ALL:Map<AchievementID, AchievementDef>;
	public static var ACHIEVEMENTS_DISPLAYED:Int = 0;

	public static var onEvent = new FlxTypedSignal<(String, Int) -> Void>();

	public static function initAchievements() {
		ACHIEVEMENT_NAME_HERE = new AchievementDef("achievement_unique_key", "Achievement Title", "Sub-title", /* achievements_icon.png index */ 0,
			COUNT_AT_LEAST('test metric', 5));

		// @formatter:off
		ALL = [
			1 => ACHIEVEMENT_NAME_HERE,
		];
		// @formatter:on
	}

	public static function clearAchievements() {
		for (a in ALL) {
			a.achieved = false;
		}
	}
}

class AchievementDef {
	public var key:String;
	public var title:String;
	public var description:String;
	public var iconIndex:Int;
	public var condition:AchieveCondition;
	public var achieved:Bool;
	public var secret:Bool;

	public function new(key:String, title:String, description:String, iconIndex:Int, condition:AchieveCondition, ?secret:Bool = false) {
		this.key = key;
		this.title = title;
		this.description = description;
		this.iconIndex = iconIndex;
		this.condition = condition;
		this.secret = secret;

		// check local storage to see if they have already achieved this achievement
		achieved = Storage.hasAchievement(key);
	}

	public function toToast(show:Bool, force:Bool = false):AchievementToast {
		var a = new AchievementToast(this);
		if (show) {
			if (!achieved || force) {
				FmodManager.PlaySoundOneShot(FmodSFX.MenuSelect);
				Achievements.ACHIEVEMENTS_DISPLAYED++;
				a.show(Achievements.ACHIEVEMENTS_DISPLAYED);
				Analytics.reportAchievement(this.key);
				Storage.saveAchievement(key);
				achieved = true;
			} else {
				// if you already have the achievement, then don't actually display it
				a.active = false;
			}
		} else {
			// if you get into this block, it means you are showing the achievement badge
			// in something like a list of achievements, so dim the achievement if you
			// haven't acquired it
			if (!achieved) {
				a.dim();
			}
		}
		return a;
	}
}

enum AchieveCondition {
	/**
	 * Met once metric is equal to val (or greater)
	**/
	COUNT_AT_LEAST(metric:String, val:Int);

	/**
	 * Met once the event occurs, regardless of value
	**/
	EVENT_OCCURRED(metric:String);
}
