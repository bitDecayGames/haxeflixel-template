package helpers;

import haxe.DynamicAccess;
import flixel.FlxSprite;

class SpriteLoader {
	public static function loadAllAnimations(into:FlxSprite, imgAsset:String, data:String) {
		var json = haxe.Json.parse(lime.utils.Assets.getText(data));
		var frameAccess:DynamicAccess<Dynamic> = haxe.Json.parse(lime.utils.Assets.getText(data)).frames;
		var width = -1;
		var height = -1;
		var frameNames = Reflect.fields(json.frames);
		for (f in frameNames) {
			var frameData = frameAccess.get(f);
			width = frameData.sourceSize.w;
			height = frameData.sourceSize.h;
			break;
		}

		var tags:Array<AseAnims.MetaTag> = json.meta.frameTags;

		into.loadGraphic(imgAsset, true, width, height);

		for (i in 0...frameNames.length) {
			// TODO: Once we update flixel to 5.3, this should be available
			// into.frames.frames[i].duration = frameAccess.get(frameNames[i]).duration;
		}
		for (tag in tags) {
			into.animation.add(tag.name, [ for (i in tag.from...tag.to + 1) i ]);
		}
	}
}