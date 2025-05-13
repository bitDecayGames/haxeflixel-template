package events;

/**
 * A basic event bus. Can be used to fire game events.
 * Clients can subscribe to any kind of event and receive
 * a callback when a matching event is fired.
**/
class GameEvents {
	private static var nextID = 1;

	private static var subAllListeners:Array<EventHandler> = [];
	private static var listeners:Map<String, Array<EventHandler>> = [];

	private static var derivers:Array<EventDeriver> = [];

	public static function init() {
		// TODO: Any initialization needed? Such as loading storage data
	}

	public static function registerDeriver(ed:EventDeriver) {
		ed.init();
		derivers.push(ed);
	}

	public static function subscribeAll(cb:EventHandler) {
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

	public static function unsubscribe<T:IEvent>(type:Class<T>, cb:(T) -> Void) {
		// TODO: This is a little tricky to a) track our functions due to being in a map
		// and b) handle the fact that we are are wrapping our functions in a cast helper
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

typedef EventHandler = (IEvent) -> Void;
