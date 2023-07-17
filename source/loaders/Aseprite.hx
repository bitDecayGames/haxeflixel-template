package loaders;

import haxe.io.Path;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxAssets.FlxJsonAsset;
import flixel.system.FlxAssets.FlxGraphicAsset;

import loaders.AsepriteTypes.AseAtlas;

class Aseprite {
	// a cache to prevent us from reparsing json multiple times
	private static var atlasCache:Map<String, AseAtlas> = [];

	// loads all animations from the atlas file onto the provided sprite
	public static function loadAllAnimations(into:FlxSprite, data:String) {
		if (!atlasCache.exists(data)) {
			var asAtlas:FlxJsonAsset<AseAtlas> = data;
			atlasCache.set(data, asAtlas.getData());
		}

		var atlas = atlasCache.get(data);

		var imgAsset = Path.join([Path.directory(data), atlas.meta.image]);

		if (!alreadyCached(imgAsset)) {
			loadAsepriteAtlas(data);
		}

		var width = 0;
		var height = 0;
		if (atlas.frames is Array) {
			width = Std.int(atlas.frames[0].sourceSize.w);
			height = Std.int(atlas.frames[0].sourceSize.h);
		} else {
			var hash:AsepriteTypes.Hash<AsepriteTypes.AseAtlasFrame> = atlas.frames;
			var frame = hash.keyValueIterator().next();
			width = Std.int(frame.value.sourceSize.w);
			height = Std.int(frame.value.sourceSize.h);
		}

		// passing animated false here to just save generating frames we won't be using
		into.loadGraphic(imgAsset, false, width, height);

		// Loading the frames as FlxAtlasFrames will parse the duration off of the frames
		// for us.
		var atlasData = FlxAtlasFrames.fromAseprite(imgAsset, data);
		into.frames = atlasData;

		var tags:Array<AsepriteTypes.AseAtlasTag> = atlas.meta.frameTags;
		for (tag in tags) {
			into.animation.add(tag.name, [for (i in tag.from...tag.to + 1) i]);
		}
	}

	// loads the requested slice image from the atlas onto the provided sprite
	public static function loadSlice(into:FlxSprite, data:String, sliceName:String) {
		if (!atlasCache.exists(data)) {
			var asAtlas:FlxJsonAsset<AseAtlas> = data;
			atlasCache.set(data, asAtlas.getData());
		}

		var atlas = atlasCache.get(data);

		var imgAsset = Path.join([Path.directory(data), atlas.meta.image]);

		if (!alreadyCached(imgAsset)) {
			loadAsepriteAtlas(data);
		}

		var atlasData = FlxAtlasFrames.fromAseprite(imgAsset, data);

		into.frame = atlasData.getByName(sliceName);
		into.width = into.frame.frame.width;
		into.height = into.frame.frame.height;
	}

	private static function alreadyCached(asset:FlxGraphicAsset):Bool {
		var graphic:FlxGraphic = FlxG.bitmap.add(asset);
		if (graphic == null)
			return false;

		return FlxAtlasFrames.findFrame(graphic) != null;
	}

	private static function loadAsepriteAtlas(data:String) {
		if (!atlasCache.exists(data)) {
			var asAtlas:FlxJsonAsset<AseAtlas> = data;
			atlasCache.set(data, asAtlas.getData());
		}

		var atlas = atlasCache.get(data);

		var imgAsset = Path.join([Path.directory(data), atlas.meta.image]);
		var atlasData = FlxAtlasFrames.fromAseprite(imgAsset, data);

		var slices:Array<AsepriteTypes.AseAtlasSlice> = atlas.meta.slices;
		for (slice in slices) {
			texturePackerSliceHelper(atlas.frames, slice, atlasData, true);
		}
	}

	private static function texturePackerSliceHelper(frameData:AsepriteTypes.HashOrArray<AsepriteTypes.AseAtlasFrame>, slice:AsepriteTypes.AseAtlasSlice, frames:FlxAtlasFrames, useFrameDuration = false):Void {
		if (frameData is Array ) {
			for (key in slice.keys) {
				var refFrame = frameData[key.frame];

				var frameName = '${slice.name}_${key.frame}';

				var frameRect = FlxRect.get(refFrame.frame.x + key.bounds.x, refFrame.frame.y + key.bounds.y, key.bounds.w, key.bounds.h);

				final sourceSize = FlxPoint.get(refFrame.sourceSize.w, refFrame.sourceSize.h);
				final offset = FlxPoint.get(refFrame.spriteSourceSize.x, refFrame.spriteSourceSize.y);
				final duration = (useFrameDuration && refFrame.duration != null) ? refFrame.duration / 1000 : 0;
				frames.addAtlasFrame(frameRect, sourceSize, offset, frameName, 0, false, false, duration);
			}
		} else {
			var msg = "--json-hash Aseprite exports currently do not support slices. Use --json-array instead";
			trace(msg);
			throw msg;
		}
	}
}
