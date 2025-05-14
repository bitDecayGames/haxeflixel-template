package events;

/**
 * Interface to make sure events are identifiable and the order
 * can be determined when troubleshooting.
**/
interface IEvent {
	public final type:String;
	public final reducer:EventReducer;
	public var id:Int;
}

/**
 * Enum to indicate what kind of reduction metric should be captured
 * for a given event type. Currently only supports one reducer
**/
enum EventReducer {
	NONE;
	COUNT;
	MIN(field:String);
	MAX(field:String);
}
