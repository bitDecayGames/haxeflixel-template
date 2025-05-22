package levels.ldtk;

import flixel.util.FlxColor;
import levels.ldtk.Ldtk.Enum_TileTags;
import levels.ldtk.LdtkTilemap.LdtkTile;

/**
 * Bit Decay extension of LdtkTile that knows what to do with the tags and
 * metadata on each tile
**/
class BDTile extends LdtkTile<Enum_TileTags> {
	// var hit:FlxRect;
	public function new(tilemap:BDTilemap, index, width, height) {
		super(cast tilemap, index, width, height, true);

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
			#if debug
			debugBoundingBoxColor = FlxColor.CYAN;
			#else
			visible = false;
			#end
		}

		if (tags.contains(SOLID)) {
			allowCollisions = ANY;
		}

		if (tags.contains(ONEWAY)) {
			allowCollisions = UP;
		}
	}
}

/**
 * Bit Decay extension of LdtkTilemap that is comprised of BDTiles to handle
 * game specific parsing of tile tags and metadata
**/
class BDTilemap extends LdtkTilemap<Enum_TileTags> {
	override function createTile(index:Int, width:Float, height:Float):BDTile {
		return new BDTile(this, index, width, height);
	}
}
