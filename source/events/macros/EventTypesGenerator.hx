package events.macros;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;
import sys.io.File;
import haxe.Json;
#end

using StringTools;

class EventTypesGenerator {
	#if macro
	public static macro function buildAll():Array<TypeDefinition> {
		final fileContent = File.getContent('assets/data/events/types.json');
		final parsed:Array<Dynamic> = Json.parse(fileContent);

		final defs:Array<TypeDefinition> = [];

		for (event in parsed) {
			final className = toPascalCase(event.name);
			final typeName = event.name;

			final fields:Array<Field> = [];

			// Add "type" field
			fields.push({
				name: "type",
				access: [APublic],
				kind: FVar(macro :String),
				pos: Context.currentPos()
			});

			// Add "id" field
			fields.push({
				name: "id",
				access: [APublic],
				kind: FVar(macro :Int),
				pos: Context.currentPos()
			});

			final ctorArgs:Array<FunctionArg> = [];
			final ctorBody:Array<Expr> = [macro this.type = $v{typeName}];

			// for (field in (event.fields:Array<Dynamic>)) {
			// 	final fieldName:String = field.name;
			// 	final fieldTypeStr:String = field.type;

			// 	final complexType = switch (fieldTypeStr) {
			// 		case "Int": macro: Int;
			// 		case "Float": macro: Float;
			// 		case "String": macro: String;
			// 		case "Bool": macro: Bool;
			// 		default: Context.error('Unsupported type: $fieldTypeStr', Context.currentPos());
			// 	};

			// 	fields.push({
			// 		name: fieldName,
			// 		access: [APublic],
			// 		kind: FVar(complexType),
			// 		pos: Context.currentPos()
			// 	});

			// 	ctorArgs.push({
			// 		name: fieldName,
			// 		type: complexType,
			// 		opt: false
			// 	});

			// 	// ctorBody.push(
			// 	// 	macro this.$fieldName = $i{fieldName}
			// 	// );
			// 	// ctorBody.push({
			// 	// 	expr: EBinop(OpAssign,
			// 	// 		{ expr: EField({ expr: EConst(CIdent("this")), pos: Context.currentPos() }, fieldName), pos: Context.currentPos() },
			// 	// 		{ expr: EConst(CIdent(fieldName)), pos: Context.currentPos() }
			// 	// 	),
			// 	// 	pos: Context.currentPos()
			// 	// });
			// }

			// Constructor
			fields.push({
				name: "new",
				access: [APublic],
				kind: FFun({
					args: ctorArgs,
					ret: null,
					expr: {
						expr: EBlock(ctorBody),
						pos: Context.currentPos()
					}
				}),
				pos: Context.currentPos()
			});

			defs.push({
				name: className,
				kind: TDClass(null, [
					{
						pack: ["events"],
						name: "IEvent",
						params: []
					}
				]),
				fields: fields,
				pack: ["events", "gentwo"],
				pos: Context.currentPos(),
				meta: [],
			});
		}

		Context.onAfterInitMacros(() -> {
			trace('about to define ${defs.length} event types');
			for (d in defs) {
				final fqdn = d.pack.join('.') + "." + d.name;

				trace('looking at: ${fqdn}');
				// trace('looking at: ${d.pack.join('.')}.${d.name}\n${d.kind}\n${d.fields}');
				try {
					Context.getType(fqdn); // this will throw if not defined
					trace('found type for ${fqdn}');
					continue;
					// Already defined, skip
				} catch (e:Dynamic) {
					trace('${d.name} not defined. Defining Type...');
					Context.defineType(d);
					trace('type ${d.name} now defined');
				}
			}
		});

		return null;
	}

	static function toPascalCase(s:String):String {
		return s.split("_").map(word -> word.charAt(0).toUpperCase() + word.substr(1)).join("");
	}
	#end
}
