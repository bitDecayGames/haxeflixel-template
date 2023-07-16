package loaders;

typedef MetaTag = {
	name:String,
	from:Int,
	to:Int,
	direction:String,
}

typedef SliceBounds = {
	x:Int,
	y:Int,
	w:Int,
	h:Int,
}

typedef SliceKey = {
	frame:Int,
	bounds:SliceBounds,
}

typedef Slice = {
	name:String,
	color:String,
	keys:Array<SliceKey>,
}

typedef CelData = {
	frame:Int,
	color:String,
	data:String,
}

typedef Layer = {
	name:String,
	opacity:Int,
	blendMode:String,
	cels:Array<CelData>,
}

class AsepriteMacros {
	public static macro function tagNames(path:String) {
		return try {
			var json = haxe.Json.parse(sys.io.File.getContent(path));
			var tags:Array<MetaTag> = json.meta.frameTags;
			var map:Dynamic = {};
			for (tag in tags) {
				Reflect.setField(map, clean(tag.name), tag.name);
			}
			macro $v{map};
		} catch (e) {
			haxe.macro.Context.error('Failed to load json: $e', haxe.macro.Context.currentPos());
		}
	}

	public static macro function sliceNames(path:String) {
		return try {
			var json = haxe.Json.parse(sys.io.File.getContent(path));
			var slices:Array<Slice> = json.meta.slices;
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
			var json = haxe.Json.parse(sys.io.File.getContent(path));
			var layers:Array<Layer> = json.meta.layers;
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
			var json = haxe.Json.parse(sys.io.File.getContent(path));
			var layers:Array<Layer> = json.meta.layers;
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
		input = input.split("-").join("_").split(" ").join("_").split(".").join("__");
		return input;
	}
}
