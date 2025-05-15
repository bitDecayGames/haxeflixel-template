package events;

/**
 * A basic event bus. Can be used to fire game events.
 * Clients can subscribe to any kind of event and receive
 * a callback when a matching event is fired.
**/
class EventBus {
	private static var nextID = 1;

	private static var subAllListeners:Array<HandlerPair> = [];
	private static var listeners:Map<String, Array<HandlerPair>> = [];

	private static var derivers:Array<EventDeriver> = [];

	public static function init() {
		// TODO: Any initialization needed? Such as loading storage data
	}

	public static function registerDeriver(ed:EventDeriver) {
		ed.init();
		derivers.push(ed);
	}

	public static function subscribeAll(cb:EventHandler) {
		var handler = new HandlerPair(cb, cb);
		subAllListeners.push(handler);
	}

	public static function subscribe<T:IEvent>(type:Class<T>, cb:(T) -> Void) {
		var key = Type.getClassName(type);
		if (!listeners.exists(key)) {
			listeners.set(key, []);
		}

		var autoCaster = (e) -> {
			var te:T = cast e;
			cb(te);
		};
		listeners.get(key).push(new HandlerPair(cb, autoCaster));
	}

	public static function unsubscribeAll(cb:EventHandler) {
		for (l in subAllListeners) {
			if (l.original = cb) {
				subAllListeners.remove(l);
				return;
			}
		}
	}

	public static function unsubscribe<T:IEvent>(type:Class<T>, cb:(T) -> Void) {
		// TODO: This is a little tricky to a) track our functions due to being in a map
		// and b) handle the fact that we are are wrapping our functions in a cast helper
		var key = Type.getClassName(type);
		if (!listeners.exists(key)) {
			return;
		}

		for (l in listeners.get(key)) {
			if (l.original = cb) {
				listeners.get(key).remove(l);
				return;
			}
		}
	}

	public static function fire(e:IEvent) {
		e.id = nextID++;

		// Tell general listeners
		for (l in subAllListeners) {
			l.autoCaster(e);
		}

		// Then check for any listening for this specific event type
		var key = Type.getClassName(Type.getClass(e));
		if (!listeners.exists(key)) {
			return;
		}

		for (l in listeners.get(key)) {
			l.autoCaster(e);
		}
	}
}

class HandlerPair {
	public var autoCaster:EventHandler;
	public var original:Dynamic;

	public function new(originalCb:Dynamic, autoCaster:EventHandler) {
		this.original = originalCb;
		this.autoCaster = autoCaster;
	}
}

typedef EventHandler = (IEvent) -> Void;
