package levels.ldtk;

import flixel.util.FlxDirectionFlags;
import ldtk.Layer_Tiles;
import ldtk.Tileset;
import flixel.tile.FlxTile;
import flixel.tile.FlxTilemap;

class LdtkTile<Tag:EnumValue> extends FlxTile {
	static inline var defaultCollisions:FlxDirectionFlags = ANY;

	public var metaData(default, null):Null<String>;
	public var tags(default, null):Null<haxe.ds.ReadOnlyArray<Tag>>;

	public function new(tilemap:LdtkTilemap<Tag>, index, width, height, visible, allowCollisions = defaultCollisions) {
		super(cast tilemap, index, width, height, visible, allowCollisions);
	}

	public function hasTag(tag:Tag) {
		return tags != null && tags.contains(tag);
	}

	public function setMetaData(data:String) {
		metaData = data;
	}

	public function setTags(tags:Array<Tag>) {
		this.tags = tags;
	}
}

typedef LdtkTilemap<Tag:EnumValue> = LdtkTypedTilemap<Tag, LdtkTile<Tag>>;

/**
 * A FlxTilemap for Ldtk data. Works in a more Flixel style way than the FlxSpriteGroup 
 * way that deepnight provides out-of-the-box
**/
class LdtkTypedTilemap<Tag:EnumValue, Tile:LdtkTile<Tag>> extends FlxTypedTilemap<Tile> {
	var ldtkData:Layer_Tiles;

	override function destroy() {
		super.destroy();

		ldtkData = null;
	}

	public function loadLdtk(layer:Layer_Tiles) {
		ldtkData = layer;
		LdtkTileLayerTools.initTilemap(layer, this, (i, md, _) -> handleTileMetadata(i, md), (i, tags, _) -> handleTileTags(i, tags));
	}

	public function overlapsTag(object, tag, ?position):Bool {
		return overlapsTagWithCallback(object, tag, null, position);
	}

	public function overlapsTagWithCallback(object, tag:Tag, ?callback:(LdtkTile<Tag>) -> Void, ?position):Bool {
		function checkTags(tile:LdtkTile<Tag>) {
			if (tile.hasTag(tag)) {
				if (callback != null)
					callback(tile);

				return true;
			}

			return false;
		}

		return isOverlappingTile(object, checkTags, position);
	}

	function handleTileMetadata(index:Int, metaData:String) {
		_tileObjects[index].setMetaData(metaData);
	}

	function handleTileTags(index:Int, tags:Array<Tag>) {
		_tileObjects[index].setTags(tags);
	}

	override function createTile(index, width, height) {
		return cast new LdtkTile(cast this, index, width, height, true);
	}
}

typedef TilesetDataHandler<Data, Map> = (index:Int, data:Data, tilemap:Map) -> Void;
typedef TilesetMetadataHandler<Map> = TilesetDataHandler<String, Map>;
typedef TilesetTagHandler<Map, Tag:EnumValue> = TilesetDataHandler<Array<Tag>, Map>;

abstract LdtkTileLayerTools(Tileset) from Tileset {
	static public function initTilemap<Tile:FlxTile, Tag:EnumValue, Map:FlxTypedTilemap<Tile>>(layer:Layer_Tiles, tilemap:Map,
			metadataHandler:TilesetMetadataHandler<Map>, tagHandler:TilesetTagHandler<Map, Tag>) {
		final tiles = createTileArray(layer);
		@:privateAccess
		final tileset:Tileset = layer.untypedTileset;
		final graphic = getPath(tileset);
		final tileWidth = tileset.tileGridSize;
		final tileHeight = tileset.tileGridSize;
		tilemap.loadMapFromArray(tiles, layer.cWid, layer.cHei, graphic, tileWidth, tileHeight, null, 0, 0);

		if (metadataHandler != null) {
			for (tileData in tileset.json.customData) {
				metadataHandler(tileData.tileId, tileData.data, tilemap);
			}
		}

		if (tagHandler != null) {
			@:privateAccess
			for (i in 0...tilemap._tileObjects.length) {
				final tags = getAllTags(tileset, i);
				tagHandler(i, tags, tilemap);
			}
		}
	}

	static function getAllTags<Tag:EnumValue>(tileset:Tileset, tileId:Int):Array<Tag> {
		// just assume it had the getAllTags method generated
		final castTileset:{getAllTags:(Int) -> Array<Tag>} = cast tileset;
		return castTileset.getAllTags(tileId);
	}

	static public function createTileArray(layer:Layer_Tiles) {
		return [
			for (y in 0...layer.cHei) {
				for (x in 0...layer.cWid) {
					if (layer.hasAnyTileAt(x, y)) {
						layer.getTileStackAt(x, y)[0].tileId;
					} else
						-1; // empty tile
				}
			}
		];
	}

	/** Path to the atlas image file **/
	static public function getPath(tileset:Tileset):String {
		@:privateAccess
		final projPath = haxe.io.Path.directory(tileset.untypedProject.projectFilePath);
		return haxe.io.Path.normalize('${projPath}/${tileset.relPath}');
	}

	/** Path to the atlas image file **/
	public function getGraphic(tileset:Tileset) {
		return tileset.getAtlasGraphic();
	}
}
