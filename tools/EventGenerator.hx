package;

#if sys
import haxe.Json;
import haxe.Template;
import haxe.io.Path;
import sys.FileSystem;
import sys.io.File;

class EventGenerator {
	static inline var FLAG_INPUT_FILE = "--file";
	static inline var FLAG_OUTPUT_HX_FILE = "--out";

	static inline var EVENT_TEMPLATE_FILE:String = "../assets/data/events/eventTemplate.hxt";
	static inline var ALL_EVENT_TEMPLATE_FILE:String = "../assets/data/events/allEventsTemplate.hxt";

	static public function main():Void {
		var args = parseArgs(Sys.args());

		if (!args.exists(FLAG_INPUT_FILE)) {
			throw '${FLAG_INPUT_FILE} is required';
		}

		if (!args.exists(FLAG_OUTPUT_HX_FILE) || args.get(FLAG_OUTPUT_HX_FILE).length == 0) {
			throw '${FLAG_OUTPUT_HX_FILE} is required';
		}

		var outputFile = args.get(FLAG_OUTPUT_HX_FILE)[0];

		var renderedEvents:Array<String> = [];
		var originFiles:Array<String> = [];

		for (filePath in args.get(FLAG_INPUT_FILE)) {
			trace('parsing file ${filePath}');
			originFiles.push(filePath);
			renderedEvents = renderedEvents.concat(getRenderedEventTypes(filePath));
		}

		var finalData:Dynamic = {
			events: renderedEvents,
			origin: Type.getClassName(EventGenerator),
			inputs: originFiles
		};

		var allEventContent = File.getContent(ALL_EVENT_TEMPLATE_FILE);
		var tpl = new Template(allEventContent);

		var output = tpl.execute(finalData);

		var outdir = Path.directory(outputFile);
		if (!FileSystem.exists(outdir)) {
			FileSystem.createDirectory(outdir);
		}

		trace('writing ${renderedEvents.length} events to ${outputFile}');
		var fo = File.write(outputFile);
		fo.writeString(output);
		fo.flush();
		fo.close();
	}

	static function getRenderedEventTypes(path:String):Array<String> {
		var eventTypes:Array<String> = [];
		final fileContent = File.getContent(path);
		final parsed:Array<Dynamic> = Json.parse(fileContent);

		for (eventData in parsed) {
			trace('parsing event: ${eventData.name}');
			final className = toPascalCase(eventData.name);
			var ctorTemplate = '::foreach fields::::name:::::type::, ::end::';
			var ctorTpl = new Template(ctorTemplate);
			var ctorArgsOutput = ctorTpl.execute(eventData);
			eventData.className = className;
			eventData.ctorArgs = ctorArgsOutput.substr(0, ctorArgsOutput.length - 2);

			var hxtContent = File.getContent(EVENT_TEMPLATE_FILE);
			var tpl = new Template(hxtContent);
			eventTypes.push(tpl.execute(eventData));
		}

		return eventTypes;
	}

	static function toPascalCase(s:String):String {
		return s.split("_").map(word -> word.charAt(0).toUpperCase() + word.substr(1)).join("");
	}

	static function parseArgs(argsArr:Array<String>):Map<String, Array<String>> {
		var result = new Map<String, Array<String>>();
		for (arg in argsArr) {
			var split = arg.split('=');
			if (split.length > 1) {
				if (!result.exists(split[0])) {
					result.set(split[0], []);
				}
				result.get(split[0]).push([for (i in 1...split.length) split[i]].join(''));
			} else {
				result.set(split[0], null);
			}
		}
		return result;
	}
}
#end
