package;

#if sys
import json2object.JsonParser;
import haxe.Json;
import haxe.Template;
import haxe.io.Path;
import sys.FileSystem;
import sys.io.File;

class EventGenerator {
	static inline var FLAG_INPUT_FILE = "--file";
	static inline var FLAG_OUTPUT_HX_FILE = "--out";
	static inline var FLAG_PACKAGE = "--package";

	static inline var EVENT_TEMPLATE_FILE:String = "./files/eventTemplate.hxt";
	static inline var ALL_EVENT_TEMPLATE_FILE:String = "./files/allEventsTemplate.hxt";

	static public function main():Void {
		var args = parseArgs(Sys.args());

		if (!args.exists(FLAG_INPUT_FILE)) {
			throw '${FLAG_INPUT_FILE} is required';
		}

		if (!args.exists(FLAG_OUTPUT_HX_FILE)) {
			throw '${FLAG_OUTPUT_HX_FILE} is required';
		}

		if (!args.exists(FLAG_PACKAGE)) {
			throw '${FLAG_PACKAGE} is required';
		}

		var outputFile = args.get(FLAG_OUTPUT_HX_FILE)[0];
		var outputPackage = args.get(FLAG_PACKAGE)[0];

		var renderedEvents:Array<ParsedEvent> = [];
		var originFiles:Array<String> = [];

		for (filePath in args.get(FLAG_INPUT_FILE)) {
			trace('parsing file ${filePath}');
			originFiles.push(filePath);
			renderedEvents = renderedEvents.concat(getRenderedEventTypes(filePath));
		}

		var finalData:Dynamic = {
			pack: outputPackage,
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

	static function getRenderedEventTypes(path:String):Array<ParsedEvent> {
		var eventTypes:Array<ParsedEvent> = [];
		var parser = new JsonParser<Array<EventDefinition>>();
		final fileContent = File.getContent(path);
		final parsed:Array<EventDefinition> = parser.fromJson(fileContent);
		if (parser.errors.length > 0) {
			throw(json2object.ErrorUtils.convertErrorArray(parser.errors));
		}

		for (eventData in parsed) {
			trace('parsing event: ${eventData.name}');
			var className = toPascalCase(eventData.name);
			var ctorTemplate = '::foreach fields::::name:::::type::, ::end::';
			var ctorTpl = new Template(ctorTemplate);
			var ctorArgsOutput = ctorTpl.execute(eventData);
			eventData.className = className;
			eventData.ctorArgs = ctorArgsOutput.substr(0, ctorArgsOutput.length - 2);

			var hxtContent = File.getContent(EVENT_TEMPLATE_FILE);
			var tpl = new Template(hxtContent);
			var renderedEvent = tpl.execute(eventData);
			eventTypes.push({
				classKey: eventData.name,
				className: className,
				rendered: renderedEvent,
				reducerList: "NONE"
			});

			if (eventData.meta != null && eventData.meta.reducer == "COUNT") {
				var countData:Dynamic = {};
				countData.name = '${eventData.name}_count';
				trace('creating meta event: ${countData.name}');
				className = toPascalCase(countData.name);
				countData.className = className;
				countData.meta = null;
				countData.fields = [{"name": "count", "type": "Int"}];
				ctorArgsOutput = ctorTpl.execute(countData);
				countData.ctorArgs = ctorArgsOutput.substr(0, ctorArgsOutput.length - 2);
				renderedEvent = tpl.execute(countData);
				eventTypes.push({
					classKey: countData.name,
					className: className,
					rendered: renderedEvent,
					reducerList: "COUNT",
					reducerType: ''
				});
			}

			if (eventData.meta != null && StringTools.startsWith(eventData.meta.reducer, "MIN(")) {
				var countData:Dynamic = {};
				countData.name = '${eventData.name}_min';
				trace('creating meta event: ${countData.name}');
				className = toPascalCase(countData.name);
				countData.className = className;
				countData.meta = null;
				var minField:FieldDefinition = {
					name: 'min',
					type: Int // Stand-in as we have to provide a value here. Might be updated by the check below
				};
				for (f in eventData.fields) {
					if (StringTools.contains(eventData.meta.reducer, '(\'${f.name}\')')) {
						minField.type = f.type;
					}
				}
				countData.fields = [minField];
				ctorArgsOutput = ctorTpl.execute(countData);
				countData.ctorArgs = ctorArgsOutput.substr(0, ctorArgsOutput.length - 2);
				renderedEvent = tpl.execute(countData);
				eventTypes.push({
					classKey: countData.name,
					className: className,
					rendered: renderedEvent,
					reducerList: "MIN",
					reducerType: '${minField.type}'
				});
			}

			if (eventData.meta != null && StringTools.startsWith(eventData.meta.reducer, "MAX(")) {
				var countData:Dynamic = {};
				countData.name = '${eventData.name}_max';
				trace('creating meta event: ${countData.name}');
				className = toPascalCase(countData.name);
				countData.className = className;
				countData.meta = null;
				var maxField:FieldDefinition = {
					name: 'max',
					type: Int // Stand-in as we have to provide a value here. Might be updated by the check below
				};
				for (f in eventData.fields) {
					if (StringTools.contains(eventData.meta.reducer, '(\'${f.name}\')')) {
						maxField.type = f.type;
					}
				}
				countData.fields = [maxField];
				ctorArgsOutput = ctorTpl.execute(countData);
				countData.ctorArgs = ctorArgsOutput.substr(0, ctorArgsOutput.length - 2);
				renderedEvent = tpl.execute(countData);
				eventTypes.push({
					classKey: countData.name,
					className: className,
					rendered: renderedEvent,
					reducerList: "MAX",
					reducerType: '${maxField.type}'
				});
			}
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

typedef ParsedEvent = {
	var classKey:String;
	var className:String;
	var rendered:String;
	var reducerList:String;
	var ?reducerType:String;
}

typedef EventDefinition = {
	var name:String;
	var ?meta:EventDefMetadata;
	var fields:Array<FieldDefinition>;

	// Used by the generation code
	var ?className:String;
	var ?ctorArgs:String;
}

typedef EventDefMetadata = {
	var ?reducer:String;
}

typedef FieldDefinition = {
	var name:String;
	var type:SupportedType;
}

enum SupportedType {
	String;
	Float;
	Int;
}
#end
