package loaders;

import flixel.graphics.FlxAsepriteUtil;
import haxe.io.Path;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.FlxGraphic;
import flixel.graphics.atlas.AseAtlas;
import flixel.graphics.atlas.AtlasBase;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxAssets.FlxAsepriteJsonAsset;
import flixel.system.FlxAssets.FlxJsonAsset;
import flixel.system.FlxAssets.FlxGraphicAsset;

class Aseprite {
	// a cache to prevent us from reparsing json multiple times
	private static var atlasCache:Map<String, AseAtlas> = []; 

	public static function loadAllAnimations(into:FlxSprite, img:FlxGraphicAsset, data:FlxAsepriteJsonAsset) {
		FlxAsepriteUtil.loadAseAtlasAndTagsByIndex(into, img, data);
		if (into.animation.getAnimationList().length == 0) {
			into.animation.add(AsepriteMacros.ALL_FRAMES_ANIM_NAME, [for (i in 0...into.frames.frames.length) i ]);
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
			var asAtlas:FlxAsepriteJsonAsset = data;
			atlasCache.set(data, asAtlas.getData());
		}

		var atlas = atlasCache.get(data);

		var imgAsset = Path.join([Path.directory(data), atlas.meta.image]);
		var atlasData = FlxAtlasFrames.fromAseprite(imgAsset, data);

		var slices:Array<AseAtlasSlice> = atlas.meta.slices;
		for (slice in slices) {
			texturePackerSliceHelper(atlas.frames, slice, atlasData, true);
		}
	}

	private static function texturePackerSliceHelper(frameData:HashOrArray<AseAtlasFrame>, slice:AseAtlasSlice, frames:FlxAtlasFrames, useFrameDuration = false):Void {
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
