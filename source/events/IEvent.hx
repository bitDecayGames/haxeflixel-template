package events;

/**
 * Interface to make sure events are identifiable and the order
 * can be determined when troubleshooting.
**/
interface IEvent {
	public var id:Int;
	public var type:String;
}
