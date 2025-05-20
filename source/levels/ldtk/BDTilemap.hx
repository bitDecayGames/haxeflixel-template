package levels.ldtk;

import levels.ldtk.Ldtk.Enum_TileTags;
import levels.ldtk.LdtkTilemap.LdtkTile;

class BDTile extends LdtkTile<Enum_TileTags> {
	// var hit:FlxRect;
	public function new(tilemap:BDTilemap, index, width, height) {
		super(cast tilemap, index, width, height, true, NONE);

		#if debug
		ignoreDrawDebug = true;
		#end
	}

	override function destroy() {
		super.destroy();
		// Handle any needed cleanup here
	}

	override function setMetaData(metaData:String) {
		super.setMetaData(metaData);
		// Do any parsing of metadata here
	}

	override function setTags(tags:Array<Enum_TileTags>) {
		super.setTags(tags);

		visible = true;
		allowCollisions = NONE;
		#if debug
		ignoreDrawDebug = tags.length == 0;
		#end

		#if debug
		// if (tags.contains(EDITOR_ONLY))
		// {
		//     debugBoundingBoxColor = 0xFFFF00FF;
		// }
		#end

		if (tags.contains(INVISIBLE)) {
			visible = false;
		}

		if (tags.contains(SOLID)) {
			allowCollisions = ANY;
		}

		if (tags.contains(ONEWAY)) {
			allowCollisions = UP;
		}
	}
}

class BDTilemap extends LdtkTilemap<Enum_TileTags> {
	override function createTile(index:Int, width:Float, height:Float):BDTile {
		return new BDTile(this, index, width, height);
	}
}
