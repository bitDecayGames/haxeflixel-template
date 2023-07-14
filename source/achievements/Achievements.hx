package achievements;

import achievements.AchievementToast;
import flixel.FlxG;
import flixel.sound.FlxSound;
import helpers.Analytics;
import helpers.Storage;

class Achievements {
	public static var ACHIEVEMENT_NAME_HERE:AchievementDef;

	public static var ALL:Array<AchievementDef>;
	public static var ACHIEVEMENTS_DISPLAYED:Int = 0;

	public static function initAchievements() {
		ACHIEVEMENT_NAME_HERE = new AchievementDef("achievement_unique_key", "Achievement Title", "Sub-title", /* achievements_icon.png index */
			0, /* dynamic count: ie: get 10 items */ 0);

		// @formatter:off
		ALL = [
			ACHIEVEMENT_NAME_HERE
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

	private var sfx:Array<FlxSound> = [];

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

	private function soundDone() {
		soundPlaying = false;
	}

	private function initSounds() {
		sfx = [
			FlxG.sound.load(AssetPaths.Achieve1__ogg, soundDone),
			FlxG.sound.load(AssetPaths.Achieve2__ogg, soundDone),
			FlxG.sound.load(AssetPaths.Achieve3__ogg, soundDone),
			FlxG.sound.load(AssetPaths.Achieve4__ogg, soundDone),
			FlxG.sound.load(AssetPaths.Achieve5__ogg, soundDone),
		];
	}

	public function toToast(show:Bool, force:Bool = false):AchievementToast {
		if (sfx.length == 0) {
			initSounds();
		}

		var a = new AchievementToast(this);
		if (show) {
			if (!achieved || force) {
				if (!soundPlaying) {
					var sound = sfx[FlxG.random.int(0, sfx.length - 1)];
					sound.play(true);
					soundPlaying = true;
				}

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
