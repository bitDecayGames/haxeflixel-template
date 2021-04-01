package levels.tiled;

import flixel.math.FlxRect;
import flixel.math.FlxMath;
import flixel.FlxSprite;
import flixel.addons.editors.tiled.TiledImageLayer;
import flixel.addons.editors.tiled.TiledImageTile;
import flixel.addons.editors.tiled.TiledLayer.TiledLayerType;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledObject;
import flixel.addons.editors.tiled.TiledObjectLayer;
import flixel.addons.editors.tiled.TiledTileLayer;
import flixel.addons.editors.tiled.TiledTileSet;
import flixel.addons.editors.tiled.TiledTilePropertySet;
import flixel.tile.FlxTilemap;
import flixel.addons.tile.FlxTileSpecial;
import haxe.io.Path;

class TiledMapLoader extends TiledMap {
	private var relativeDir:String;

	public function new(tiledLevel:FlxTiledMapAsset) {
		super(tiledLevel);
		relativeDir = Path.directory(tiledLevel);
	}

	/**
	 * Returns the tilemaps for the given layer in the TiledMap
	 * Note: Return multiple FlxTilemap objects if the layer
	 *       uses multiple sprite sheets (.tsx files)
	 * IMPORTANT: Always collide the map with objects, not the other way around.
	 *            This prevents odd collision errors (collision separation code off by 1 px).
	 *            Example:
	 *            ```
	 *            if (FlxG.overlap(layer, obj))
	 *            {
	 *            	return true;
	 *            }
	 *            ```
	 */
	public function loadTilemap(layerName:String):Array<FlxTilemap> {
		if (!layerMap.exists(layerName)) {
			throw 'no layer exists with name "${layerName}"';
		}
		var layer = layerMap.get(layerName);
		if (layer.type != TiledLayerType.TILE) {
			throw 'Layer "${layerName} with type ${layer.type} cannot be loaded as a tile layer';
		}

		var tileLayer:TiledTileLayer = cast layer;

		// TODO: this is probably not the best way to do this...
		//       The current idea is to put the gids into a map
		//       to help optimize looping through the array to see
		//       which tilemaps we need
		var setmap = new Map<Int, TiledTileSet>();
		for (tset in tilesetArray) {
			for (i in tset.firstGID...tset.firstGID + tset.numTiles) {
				setmap[i] = tset;
			}
		}

		var neededTilesets = new Array<TiledTileSet>();
		for (i in tileLayer.tileArray) {
			if (setmap.exists(i) && !neededTilesets.contains(setmap.get(i))) {
				neededTilesets.push(setmap.get(i));
			}
		}

		var tilemaps = new Array<FlxTilemap>();
		for (ts in neededTilesets) {
			var indexMod = tileLayer.tileArray.copy();
			for (i in 0...indexMod.length) {
				indexMod[i] = FlxMath.maxInt(0, indexMod[i] - ts.firstGID);
			}
			var imagePath = new Path(ts.imageSource);
			var processedPath = "assets/images/" + imagePath.file + "." + imagePath.ext;

			var tilemap = new FlxTilemap();
			tilemap.loadMapFromArray(indexMod, width, height, processedPath, ts.tileWidth, ts.tileHeight, OFF, 0, 1, 1);

			tilemaps.push(tilemap);
		}

		return tilemaps;
	}

	// TODO: Animated tile are supported in TiledEditor demo files
	function getAnimatedTile(props:TiledTilePropertySet, tileset:TiledTileSet):FlxTileSpecial {
		var special = new FlxTileSpecial(1, false, false, 0);
		var n:Int = props.animationFrames.length;
		var offset = Std.random(n);
		special.addAnimation([
			for (i in 0...n)
				props.animationFrames[(i + offset) % n].tileID + tileset.firstGID
		], (1000 / props.animationFrames[0].duration));
		return special;
	}

	public function loadObjects(objectLoadCallback:TiledObject->Void, objectLayer:String = "objects") {
		if (!layerMap.exists(objectLayer)) {
			throw 'no layer exists with name "${objectLayer}"';
		}
		var layer = layerMap.get(objectLayer);
		if (layer.type != TiledLayerType.TILE) {
			throw 'Layer "${objectLayer} with type ${layer.type} cannot be loaded as an object layer';
		}

		var objectLayer:TiledObjectLayer = cast layer;

		for (o in objectLayer.objects) {
			objectLoadCallback(o);
		}
	}

	// load an object as a sprite
	function loadImageObject(object:TiledObject):FlxSprite {
		var tilesImageCollection:TiledTileSet = null;

		for (i in 0...tilesetArray.length) {
			if (tilesetArray[i].hasGid(object.gid)) {
				tilesImageCollection = tilesetArray[i];
			}
		}

		if (tilesImageCollection == null) {
			throw 'Image "${object.name}" has GID that does not match any tileset';
		}

		var tileImagesSource:TiledImageTile = tilesImageCollection.getImageSourceByGid(object.gid);

		var decoSprite:FlxSprite = new FlxSprite(0, 0, relativeDir + tileImagesSource.source);
		if (decoSprite.width != object.width || decoSprite.height != object.height) {
			decoSprite.antialiasing = true;
			decoSprite.setGraphicSize(object.width, object.height);
		}
		if (object.flippedHorizontally) {
			decoSprite.flipX = true;
		}
		if (object.flippedVertically) {
			decoSprite.flipY = true;
		}
		decoSprite.setPosition(object.x, object.y - decoSprite.height);
		decoSprite.origin.set(0, decoSprite.height);
		if (object.angle != 0) {
			decoSprite.angle = object.angle;
			decoSprite.antialiasing = true;
		}

		return decoSprite;
	}

	public function loadImageLayers():Array<FlxSprite> {
		var imageSprites = new Array<FlxSprite>();
		for (layer in layers) {
			if (layer.type != TiledLayerType.IMAGE)
				continue;

			var image:TiledImageLayer = cast layer;
			var sprite = new FlxSprite(image.x, image.y, relativeDir + image.imagePath);
			imageSprites.push(sprite);
		}
		return imageSprites;
	}

	public function objectToRect(o:TiledObject):FlxRect {
		if (o.objectType != TiledObject.RECTANGLE) {
			throw 'object ${o.name} is not of type RECTANGLE';
		}

		return new FlxRect(o.x, o.y, o.width, o.height);
	}
}
