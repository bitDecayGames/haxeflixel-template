package loaders;

/**
 * A bunch of typedefs for the Aseprite export json format. Borrowed from GeoKureli's PR pending merge into
 * flixel code base: https://github.com/HaxeFlixel/flixel/pull/2860/files
**/

typedef AtlasBase<T> = { frames:T }

typedef AseAtlasBase<T> = AtlasBase<T> &
{
	var meta:AseAtlasMeta;
}

typedef AseAtlasArray = AseAtlasBase<Array<AseAtlasFrame>>;

abstract Hash<T>(Dynamic)
{
	public inline function keyValueIterator():KeyValueIterator<String, T>
	{
		var keys = Reflect.fields(this).iterator();
		return
		{
			hasNext: keys.hasNext,
			next: ()->
			{
				final key = keys.next();
				return { key:key, value:Reflect.field(this, key)};
			}
		};
	}
}

/**
 * Position struct use for atlas json parsing, { x:Float, y:Float }
 */
 typedef AtlasPos = { x:Float, y:Float };

/**
 * Rectangle struct use for atlas json parsing, { x:Float, y:Float, w:Float, h:Float }
 */
 typedef AtlasRect = AtlasPos & AtlasSize;

typedef AtlasFrame =
{
	var filename:String;
	var rotated:Bool;
	var frame:AtlasRect;
	var sourceSize:AtlasSize;
	var spriteSourceSize:AtlasPos;
}

typedef AseAtlasFrame = AtlasFrame & { duration:Int }

typedef AseAtlasHash = AseAtlasBase<Hash<AseAtlasFrame>>;

typedef HashOrArray<T> = flixel.util.typeLimit.OneOfTwo<Hash<T>, Array<T>>;

typedef AseAtlas = AseAtlasBase<HashOrArray<AseAtlasFrame>>;

/**
 * Size struct use for atlas json parsing, { w:Float, h:Float }
 */
 typedef AtlasSize = { w:Float, h:Float };

typedef AseAtlasMeta =
{
	var app:String;
	var version:String;
	var image:String;
	var format:String;
	var size:AtlasSize;
	var scale:String;
	var frameTags:Array<AseAtlasTag>;
	var slices:Array<AseAtlasSlice>;
	var layers:Array<AseAtlasLayer>;
}

typedef AseAtlasTag = {
	name: String,
	from:Int,
	to:Int,
	direction:String,
	repeat:Int,
};

typedef AseAtlasSliceKey =
{
	/**
	 * The frame that the slice changes size
	 */
	var frame:Int;
	/**
	 * The size of the slice at this frame
	 */
	var bounds:AtlasRect;
};

typedef AseAtlasSlice =
{
	var name:String;
	var color:String;

	/**
	 * Info of at what frames the slice changes size
	 */
	var keys: Array<AseAtlasSliceKey>;
}

enum abstract AseBlendMode(String)
{
	var NORMAL = "normal";

	var DARKEN = "darken";
	var MULTIPLY = "multiply";
	var COLOR_BURN = "color_burn";

	var LIGHTEN = "lighten";
	var SCREEN = "screen";
	var COLOR_DODGE = "color_dodge";
	var ADDITION = "addition";

	var OVERLAY = "overlay";
	var SOFT_LIGHT = "soft_light";
	var HARD_LIGHT = "hard_light";

	var DIFFERENCE = "difference";
	var EXCLUSION = "exclusion";
	var SUBTRACT = "subtract";
	var DIVIDE = "divide";

	var HSL_HUE = "hsl_hue";
	var HSL_SATURATION = "hsl_saturation";
	var HSL_COLOR = "hsl_color";
	var HSL_LUMINOSITY = "hsl_luminosity";
}

typedef AseCelData = {
    frame:Int,
    color:String,
    data:String,
}

typedef AseAtlasLayer =
{
	var name:String;

	/**
	 * The name of the parent layer
	 */
	@:optional var group:String;

	/**
	 * Ranges from 0 to 255
	 */
	@:optional var opacity:Int;

	/**
	 *
	 */
	@:optional var blendMode:AseBlendMode;

	@:optional var cels:Array<AseCelData>;
}
