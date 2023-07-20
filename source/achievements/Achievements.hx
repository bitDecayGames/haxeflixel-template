package achievements;

import achievements.AchievementToast;
import helpers.Analytics;
import helpers.Storage;

typedef AchievementID = Int;
class Achievements {
	public static var ACHIEVEMENT_NAME_HERE:AchievementDef;

	public static var ALL:Map<AchievementID, AchievementDef>;
	public static var ACHIEVEMENTS_DISPLAYED:Int = 0;

	public static function initAchievements() {
		ACHIEVEMENT_NAME_HERE = new AchievementDef("achievement_unique_key", "Achievement Title", "Sub-title", /* achievements_icon.png index */
			0, /* dynamic count: ie: get 10 items */ 0);

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
	public var count:Int;
	public var achieved:Bool;
	public var secret:Bool;

	private var soundPlaying = false;

	public function new(key:String, title:String, description:String, iconIndex:Int, count:Int = 0) {
		this.key = key;
		this.title = title;
		this.description = description;
		this.iconIndex = iconIndex;
		this.count = count;

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
