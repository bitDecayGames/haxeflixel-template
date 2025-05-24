package ui;

import flixel.math.FlxPoint;
import flixel.util.FlxSort;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import bitdecay.flixel.graphics.Aseprite;
import bitdecay.flixel.ui.Window;

/**
 * A window that holds a set of scrollable objects. Handles scrolling between
 * them in a configurable style.
 *
 * If items in the window are moved, `applyLayout()` should be called to ensure
 * scrolling coordinates are updated properly.
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

	public var style:ScrollStyle;

	/**
	 * How far apart elements have to be for a new scroll coordinate to be
	 * added to the window. If elements are closer together than this value
	 * on an axis, they will not have a distinct scroll position on that axis
	**/
	public var tolerance = 5;

	var rowIndex:Int = 0;
	var colIndex:Int = 0;
	var rowCoords:Array<Float> = [];
	var colCoords:Array<Float> = [];
	var scrolling = false;

	// we use this for our tweens so that the window can move while scroll tweens are
	// occurring.
	var scrollOffset = FlxPoint.get();

	public function new(X:Float, Y:Float, width:Int, contentHeight:Int, borderStyle:String, bgStyle:String) {
		var borderFrame = Aseprite.getSliceFrame(AssetPaths.windows__json, borderStyle);
		var sliceKey = Aseprite.getSliceKey(AssetPaths.windows__json, borderStyle);
		var bgFrame = Aseprite.getSliceFrame(AssetPaths.windows__json, bgStyle);
		super(X, Y, width, contentHeight, borderFrame, sliceKey, bgFrame);

		style = getDefaultStyle();
	}

	override function applyLayout() {
		super.applyLayout();

		var inCols:Array<Float> = [];
		var inRows:Array<Float> = [];
		for (gc in gridCells) {
			inCols.push(gc.obj.x);
			inRows.push(gc.obj.y);
		}

		inCols.sort((a, b) -> {
			FlxSort.byValues(FlxSort.ASCENDING, a, b);
		});
		inRows.sort((a, b) -> {
			FlxSort.byValues(FlxSort.ASCENDING, a, b);
		});

		colCoords = [];
		rowCoords = [];

		var last:Float = Math.NEGATIVE_INFINITY;
		for (c in inCols) {
			if (c - last < tolerance) {
				continue;
			}
			colCoords.push(c);
			last = c;
		}

		last = Math.NEGATIVE_INFINITY;
		for (r in inRows) {
			if (r - last < tolerance) {
				continue;
			}
			rowCoords.push(r);
			last = r;
		}
	}

	public function scrollUp(numItems:Int = 1) {
		scrollVertical(rowIndex - numItems);
	}

	public function scrollDown(numItems:Int = 1) {
		scrollVertical(rowIndex + numItems);
	}

	public function scrollLeft(numItems:Int = 1) {
		scrollHorizontal(colIndex - numItems);
	}

	public function scrollRight(numItems:Int = 1) {
		scrollHorizontal(colIndex + numItems);
	}

	function scrollVertical(toIndex:Int) {
		toIndex = boundIndex(toIndex, rowCoords);
		if (scrolling || toIndex == rowIndex) {
			return;
		}

		var scroll = rowCoords[rowIndex] - rowCoords[toIndex];

		if (scroll == 0) {
			rowIndex = toIndex;
			return;
		}

		scrolling = true;
		FlxTween.tween(scrollOffset, {y: scrollOffset.y + scroll}, style.duration, {
			ease: style.ease,
			onComplete: (t) -> {
				rowIndex = toIndex;
				scrolling = false;
			}
		});
	}

	function scrollHorizontal(toIndex:Int) {
		toIndex = boundIndex(toIndex, colCoords);
		if (scrolling || toIndex == colIndex) {
			return;
		}

		var scroll = colCoords[colIndex] - colCoords[toIndex];

		if (scroll == 0) {
			colIndex = toIndex;
			return;
		}

		scrolling = true;
		FlxTween.tween(scrollOffset, {x: scrollOffset.x + scroll}, style.duration, {
			ease: style.ease,
			onComplete: (t) -> {
				colIndex = toIndex;
				scrolling = false;
			}
		});
	}

	function boundIndex(inVal:Int, arr:Array<Float>):Int {
		return inVal < 0 ? 0 : inVal >= arr.length ? arr.length - 1 : inVal;
	}

	override function update(elapsed:Float) {
		super.update(elapsed);
		objects.setPosition(bg.x + scrollOffset.x, bg.y + scrollOffset.y);
	}
}

typedef ScrollStyle = {
	ease:EaseFunction,
	duration:Float,
}
