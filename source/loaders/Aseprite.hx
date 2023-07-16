package loaders;

import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxG;
import flixel.graphics.FlxGraphic;
import flixel.math.FlxPoint;
import loaders.AsepriteMacros.Slice;
import flixel.math.FlxRect;
import flixel.graphics.frames.FlxAtlasFrames;
import haxe.io.Path;
import flixel.FlxSprite;

class Aseprite {
	private static var jsonCache:Map<String, Dynamic> = [];

	public static function loadAllAnimations(into:FlxSprite, data:String) {
		var json = jsonCache.get(data);
		if (json == null) {
			json = haxe.Json.parse(lime.utils.Assets.getText(data));
			jsonCache.set(data, json);
		}

		var imgAsset = Path.join([Path.directory(data), json.meta.image]);

		if (!alreadyCached(imgAsset)) {
			loadAsepriteAtlas(data);
		}

		// passing animated false here to just save generating frames we won't be using
		into.loadGraphic(imgAsset, false, json.frames[0].sourceSize.w, json.frames[0].sourceSize.h);

		// Loading the frames as FlxAtlasFrames will parse the duration off of the frames
		// for us.
		var atlasData = FlxAtlasFrames.fromAseprite(imgAsset, data);
		into.frames = atlasData;

		var tags:Array<AsepriteMacros.MetaTag> = json.meta.frameTags;
		for (tag in tags) {
			into.animation.add(tag.name, [for (i in tag.from...tag.to + 1) i]);
		}
	}

	public static function loadSlice(into:FlxSprite, data:String, sliceName:String) {
		var json = jsonCache.get(data);
		if (json == null) {
			json = haxe.Json.parse(lime.utils.Assets.getText(data));
			jsonCache.set(data, json);
		}
		var imgAsset = Path.join([Path.directory(data), json.meta.image]);

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
		var json = haxe.Json.parse(lime.utils.Assets.getText(data));
		var imgAsset = Path.join([Path.directory(data), json.meta.image]);
		var atlasData = FlxAtlasFrames.fromAseprite(imgAsset, data);

		var slices:Array<Slice> = json.meta.slices;
		for (slice in slices) {
			texturePackerSliceHelper(json.frames, slice, atlasData, true);
		}
	}

	private static function texturePackerSliceHelper(frameData:Array<Dynamic>, slice:Slice, frames:FlxAtlasFrames, useFrameDuration = false):Void {
		for (key in slice.keys) {
			var refFrame = frameData[key.frame];

			var frameName = '${slice.name}_${key.frame}';

			var frameRect = FlxRect.get(refFrame.frame.x + key.bounds.x, refFrame.frame.y + key.bounds.y, key.bounds.w, key.bounds.h);

			final sourceSize = FlxPoint.get(refFrame.sourceSize.w, refFrame.sourceSize.h);
			final offset = FlxPoint.get(refFrame.spriteSourceSize.x, refFrame.spriteSourceSize.y);
			final duration = (useFrameDuration && refFrame.duration != null) ? refFrame.duration / 1000 : 0;
			frames.addAtlasFrame(frameRect, sourceSize, offset, frameName, 0, false, false, duration);
		}
	}
}
