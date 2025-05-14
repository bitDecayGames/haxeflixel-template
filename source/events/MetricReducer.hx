package events;

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
		GameEvents.subscribeAll(handleEvent);
	}

	public static function loadFromStorage() {
		// TODO: pull existing values out of whatever storage mechanism is in place
	}

	static function handleEvent(e:IEvent):Void {
		switch (e.reducer) {
			case NONE:
				return;
			case COUNT:
				var metricName = '${e.type}_count';
				var newValue = 1;
				if (currentIntTrackers.exists(metricName)) {
					newValue = currentIntTrackers.get(metricName) + 1;
				}
				currentIntTrackers.set(metricName, newValue);
				if (MetaRegistry.countEvents.exists(metricName)) {
					GameEvents.fire(MetaRegistry.countEvents.get(metricName)(newValue));
				}
			case MIN(field):
			case MAX(field):
				var metricName = '${e.type}_max';
				// TODO: Still need to figure out how to handle Int vs Float
				var eVal:Float = cast Reflect.getProperty(e, field);
				var newValue = eVal;
				if (currentFloatTrackers.exists(metricName)) {
					newValue = Math.max(newValue, currentFloatTrackers.get(metricName));
					if (newValue != eVal) {
						return;
					}
				}
				currentFloatTrackers.set(metricName, newValue);
				if (MetaRegistry.maxEvents.exists(metricName)) {
					GameEvents.fire(MetaRegistry.maxEvents.get(metricName)(newValue));
				}
		}
	}
}
