package config;

class Validator {
	public static macro function load(path:String) {
		try {
			var json = haxe.Json.parse(sys.io.File.getContent(path));
			return macro $v{json};
		} catch (err:Any) {
			return haxe.macro.Context.error('Failed to load json: $err', haxe.macro.Context.currentPos());
		}
	}
}
