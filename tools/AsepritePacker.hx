package;

import haxe.io.Path;

/**
 * Searches through the root assets/images/ directory and exports all Aseprite
 * files as sprite sheets and an accompanying json file with animation information
 * into the assets/images/ directory ready for consumption by code
**/
class AsepritePacker {
	#if sys
	static var spritePath = "../art/";
	static var outputDir = "../assets/images/";
	static var aseExtensions = ["ase", "aseprite"];

	static var skippedFiles:Int = 0;
	static var writtenFiles:Array<String> = [];

	static inline var BLUE = '\033[1;34m';
	static inline var YELLOW = '\033[33m';
	static inline var RED = '\033[31m';
	static inline var GREEN = '\033[32m';
	static inline var GRAY = '\033[0;37m';
	#end

	static public function main():Void {
		#if sys
		search(spritePath, exportAtlas);

		trace('------------------------');
		trace('    ${BLUE}${writtenFiles.length/2} files exported${GRAY}');
		trace('    ${RED}${skippedFiles} files ignored${GRAY}');
		#else
		throw 'Aseprite Packer can only be run against targets with sys access';
		#end
	}

	#if sys
	static function exportAtlas(aseFilePath:String) {
		var normal = Path.normalize(aseFilePath);
		if (aseExtensions.contains(Path.extension(normal)) && StringTools.startsWith(normal, spritePath)) {
			trace('\t${GREEN}⤷${GRAY} processing: ${BLUE}$normal${GRAY}');

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
			"--format", "json-array",
			"--data", '$jsonOutputPath',
			"--sheet", '$imageOutputPath'];

			#if debug
			args.push("--debug");
			trace('running $cmd $args');
			#end

			var exit = Sys.command(cmd, args);

			if (exit != 0) {
				trace(' ${RED}!!! Export exited with code $exit for file $normal${GRAY}');
			} else {
				writtenFiles.push(imageOutputPath);
				writtenFiles.push(jsonOutputPath);
			}
		  } else {
			skippedFiles++;
			#if debug
			trace('- unknown file discovered: ${aseFilePath}');
			#end
		  }
	}

	static function search(directory:String = "path/to/", process:String->Void) {
		if (sys.FileSystem.exists(directory)) {
			trace('${GREEN}→${GRAY} searching directory: ${YELLOW}$directory${GRAY}');

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
	#end
}