package events.gen;

// GENERATED CODE: DO NOT EDIT

class Bugfood implements events.IEvent {
	public var id:Int;
	public var type:String;

	public function new() {
		type = "bugfood";
	}
}

class PlayerSpawn implements events.IEvent {
	public var id:Int;
	public var type:String;
	public var posX:Float;
	public var posY:Float;

	public function new(posX:Float, posY:Float) {
		type = "player_spawn";
		this.posX = posX;
		this.posY = posY;
	}
}
