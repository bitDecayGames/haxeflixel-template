package;

import haxe.io.Path;

class Packer {
	static var spritePath = "../art/";
	static var outputDir = "../assets/images/";
	static var aseExtensions = ["ase", "aseprite"];

	static var writtenFiles:Array<String>;

	static public function main():Void {
		writtenFiles = [];
		search(spritePath, exportAtlas);

		trace('------------------------');
		trace('    ${writtenFiles.length/2} files exported');
	}

	static function exportAtlas(aseFilePath:String) {
		var normal = Path.normalize(aseFilePath);
		if (aseExtensions.contains(Path.extension(normal)) && StringTools.startsWith(normal, spritePath)) {
			trace(' +++ processing: $normal');

			var artPath = normal.split(spritePath)[1];
			var plainName = Path.withoutExtension(Path.withoutDirectory(artPath));
			var subDirs = Path.directory(artPath).split("/");

			var outBase = [outputDir].concat(subDirs);

			var imageOutputPath = Path.join(outBase.concat([Path.withExtension(plainName, "png")]));
			var jsonOutputPath = Path.join(outBase.concat([Path.withExtension(plainName, "json")]));

			if (writtenFiles.contains(imageOutputPath)) {
				throw 'Multiple files trying to write to ${imageOutputPath}';
			}

			if (writtenFiles.contains(jsonOutputPath)) {
				throw 'Multiple files trying to write to ${jsonOutputPath}';
			}

			// aseprite -b player.ase --format json-array --data spritesheet.json --sheet spritesheet.png
			var cmd = "aseprite";
			var args = ["-b", '$normal',
			"--sheet-pack",
			"--list-tags",
			"--list-layers",
			"--list-slices",
			"--format", "json-hash",
			"--data", '$jsonOutputPath',
			"--sheet", '$imageOutputPath'];

			#if debug
			args.push("--debug");
			trace('running $cmd $args');
			#end

			var exit = Sys.command(cmd, args);

			if (exit != 0) {
				trace(' !!! Export exited with code $exit for file $normal');
			} else {
				writtenFiles.push(imageOutputPath);
				writtenFiles.push(jsonOutputPath);
			}
		  } else {
			trace('- unknown file discovered: ${aseFilePath}');
		  }
	}

	static function search(directory:String = "path/to/", process:String->Void) {
		if (sys.FileSystem.exists(directory)) {
			trace('- searching directory: $directory');

			for (file in sys.FileSystem.readDirectory(directory)) {
				var path = haxe.io.Path.join([directory, file]);
				if (!sys.FileSystem.isDirectory(path)) {
					process(path);
				} else {
					var directory = haxe.io.Path.addTrailingSlash(path);
					search(directory, process);
				}
			}
		} else {
		  trace('"$directory" does not exists');
		}
	  }
}