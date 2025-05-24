package ui;

import bitdecay.flixel.graphics.Aseprite;
import bitdecay.flixel.spacial.Align;
import bitdecay.flixel.ui.Window;
import flixel.group.FlxSpriteContainer.FlxSpriteContainer;
import ui.font.BitmapText.PressStart;

/**
 * A helper that builds a header for the provided content window
**/
class BaseHeaderWindow extends FlxSpriteContainer {
	public var headerText:PressStart;

	public var header:Window;
	public var content:Window;

	var index:Int = 0;
	var readyForInput = true;

	public function new(X:Float, Y:Float, title:String, content:Window, borderStyle:String, bgStyle:String) {
		super(X, Y);

		this.content = content;

		var borderFrame = Aseprite.getSliceFrame(AssetPaths.windows__json, borderStyle);
		var sliceKey = Aseprite.getSliceKey(AssetPaths.windows__json, borderStyle);
		var bgFrame = Aseprite.getSliceFrame(AssetPaths.windows__json, bgStyle);
		header = new Window(0, 0, Std.int(content.border.width), 32, borderFrame, sliceKey, bgFrame);
		headerText = new PressStart(0, 0, title);
		content.setPosition(header.x, header.y + header.height + 5);

		// Add everything at the end because `FlxSpriteContainer.add()` moves the object
		// to account for the container's position, assuming the added object is positioned
		// relative to the container's X/Y
		add(header);
		add(headerText);
		add(content);
		Align.center(headerText, header);
	}
}
