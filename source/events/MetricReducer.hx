package events;

import flixel.util.FlxTimer;
import helpers.Storage;
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
	private static inline var STORAGE_KEY = 'metrics';
	private static var currentIntTrackers:Map<String, Int> = [];
	private static var currentFloatTrackers:Map<String, Float> = [];

	private static var flushTimer:FlxTimer = null;

	public static function init() {
		loadFromStorage();
		EventBus.subscribeAll(handleEvent);
	}

	public static function loadFromStorage() {
		var all:StoredMetrics = Storage.get(STORAGE_KEY);
		if (all == null) {
			return;
		}
		for (im in all.intMetrics) {
			currentIntTrackers.set(im.k, im.v);
		}
		for (fm in all.floatMetrics) {
			currentFloatTrackers.set(fm.k, fm.v);
		}
	}

	/**
	 * flushes current in-memory metrics to storage. May incur a performance
	 * hit. Use sparingly.
	**/
	public static function flush() {
		var forStorage:StoredMetrics = {
			intMetrics: [],
			floatMetrics: []
		};

		var ints = currentIntTrackers.keyValueIterator();
		while (ints.hasNext()) {
			var kv = ints.next();
			forStorage.intMetrics.push({
				k: kv.key,
				v: kv.value
			});
		}

		var floats = currentFloatTrackers.keyValueIterator();
		while (floats.hasNext()) {
			var kv = floats.next();
			forStorage.floatMetrics.push({
				k: kv.key,
				v: kv.value
			});
		}

		Storage.set(STORAGE_KEY, forStorage, true);
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

		// TODO: we want this to trigger an _eventual_ flush, not an immediate one
		flush();
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
			if (MetaRegistry.minIntEvents.exists(metricName)) {
				EventBus.fire(MetaRegistry.minIntEvents.get(metricName)(newValue));
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
			if (MetaRegistry.minFloatEvents.exists(metricName)) {
				EventBus.fire(MetaRegistry.minFloatEvents.get(metricName)(newValue));
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
			if (MetaRegistry.maxIntEvents.exists(metricName)) {
				EventBus.fire(MetaRegistry.maxIntEvents.get(metricName)(newValue));
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
			if (MetaRegistry.maxFloatEvents.exists(metricName)) {
				EventBus.fire(MetaRegistry.maxFloatEvents.get(metricName)(newValue));
			}
		}
	}
}

typedef StoredMetrics = {
	var intMetrics:Array<IntMetric>;
	var floatMetrics:Array<FloatMetric>;
}

typedef IntMetric = {
	var k:String;
	var v:Int;
}

typedef FloatMetric = {
	var k:String;
	var v:Float;
}
