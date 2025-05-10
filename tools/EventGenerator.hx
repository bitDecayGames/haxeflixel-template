package;

#if sys
import haxe.io.Path;
import sys.FileSystem;
import sys.io.File;
import haxe.Template;
import haxe.Json;

class EventGenerator {
	static inline var EVENT_DATA_FILE:String = "../assets/data/events/types.json";
	static inline var EVENT_TEMPLATE_FILE:String = "../assets/data/events/eventTemplate.hxt";
	static inline var ALL_EVENT_TEMPLATE_FILE:String = "../assets/data/events/allEventsTemplate.hxt";
	static inline var HAXE_OUTPUT_FILE:String = "../source/events/gen/Event.hx";

	static public function main():Void {
		final fileContent = File.getContent(EVENT_DATA_FILE);
		final parsed:Array<Dynamic> = Json.parse(fileContent);

		var renderedEvents:Array<String> = [];
		for (eventData in parsed) {
			final className = toPascalCase(eventData.name);
			var ctorTemplate = '::foreach fields::::name:::::type::, ::end::';
			var ctorTpl = new Template(ctorTemplate);
			var ctorArgsOutput = ctorTpl.execute(eventData);
			eventData.className = className;
			eventData.ctorArgs = ctorArgsOutput.substr(0, ctorArgsOutput.length - 2);

			var hxtContent = File.getContent(EVENT_TEMPLATE_FILE);
			var tpl = new Template(hxtContent);
			renderedEvents.push(tpl.execute(eventData));
		}

		var allEventContent = File.getContent(ALL_EVENT_TEMPLATE_FILE);
		var tpl = new Template(allEventContent);

		var finalData:Dynamic = {
			events: renderedEvents
		};

		var output = tpl.execute(finalData);

		var outdir = Path.directory(HAXE_OUTPUT_FILE);
		if (!FileSystem.exists(outdir)) {
			FileSystem.createDirectory(outdir);
		}

		var fo = File.write(HAXE_OUTPUT_FILE);
		fo.writeString(output);
		fo.flush();
		fo.close();
	}

	static function toPascalCase(s:String):String {
		return s.split("_").map(word -> word.charAt(0).toUpperCase() + word.substr(1)).join("");
	}
}
#end
