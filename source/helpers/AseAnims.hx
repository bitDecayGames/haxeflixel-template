package helpers;

typedef MetaTag = {
	name:String,
	from:Int,
	to:Int,
	direction:String,
}

class AseAnims {
	public static macro function loadAnimNames(path:String) {
		return try {
			var json = haxe.Json.parse(sys.io.File.getContent(path));
			var tags:Array<MetaTag> = json.meta.frameTags;
			var map:Dynamic = {};
			for (tag in tags) {
				Reflect.setField(map, tag.name, tag.name);
			}
			macro $v{map};
		} catch (e) {
			haxe.macro.Context.error('Failed to load json: $e', haxe.macro.Context.currentPos());
		}
	}

	public static macro function loadTags(path:String) {
		return try {
			var json = haxe.Json.parse(sys.io.File.getContent(path));
			var tags:Array<MetaTag> = json.meta.frameTags;
			macro $v{tags};
		} catch (e) {
			haxe.macro.Context.error('Failed to load json: $e', haxe.macro.Context.currentPos());
		}
	}
}