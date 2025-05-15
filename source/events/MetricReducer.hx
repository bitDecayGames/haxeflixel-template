package events;

import flixel.math.FlxMath;
import events.gen.Event.MetaRegistry;

/**
 * Listens for all events and automatically applies a reduction
 * to the event types. This fires a new event based on the reduction
 *
 * Supports:
 * - `*_count` - firing an event with a total of the event occurrences
 * - `*_max`   - firing an event if a new maximum value occurs
 * - `*_min`   - firing an event if a new minimum value occurs
**/
class MetricReducer {
	private static var currentIntTrackers:Map<String, Int> = [];
	private static var currentFloatTrackers:Map<String, Float> = [];

	public static function init() {
		EventBus.subscribeAll(handleEvent);
	}

	public static function loadFromStorage() {
		// TODO: pull existing values out of whatever storage mechanism is in place
	}

	static function handleEvent(e:IEvent):Void {
		switch (e.reducer) {
			case NONE:
				return;
			case COUNT:
				handleCount(e);
			case MIN(field):
				handleMin(e, field);
			case MAX(field):
				handleMax(e, field);
		}
	}

	private static function handleCount(e:IEvent) {
		var metricName = '${e.type}_count';
		var newValue = 1;
		if (currentIntTrackers.exists(metricName)) {
			newValue = currentIntTrackers.get(metricName) + 1;
		}
		currentIntTrackers.set(metricName, newValue);
		if (MetaRegistry.countEvents.exists(metricName)) {
			EventBus.fire(MetaRegistry.countEvents.get(metricName)(newValue));
		}
	}

	private static function handleMin(e:IEvent, field:String) {
		var metricName = '${e.type}_min';
		var eVal:Dynamic = Reflect.getProperty(e, field);
		if (Std.isOfType(eVal, Int)) {
			var newValue:Int = eVal;
			if (currentIntTrackers.exists(metricName)) {
				newValue = FlxMath.minInt(newValue, currentIntTrackers.get(metricName));
				if (newValue != eVal) {
					return;
				}
			}
			currentIntTrackers.set(metricName, newValue);
			if (MetaRegistry.minEvents.exists(metricName)) {
				EventBus.fire(MetaRegistry.minEvents.get(metricName)(newValue));
			}
		} else if (Std.isOfType(eVal, Float)) {
			var newValue:Float = eVal;
			if (currentFloatTrackers.exists(metricName)) {
				newValue = Math.min(newValue, currentFloatTrackers.get(metricName));
				if (newValue != eVal) {
					return;
				}
			}
			currentFloatTrackers.set(metricName, newValue);
			if (MetaRegistry.minEvents.exists(metricName)) {
				EventBus.fire(MetaRegistry.minEvents.get(metricName)(newValue));
			}
		}
	}

	private static function handleMax(e:IEvent, field:String) {
		var metricName = '${e.type}_max';
		// TODO: Still need to figure out how to handle Int vs Float
		var eVal:Dynamic = Reflect.getProperty(e, field);
		if (Std.isOfType(eVal, Int)) {
			var newValue:Int = eVal;
			if (currentIntTrackers.exists(metricName)) {
				newValue = FlxMath.maxInt(newValue, currentIntTrackers.get(metricName));
				if (newValue != eVal) {
					return;
				}
			}
			currentIntTrackers.set(metricName, newValue);
			if (MetaRegistry.maxEvents.exists(metricName)) {
				EventBus.fire(MetaRegistry.maxEvents.get(metricName)(newValue));
			}
		} else if (Std.isOfType(eVal, Float)) {
			var newValue:Float = eVal;
			if (currentFloatTrackers.exists(metricName)) {
				newValue = Math.max(newValue, currentFloatTrackers.get(metricName));
				if (newValue != eVal) {
					return;
				}
			}
			currentFloatTrackers.set(metricName, newValue);
			if (MetaRegistry.maxEvents.exists(metricName)) {
				EventBus.fire(MetaRegistry.maxEvents.get(metricName)(newValue));
			}
		}
	}
}
