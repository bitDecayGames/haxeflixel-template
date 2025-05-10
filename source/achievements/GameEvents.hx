package achievements;

import events.IEvent;

class GameEvents {
	private static var nextID = 1;

	private static var newListeners:Map<String, Array<(IEvent) -> Void>> = [];

	public static function init() {
		trace('hi');
		// TODO: Any initialization? Such as loading storage data
	}

	public static function subscribe<T:IEvent>(type:Class<T>, cb:(T) -> Void) {
		var key = Type.getClassName(type);
		if (!newListeners.exists(key)) {
			newListeners.set(key, []);
		}
		newListeners.get(key).push((e) -> {
			var te:T = cast e;
			cb(te);
		});
	}

	public static function fire(e:IEvent) {
		e.id = nextID++;
		var key = Type.getClassName(Type.getClass(e));
		if (!newListeners.exists(key)) {
			return;
		}

		if (!newListeners.exists(key)) {
			return;
		}

		for (l in newListeners.get(key)) {
			l(e);
		}
	}
}
