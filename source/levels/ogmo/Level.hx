package levels.ogmo;

import flixel.FlxBasic;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.addons.nape.FlxNapeTilemap;
import flixel.group.FlxGroup;
import flixel.math.FlxVector;
import flixel.tile.FlxTilemap;

class Level {

    public var player:Spaceman;

    public var layer:FlxTilemap;

	public function new(level:String) {
        var loader = new FlxOgmo3Loader(AssetPaths.levels__ogmo, level);
        layer = loader.loadTilemap("<AssetPath to tilemap for layer>", "<layer name>");

        objects = new FlxGroup();

		loader.loadEntities((entityData) -> {
            var obj:FlxBasic;
            switch(entityData.name) {
                case "<entity name>":
					obj = new FlxObject();
                default:
					throw 'Entity \'${entityData.name}\' is not supported, add parsing to ${Type.getClassName(Type.getClass(this))}';
            }
            objects.add(obj);
		}, "<entity layer name>");
	}
}
