package loaders;

class AsepriteMacros {
	// A macro to provide all tagNames from the given file. If no tags defined, this will
	// return the frame names, instead.
	public static macro function tagNames(path:String) {
		return try {
			var json = haxe.Json.parse(sys.io.File.getContent(path));
			var tags:Array<loaders.AsepriteTypes.AseAtlasTag> = json.meta.frameTags;
			var map:Dynamic = {};
			if (tags.length == 0) {
				var frames:Array<loaders.AsepriteTypes.AseAtlasFrame> = json.frames;
				for (frame in frames) {
					Reflect.setField(map, clean(frame.filename), frame.filename);
				}
			}
			for (tag in tags) {
				Reflect.setField(map, clean(tag.name), tag.name);
			}
			// This exists because we know we do it on the runtime loading of the sprite
			Reflect.setField(map, "all_frames", "all_frames");
			macro $v{map};
		} catch (e) {
			haxe.macro.Context.error('Failed to load json: $e', haxe.macro.Context.currentPos());
		}
	}

	public static macro function sliceNames(path:String) {
		return try {
			var json = haxe.Json.parse(sys.io.File.getContent(path));
			var slices:Array<loaders.AsepriteTypes.AseAtlasSlice> = json.meta.slices;
			var map:Dynamic = {};
			for (s in slices) {
				for (key in s.keys) {
					Reflect.setField(map, clean('${s.name}_${key.frame}'), '${s.name}_${key.frame}');
				}
			}
			macro $v{map};
		} catch (e) {
			haxe.macro.Context.error('Failed to load json: $e', haxe.macro.Context.currentPos());
		}
	}

	public static macro function layerNames(path:String) {
		return try {
			var atlas:loaders.AsepriteTypes.AseAtlas = haxe.Json.parse(sys.io.File.getContent(path));
			var layers:Array<loaders.AsepriteTypes.AseAtlasLayer> = atlas.meta.layers;
			var map:Dynamic = {};
			for (l in layers) {
				Reflect.setField(map, clean('${l.name}'), '${l.name}');
			}
			macro $v{map};
		} catch (e) {
			haxe.macro.Context.error('Failed to load json: $e', haxe.macro.Context.currentPos());
		}
	}

	public static macro function frameUserData(path:String, layer:String) {
		return try {
			var atlas:loaders.AsepriteTypes.AseAtlas = haxe.Json.parse(sys.io.File.getContent(path));
			var layers:Array<loaders.AsepriteTypes.AseAtlasLayer> = atlas.meta.layers;
			var map:Map<Int, String> = [];
			for (l in layers) {
				if (l.name == layer) {
					for (c in l.cels) {
						map.set(c.frame, c.data);
					}
					break;
				}
			}

			macro $v{map};
		} catch (e) {
			haxe.macro.Context.error('Failed to load json: $e', haxe.macro.Context.currentPos());
		}
	}

	private static function clean(input:String):String {
		// Taken from how AssetPaths builds field names
		var forbiddenCharRegex = ~/[-\(\) \.]/g;
		input = forbiddenCharRegex.split(input).join('_');
		return input;
	}
}
