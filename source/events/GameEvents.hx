package events;

/**
 * A basic event bus. Can be used to fire game events.
 * Clients can subscribe to any kind of event and receive
 * a callback when a matching event is fired.
**/
class GameEvents {
	private static var nextID = 1;

	private static var subAllListeners:Array<(IEvent) -> Void> = [];
	private static var listeners:Map<String, Array<(IEvent) -> Void>> = [];

	public static function init() {
		// TODO: Any initialization needed? Such as loading storage data
	}

	public static function subscribeAll(cb:(IEvent) -> Void) {
		subAllListeners.push(cb);
	}

	public static function subscribe<T:IEvent>(type:Class<T>, cb:(T) -> Void) {
		var key = Type.getClassName(type);
		if (!listeners.exists(key)) {
			listeners.set(key, []);
		}

		listeners.get(key).push((e) -> {
			var te:T = cast e;
			cb(te);
		});
	}

	public static function fire(e:IEvent) {
		e.id = nextID++;

		// Tell general listeners
		for (l in subAllListeners) {
			l(e);
		}

		// Then check for any listening for this specific event type
		var key = Type.getClassName(Type.getClass(e));
		if (!listeners.exists(key)) {
			return;
		}

		if (!listeners.exists(key)) {
			return;
		}

		for (l in listeners.get(key)) {
			l(e);
		}
	}
}
