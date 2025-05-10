package achievements;

class Tracker {
	public function reportInt(metric:String, num:Int) {}

	public function reportFloat(metric:String, num:Float) {}

	public function reportEvent(metric:String, ?meta:Dynamic) {}
}
