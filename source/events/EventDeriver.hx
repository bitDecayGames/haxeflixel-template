package events;

/**
 * A Deriver is something that listens for events and generates new "derived"
 * events based on them.
**/
interface EventDeriver {
	public function init():Void;
	public function destroy():Void;
}
