package ui;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import bitdecay.flixel.graphics.Aseprite;
import bitdecay.flixel.ui.Window;

/**
 * A window that holds a set of scrollable objects. Handles scrolling between
 * them in a configurable style.
**/
class ItemScrollWindow extends Window {
	public static var DEFAULT_STYLE:ScrollStyle = {
		ease: FlxEase.sineOut,
		duration: .5,
	};

	private static function getDefaultStyle():ScrollStyle {
		return {
			ease: DEFAULT_STYLE.ease,
			duration: DEFAULT_STYLE.duration,
		};
	}

	var index:Int = 0;
	var scrolling = false;

	public var style:ScrollStyle;

	public function new(X:Float, Y:Float, width:Int, contentHeight:Int, borderStyle:String, bgStyle:String) {
		var borderFrame = Aseprite.getSliceFrame(AssetPaths.windows__json, borderStyle);
		var sliceKey = Aseprite.getSliceKey(AssetPaths.windows__json, borderStyle);
		var bgFrame = Aseprite.getSliceFrame(AssetPaths.windows__json, bgStyle);
		super(X, Y, width, contentHeight, borderFrame, sliceKey, bgFrame);

		style = getDefaultStyle();
	}

	public function scrollUp(numItems:Int = 1) {
		scroll(index - numItems);
	}

	public function scrollDown(numItems:Int = 1) {
		scroll(index + numItems);
	}

	function scroll(toIndex:Int) {
		toIndex = boundIndex(toIndex);
		if (scrolling || toIndex == index) {
			return;
		}

		var scroll = (bg.y + padding) - gridCells[toIndex].obj.y;

		if (scroll != 0) {
			scrolling = true;
			FlxTween.linearMotion(objects, objects.x, objects.y, objects.x, objects.y + scroll, style.duration, true, {
				ease: style.ease,
				onComplete: (t) -> {
					index = toIndex;
					scrolling = false;
				}
			});
		}
	}

	function boundIndex(inVal:Int):Int {
		return inVal < 0 ? 0 : inVal >= objects.length ? objects.length - 1 : inVal;
	}

	override function update(elapsed:Float) {
		super.update(elapsed);
	}
}

typedef ScrollStyle = {
	ease:EaseFunction,
	duration:Float,
}
