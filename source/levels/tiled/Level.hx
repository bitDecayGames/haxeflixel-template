package levels.tiled;

import flixel.FlxSprite;
import flixel.FlxBasic;
import flixel.group.FlxGroup;
import flixel.tile.FlxTilemap;

/**
 * Template for loading a Tiled .tmx level file
**/
class Level {
	public var layers:Array<FlxTilemap>;

	public function new(mapFile:String) {
		var loader = new TiledMapLoader(mapFile);
		layers = loader.loadTilemap("<tile layer name>");

		var objects = new FlxGroup();

		loader.loadObjects((objectData) -> {
			var obj:FlxBasic;
			switch (objectData.type) {
				case "<object name>":
					obj = new FlxSprite(objectData.x, objectData.y);
				default:
					throw 'Object \'${objectData.name}\' is not supported, add parsing to ${Type.getClassName(Type.getClass(this))}';
			}
			objects.add(obj);
		}, "<object layer name>");
	}
}
