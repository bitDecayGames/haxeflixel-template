package config;

class Validator {
	/**
	 * Validates the given json file at compile time
	 */
	public static macro function validateJson(path:String) {
		if (sys.FileSystem.exists(path)) {
			var content = sys.io.File.getContent(path);
			try {
				// Test the json by parsing it.
				// It will throw an error when you made a mistake.
				haxe.Json.parse(content);
			} catch (error:String) {
				// create position inside the json, FlashDevelop handles this very nice.
				var position = Std.parseInt(error.split("position").pop());
				var pos = haxe.macro.Context.makePosition({
					min: position,
					max: position + 1,
					file: path
				});
				haxe.macro.Context.error(path + " is not valid Json. " + error, pos);
			}
		} else {
			haxe.macro.Context.warning(path + " does not exist", haxe.macro.Context.currentPos());
		}
		return macro null;
	}
}
