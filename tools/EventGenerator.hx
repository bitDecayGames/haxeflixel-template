package;

#if sys
import haxe.Json;
import haxe.Template;
import haxe.crypto.Md5;
import haxe.io.Path;
import json2object.JsonParser;
import sys.FileSystem;
import sys.io.File;

class EventGenerator {
	static inline var FLAG_INPUT_FILE = "--file";
	static inline var FLAG_OUTPUT_HX_FILE = "--out";
	static inline var FLAG_PACKAGE = "--package";
	static inline var FLAG_CLEAN = "--clean";

	static inline var BLUE = '\033[1;34m';
	static inline var MAGENTA = '\033[35m';
	static inline var YELLOW = '\033[33m';
	static inline var RED = '\033[31m';
	static inline var GREEN = '\033[32m';
	static inline var GRAY = '\033[0;37m';

	static inline var EVENT_TEMPLATE_FILE:String = "./files/eventTemplate.hxt";
	static inline var ALL_EVENT_TEMPLATE_FILE:String = "./files/allEventsTemplate.hxt";

	static var hashRegex = ~/Input Hash: (.*)/g;

	static var allEventTemplate:Template = null;
	static var ctorTemplate:Template = null;
	static var eventTemplate:Template = null;

	static var error = false;
	static var allEventNames:Map<String, Bool> = [];

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

		initTemplates();

		var inputFiles = args.get(FLAG_INPUT_FILE);

		Sys.println('${GREEN}scanning event files${GRAY}');
		var oldHash = getPreviousHash(outputFile);
		var newHash = getHashOfFiles(inputFiles);

		if (oldHash == newHash && !args.exists(FLAG_CLEAN)) {
			Sys.println('${BLUE}no changes detected, skipping event generation${GRAY}');
			return;
		}

		for (filePath in inputFiles) {
			Sys.println('${GREEN}parsing file ${filePath}${GRAY}');
			originFiles.push(filePath);
			renderedEvents = renderedEvents.concat(getRenderedEventTypes(filePath));
		}

		if (error) {
			Sys.println('${RED}ERRORS OCCURRED DURING GENERATION. PLEASE FIX AND RE-RUN');
			Sys.exit(1);
		}

		var finalData:Dynamic = {
			pack: outputPackage,
			events: renderedEvents,
			origin: Type.getClassName(EventGenerator),
			inputs: originFiles,
			hash: newHash
		};

		var output = allEventTemplate.execute(finalData);

		var outdir = Path.directory(outputFile);
		if (!FileSystem.exists(outdir)) {
			FileSystem.createDirectory(outdir);
		}

		Sys.println('${GRAY}writing ${renderedEvents.length} events to: ${MAGENTA}${outputFile}${GRAY}');
		var fo = File.write(outputFile);
		fo.writeString(output);
		fo.flush();
		fo.close();
	}

	static function getPreviousHash(outFile:String):String {
		if (!FileSystem.exists(outFile)) {
			return "";
		}

		final outFileContent = File.getContent(outFile);
		if (!hashRegex.match(outFileContent)) {
			return "";
		}

		return hashRegex.matched(1);
	}

	static function getHashOfFiles(inFiles:Array<String>):String {
		var fileHashes:String = "";

		for (f in inFiles) {
			final content = File.getContent(f);
			fileHashes += Md5.encode(content);
		}

		return Md5.encode(fileHashes);
	}

	static function initTemplates() {
		var ctorTpl = '::foreach fields::::name:::::type::, ::end::';
		ctorTemplate = new Template(ctorTpl);

		var hxtContent = File.getContent(EVENT_TEMPLATE_FILE);
		eventTemplate = new Template(hxtContent);

		var allEventContent = File.getContent(ALL_EVENT_TEMPLATE_FILE);
		allEventTemplate = new Template(allEventContent);
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
			Sys.println('\t${GREEN}⤷${GRAY}parsing event: ${BLUE}${eventData.name}${GRAY}');
			if (allEventNames.exists(eventData.name)) {
				error = true;
				Sys.println('${RED}multiple events found with name: ${GRAY}${eventData.name}');
			}
			allEventNames.set(eventData.name, true);
			var className = toPascalCase(eventData.name);
			var ctorArgsOutput = ctorTemplate.execute(eventData);
			eventData.className = className;
			eventData.ctorArgs = ctorArgsOutput.substr(0, ctorArgsOutput.length - 2);
			var renderedEvent = eventTemplate.execute(eventData);
			eventTypes.push({
				classKey: eventData.name,
				className: className,
				rendered: renderedEvent,
				reducerList: "NONE"
			});

			if (eventData.meta != null && eventData.meta.reducers != null) {
				for (r in eventData.meta.reducers) {
					eventTypes.push(buildReducer(eventData, r));
				}
			}
		}

		return eventTypes;
	}

	static function buildReducer(def:EventDefinition, reducer:String):ParsedEvent {
		if (reducer == "COUNT") {
			var countData:Dynamic = {};
			countData.name = '${def.name}_count';
			Sys.println('\t  ${GREEN}⤷${YELLOW}creating meta event: ${BLUE}${countData.name}${GRAY}');
			var className = toPascalCase(countData.name);
			countData.className = className;
			countData.meta = null;
			countData.fields = [{"name": "count", "type": "Int"}];
			var ctorArgsOutput = ctorTemplate.execute(countData);
			countData.ctorArgs = ctorArgsOutput.substr(0, ctorArgsOutput.length - 2);
			var renderedEvent = eventTemplate.execute(countData);
			return {
				classKey: countData.name,
				className: className,
				rendered: renderedEvent,
				reducerList: "COUNT",
				reducerType: "Int"
			};
		}

		if (StringTools.startsWith(reducer, "SUM(")) {
			var countData:Dynamic = {};
			countData.name = '${def.name}_sum';
			Sys.println('\t  ${GREEN}⤷${YELLOW}creating meta event: ${BLUE}${countData.name}${GRAY}');
			var className = toPascalCase(countData.name);
			countData.className = className;
			countData.meta = null;
			var minField:FieldDefinition = {
				name: 'sum',
				type: Int // Stand-in as we have to provide a value here. Might be updated by the check below
			};
			for (f in def.fields) {
				if (StringTools.contains(reducer, '(\'${f.name}\')')) {
					minField.type = f.type;
				}
			}
			countData.fields = [minField];
			var ctorArgsOutput = ctorTemplate.execute(countData);
			countData.ctorArgs = ctorArgsOutput.substr(0, ctorArgsOutput.length - 2);
			var renderedEvent = eventTemplate.execute(countData);
			return {
				classKey: countData.name,
				className: className,
				rendered: renderedEvent,
				reducerList: "SUM",
				reducerType: '${minField.type}'
			};
		}

		if (StringTools.startsWith(reducer, "MIN(")) {
			var countData:Dynamic = {};
			countData.name = '${def.name}_min';
			Sys.println('\t  ${GREEN}⤷${YELLOW}creating meta event: ${BLUE}${countData.name}${GRAY}');
			var className = toPascalCase(countData.name);
			countData.className = className;
			countData.meta = null;
			var minField:FieldDefinition = {
				name: 'min',
				type: Int // Stand-in as we have to provide a value here. Might be updated by the check below
			};
			for (f in def.fields) {
				if (StringTools.contains(reducer, '(\'${f.name}\')')) {
					minField.type = f.type;
				}
			}
			countData.fields = [minField];
			var ctorArgsOutput = ctorTemplate.execute(countData);
			countData.ctorArgs = ctorArgsOutput.substr(0, ctorArgsOutput.length - 2);
			var renderedEvent = eventTemplate.execute(countData);
			return {
				classKey: countData.name,
				className: className,
				rendered: renderedEvent,
				reducerList: "MIN",
				reducerType: '${minField.type}'
			};
		}

		if (StringTools.startsWith(reducer, "MAX(")) {
			var countData:Dynamic = {};
			countData.name = '${def.name}_max';
			Sys.println('\t  ${GREEN}⤷${YELLOW}creating meta event: ${BLUE}${countData.name}${GRAY}');
			var className = toPascalCase(countData.name);
			countData.className = className;
			countData.meta = null;
			var maxField:FieldDefinition = {
				name: 'max',
				type: Int // Stand-in as we have to provide a value here. Might be updated by the check below
			};
			for (f in def.fields) {
				if (StringTools.contains(reducer, '(\'${f.name}\')')) {
					maxField.type = f.type;
				}
			}
			countData.fields = [maxField];
			var ctorArgsOutput = ctorTemplate.execute(countData);
			countData.ctorArgs = ctorArgsOutput.substr(0, ctorArgsOutput.length - 2);
			var renderedEvent = eventTemplate.execute(countData);
			return {
				classKey: countData.name,
				className: className,
				rendered: renderedEvent,
				reducerList: "MAX",
				reducerType: '${maxField.type}'
			};
		}

		throw('unable to build reducer for "${reducer}"');
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
	var ?reducers:Array<String>;
}

typedef FieldDefinition = {
	var name:String;
	var type:SupportedType;
}

// In theory we can support any types we want, but we have to
// sort out how to add the import to the generated code
enum SupportedType {
	String;
	Float;
	Int;
}
#end
