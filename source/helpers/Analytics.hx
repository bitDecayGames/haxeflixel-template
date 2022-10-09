package helpers;

import com.bitdecay.metrics.Tag;
import com.bitdecay.analytics.Bitlytics;

class Analytics {
	private static var METRIC_PRACTICE_TIME = "practice_time";

	private static var METRIC_VICTORY = "victory";
	private static var METRIC_VICTORY_ITEM_COUNT = "victory_item_count";
	private static var METRIC_VICTORY_TIME = "victory_time";

	private static var METRIC_FAILURE = "failure";
	private static var METRIC_FAILURE_ITEM_COUNT = "failure_item_count";
	private static var METRIC_FAILURE_TIME = "failure_time";

	private static var METRIC_ACHIEVEMENT = "achievement";

	private static var TAG_ACHIEVEMENT_NAME = "name_key";

	public static function reportAchievement(key:String) {
		Bitlytics.Instance().Queue(METRIC_ACHIEVEMENT, 1, [new Tag(TAG_ACHIEVEMENT_NAME, key)]);
	}

	public static function reportWin(itemCount:Int, time:Float) {
		Bitlytics.Instance().Queue(METRIC_VICTORY, 1);
		Bitlytics.Instance().Queue(METRIC_VICTORY_ITEM_COUNT, itemCount);
		Bitlytics.Instance().Queue(METRIC_VICTORY_TIME, time);
	}

	public static function reportLoss(itemCount:Int, precentComplete:Float, time:Float) {
		Bitlytics.Instance().Queue(METRIC_FAILURE, precentComplete);
		Bitlytics.Instance().Queue(METRIC_FAILURE_ITEM_COUNT, itemCount);
		Bitlytics.Instance().Queue(METRIC_FAILURE_TIME, time);
	}

	public static function reportPracticeSession(time:Float) {
		Bitlytics.Instance().Queue(METRIC_PRACTICE_TIME, time);
	}
}
