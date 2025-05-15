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

	// A map to hold pending removals so we don't modify our lists while iterating
	// them during event propagation.
	private static var pendingRemoves:Map<String, Array<HandlerPair>> = [];

	// An event we can use to keep track of where we started our propagation
	private static var originalFireEvent:IEvent = null;

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
				l.active = false;
				if (originalFireEvent == null) {
					subAllListeners.remove(l);
					return;
				}

				if (!pendingRemoves.exists("")) {
					pendingRemoves.set("", []);
				}
				pendingRemoves.get("").push(l);
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
				l.active = false;
				if (originalFireEvent == null) {
					if (listeners.exists(key)) {
						listeners.get(key).remove(l);
					}
					return;
				}

				if (!pendingRemoves.exists(key)) {
					pendingRemoves.set(key, []);
				}
				pendingRemoves.get(key).push(l);
				return;
			}
		}
	}

	public static function fire(e:IEvent) {
		if (originalFireEvent == null) {
			originalFireEvent = e;
		}

		e.id = nextID++;

		// Tell general listeners
		for (l in subAllListeners) {
			if (!l.active) {
				continue;
			}
			l.autoCaster(e);
		}

		// Then check for any listening for this specific event type
		var key = Type.getClassName(Type.getClass(e));
		if (listeners.exists(key)) {
			for (l in listeners.get(key)) {
				if (!l.active) {
					continue;
				}
				l.autoCaster(e);
			}
		}

		// This function can be in a recursive loop from derived events firing
		// so only perform cleanup once we are done processing the original event
		if (e == originalFireEvent) {
			originalFireEvent = null;
			cleanup();
		}
	}

	private static function cleanup() {
		for (key => handlerList in pendingRemoves) {
			if (key == "") {
				for (h in handlerList) {
					subAllListeners.remove(h);
				}
			} else {
				for (h in handlerList) {
					listeners.get(key).remove(h);
				}
			}
		}
	}
}

class HandlerPair {
	public var autoCaster:EventHandler;
	public var original:Dynamic;
	public var active = true;

	public function new(originalCb:Dynamic, autoCaster:EventHandler) {
		this.original = originalCb;
		this.autoCaster = autoCaster;
	}
}

typedef EventHandler = (IEvent) -> Void;
