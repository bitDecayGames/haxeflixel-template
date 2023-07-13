package loaders;

import haxe.DynamicAccess;
import flixel.FlxSprite;

class Aseprite {
	public static function loadAllAnimations(into:FlxSprite, imgAsset:String, data:String) {
		var json = haxe.Json.parse(lime.utils.Assets.getText(data));
		var tags:Array<AsepriteAnimations.MetaTag> = json.meta.frameTags;

		into.loadGraphic(imgAsset, true, json.frames[0].sourceSize.w, json.frames[0].sourceSize.h);
		for (tag in tags) {
			into.animation.add(tag.name, [ for (i in tag.from...tag.to + 1) i ]);
		}
		for (i in 0...json.frames.length) {
			// TODO: Once we update flixel to 5.3, this should be available
			// into.frames.frames[i].duration = frameAccess.get(frameNames[i]).duration;
		}
	}
}