package;

#if sys
import sys.FileSystem;
import sys.FileStat;
import sys.io.File;
import haxe.io.Path;
#end

class AsepritePacker {

	static inline var FLAG_INPUT_DIR = "--input-dir";
	static inline var FLAG_OUTPUT_DIR = "--output-dir";
	static inline var FLAG_CLEAN = "--clean";

	#if sys
	static var inFileDir:String = null;
	static var outputDir:String = null;
	static var aseExtensions = ["ase", "aseprite"];

	static var skippedFiles:Int = 0;
	static var writtenFiles:Array<String> = [];

	static inline var BLUE = '\033[1;34m';
	static inline var MAGENTA = '\033[35m';
	static inline var YELLOW = '\033[33m';
	static inline var RED = '\033[31m';
	static inline var GREEN = '\033[32m';
	static inline var GRAY = '\033[0;37m';
	#end

	static public function main():Void {
		#if sys
		var args = parseArgs(Sys.args());

		inFileDir = args[FLAG_INPUT_DIR];
		outputDir = args[FLAG_OUTPUT_DIR];

		if (inFileDir == null || outputDir == null) {
			throw '${RED}both ${FLAG_INPUT_DIR} and ${FLAG_OUTPUT_DIR} are required${GRAY}';
		}

		Sys.println('${GREEN}scanning Aseprite files${GRAY}');

		if (args.exists(FLAG_CLEAN)) {
			Sys.println('${BLUE}--clean${GRAY} flag provided');
			Sys.println('${GREEN}→${GRAY} deleting contents of ${YELLOW}${outputDir}${GRAY}');
			deleteDirRecursively(outputDir);
			Sys.println('------------------------');
			Sys.println('');
		}

		search(inFileDir, exportAtlasIfNeeded);

		if (writtenFiles.length > 0) {
			Sys.println('------------------------');
			Sys.println('    ${BLUE}${writtenFiles.length/2} files exported${GRAY}');
		} else {
			Sys.println('${BLUE}no files found needing export${GRAY}');
		}
		#if verbose
		Sys.println('    ${RED}${skippedFiles} files ignored${GRAY}');
		#end
		#else
		throw 'Aseprite Packer can only be run against targets with sys access';
		#end
	}

	#if sys
	static function parseArgs(argsArr:Array<String>):Map<String, String> {
		var result = new Map<String, String>();
		for (arg in argsArr) {
			var split = arg.split('=');
			if (split.length > 1) {
				result.set(split[0], [for (i in 1...split.length) split[i]].join(''));
			} else {
				result.set(split[0], null);
			}
		}
		return result;
	}

	static function exportAtlasIfNeeded(aseFilePath:String) {
		var normal = Path.normalize(aseFilePath);
		if (aseExtensions.contains(Path.extension(normal)) && StringTools.startsWith(normal, inFileDir)) {
			var artPath = normal.split(inFileDir)[1];
			var plainName = Path.withoutExtension(Path.withoutDirectory(artPath));
			var subDirs = Path.directory(artPath).split("/");

			var outBase = [outputDir].concat(subDirs);

			var imageOutputPath = Path.join(outBase.concat([Path.withExtension(plainName, "png")]));
			var jsonOutputPath = Path.join(outBase.concat([Path.withExtension(plainName, "json")]));

			if (!FileSystem.exists(jsonOutputPath)) {
				Sys.println('\t${GREEN}⤷${GRAY} needs export: ${BLUE}$normal${GRAY}');
				exportAtlas(normal, imageOutputPath, jsonOutputPath);
			} else {
				var artFileStat = FileSystem.stat(normal);
				var jsonFileStat = FileSystem.stat(jsonOutputPath);
				if (artFileStat.mtime.getTime() > jsonFileStat.mtime.getTime()) {
					Sys.println('\t${GREEN}⤷${GRAY} needs update: ${BLUE}$normal${GRAY}');
					exportAtlas(normal, imageOutputPath, jsonOutputPath);
				}
			}
		  } else {
			skippedFiles++;
			#if verbose
			Sys.println('- unknown file discovered: ${aseFilePath}');
			#end
		  }
	}

	static function search(directory:String = "path/to/", process:String->Void) {
		if (sys.FileSystem.exists(directory)) {
			#if verbose
			Sys.println('${GREEN}→${GRAY} searching directory: ${YELLOW}$directory${GRAY}');
			#end

			for (file in sys.FileSystem.readDirectory(directory)) {
				var path = haxe.io.Path.join([directory, file]);
				if (sys.FileSystem.isDirectory(path)) {
					var directory = haxe.io.Path.addTrailingSlash(path);
					search(directory, process);
				} else {
					process(path);
				}
			}
		} else {
		  Sys.println('"$directory" does not exists');
		}
	}

	static function exportAtlas(aseFilePath:String, imageOutputPath:String, jsonOutputPath:String) {
		if (writtenFiles.contains(imageOutputPath)) {
			throw 'Multiple files trying to write to ${imageOutputPath}';
		}

		if (writtenFiles.contains(jsonOutputPath)) {
			throw 'Multiple files trying to write to ${jsonOutputPath}';
		}

		#if verbose
		Sys.println('\t\t${GREEN}⤷${GRAY} writing: ${MAGENTA}$imageOutputPath${GRAY}');
		Sys.println('\t\t${GREEN}⤷${GRAY} writing: ${MAGENTA}$jsonOutputPath${GRAY}');
		#end

		var cmd = "aseprite";
		var args = ["-b", '$aseFilePath',
		"--sheet-pack",
		"--list-tags",
		"--list-layers",
		"--list-slices",
		"--format", "json-array",
		"--data", '$jsonOutputPath',
		"--sheet", '$imageOutputPath'];

		#if debug
		args.push("--debug");
		Sys.println('running $cmd $args');
		#end

		var exit = Sys.command(cmd, args);

		if (exit != 0) {
			Sys.println(' ${RED}!!! Export exited with code $exit for file $aseFilePath${GRAY}');
		} else {
			writtenFiles.push(imageOutputPath);
			writtenFiles.push(jsonOutputPath);
		}
	}

	private static function deleteDirRecursively(path:String) : Void
		{
		  if (sys.FileSystem.exists(path) && sys.FileSystem.isDirectory(path))
		  {
			var entries = sys.FileSystem.readDirectory(path);
			for (entry in entries) {
				var entryPath = haxe.io.Path.join([path, entry]);
				if (sys.FileSystem.isDirectory(entryPath)) {
					deleteDirRecursively(entryPath);
					sys.FileSystem.deleteDirectory(entryPath);
				} else {
					sys.FileSystem.deleteFile(entryPath);
				}
			}
		  }
		}
	#end
}