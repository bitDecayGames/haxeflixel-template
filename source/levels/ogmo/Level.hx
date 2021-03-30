package levels.ogmo;

import flixel.FlxBasic;
import flixel.FlxObject;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.group.FlxGroup;
import flixel.tile.FlxTilemap;

/**
 * Template for loading an Ogmo level file
**/
class Level {
	public var layer:FlxTilemap;

	public function new(level:String) {
		var loader = new FlxOgmo3Loader("<AssetPath to ogmo file>", level);
		layer = loader.loadTilemap("<AssetPath to tilemap for layer>", "<layer name>");

		var objects = new FlxGroup();

		loader.loadEntities((entityData) -> {
			var obj:FlxBasic;
			switch (entityData.name) {
				case "<entity name>":
					obj = new FlxObject();
				default:
					throw 'Entity \'${entityData.name}\' is not supported, add parsing to ${Type.getClassName(Type.getClass(this))}';
			}
			objects.add(obj);
		}, "<entity layer name>");
	}
}
