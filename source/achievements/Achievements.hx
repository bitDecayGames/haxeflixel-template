package achievements;

import events.gen.Event.Achieve;
import events.gen.Event.ClickCount;
import events.gen.Event.SpeedClickMin;
import events.EventBus;
import events.IEvent;
import flixel.util.FlxSignal.FlxTypedSignal;
import achievements.AchievementToast;
import helpers.Analytics;
import helpers.Storage;

typedef AchievementID = Int;

class Achievements {
	public static var ALL:Map<AchievementID, AchievementDef> = [];
	public static var ACHIEVEMENTS_DISPLAYED:Int = 0;

	public static var onAchieve = new FlxTypedSignal<(AchievementDef) -> Void>();

	public static function initAchievements() {
		// @formatter:off
		add(new AchievementDef(1, "quick_clicker", "Quick Clicker", "Click twice in less than .2 seconds", 0, null).withEventCondition(SpeedClickMin, (e) -> {
			return e.min < 200;
		}));
		add(new AchievementDef(2, "mad_clicker", "Mad Clicker", "Click a total of 10 times", 0, null).withEventCondition(ClickCount, (e) -> {
			return e.count >= 10;
		}));
		// @formatter:on
	}

	static function add(def:AchievementDef) {
		if (ALL.exists(def.ID)) {
			QLog.error('Achievement ${def.ID} already registered');
		}
		def.init();
		ALL.set(def.ID, def);
	}

	public static function clearAchievements() {
		for (a in ALL) {
			a.achieved = false;
		}
	}
}

class AchievementDef {
	public var ID:Int; // mostly used to tie achievements to NG Medals
	public var key:String;
	public var title:String;
	public var description:String;
	public var iconIndex:Int;
	public var achieved:Bool = false;
	public var secret:Bool;

	public function new(id:Int, key:String, title:String, description:String, iconIndex:Int, ?secret:Bool = false) {
		this.ID = id;
		this.key = key;
		this.title = title;
		this.description = description;
		this.iconIndex = iconIndex;
		this.secret = secret;

		achieved = Storage.hasAchievement(key);
	}

	public function init() {}

	public function toToast(show:Bool, force:Bool = false):AchievementToast {
		var a = new AchievementToast(this);
		if (show) {
			FmodManager.PlaySoundOneShot(FmodSFX.MenuSelect);
			Achievements.ACHIEVEMENTS_DISPLAYED++;
			a.show(Achievements.ACHIEVEMENTS_DISPLAYED);
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

	public function withEventCondition<T:IEvent>(eventType:Class<T>, cb:(T) -> Bool):AchievementDef {
		if (achieved) {
			return this;
		}

		var wrapped:(IEvent) -> Void;
		wrapped = (e) -> {
			var result = cb(cast e);
			if (result) {
				achieved = true;
				EventBus.unsubscribe(eventType, wrapped);
				Storage.saveAchievement(key);
				EventBus.fire(new Achieve(key));
				Achievements.onAchieve.dispatch(this);
			}
		}
		EventBus.subscribe(eventType, wrapped);
		return this;
	}
}
