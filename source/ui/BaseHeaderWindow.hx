package ui;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxG;
import bitdecay.flixel.graphics.Aseprite;
import bitdecay.flixel.graphics.AsepriteMacros;
import bitdecay.flixel.spacial.Align;
import bitdecay.flixel.ui.Window;
import flixel.group.FlxSpriteContainer.FlxSpriteContainer;
import ui.font.BitmapText.PressStart;

/**
 * A basic two-part window with a separate header and content panels.
 * Assumes that the borders and backgrounds are pulled from the static `styles` 
 * object contained in this class.
 *
 * Further customization can be applied by accessing the contained `Window`
 * objects once constructed.
**/
class BaseHeaderWindow extends FlxSpriteContainer {
	public var headerText:PressStart;

	public var header:Window;
	public var content:Window;

	var index:Int = 0;
	var readyForInput = true;

	public function new(title:String, X:Float, Y:Float, width:Int, contentHeight:Int, borderStyle:String, bgStyle:String) {
		super(X, Y);

		var borderFrame = Aseprite.getSliceFrame(AssetPaths.windows__json, borderStyle);
		var sliceKey = Aseprite.getSliceKey(AssetPaths.windows__json, borderStyle);
		var bgFrame = Aseprite.getSliceFrame(AssetPaths.windows__json, bgStyle);
		header = new Window(0, 0, width, 32, borderFrame, sliceKey, bgFrame);
		headerText = new PressStart(0, 0, title);
		content = new Window(0, header.height + 5, width, contentHeight, borderFrame, sliceKey, bgFrame);

		// Add everything at the end because `FlxSpriteContainer.add()` moves the object
		// to account for the container's position, assuming the added object is positioned
		// relative to the container's X/Y
		add(header);
		add(headerText);
		add(content);
		Align.center(headerText, header);
	}
}
