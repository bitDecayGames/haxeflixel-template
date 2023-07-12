package debug;

import debug.DebugDraw;
import openfl.events.MouseEvent;
import openfl.text.TextField;
import flixel.util.FlxColor;
import flixel.system.debug.DebuggerUtil;
import flixel.system.debug.Window;

/**
 * A simple window that provides toggle buttons for each custom debug draw layers
**/
class DebuggerWindow extends Window {
	public static inline var TEXT_SIZE:Int = 11;

	public function new() {
		super("Layers", new DebugLayersButton(0, 0), 0, 0, false);

		var gutter:Int = 5;
		var nextY:Int = Std.int(_header.height) + gutter;

		for (layerName => _ in DebugDraw.layer_enabled) {
			var layerLabel = DebuggerUtil.createTextField(gutter, nextY, FlxColor.BLACK, TEXT_SIZE);
			addChild(layerLabel);
			layerLabel.border = true;
			layerLabel.borderColor = FlxColor.BLACK;
			layerLabel.background = true;
			layerLabel.backgroundColor = FlxColor.WHITE;
			layerLabel.text = layerName.getName();
			layerLabel.addEventListener(MouseEvent.CLICK, (me) -> {
				DebugDraw.layer_enabled[layerName] = !DebugDraw.layer_enabled[layerName];
				layerLabel.backgroundColor = DebugDraw.layer_enabled[layerName] ? FlxColor.WHITE : FlxColor.GRAY;
			});

			nextY += Std.int(layerLabel.height + gutter);
			minSize.x = Math.max(minSize.x, layerLabel.width);
		}

		minSize.x += gutter * 2;
		minSize.y = nextY;

		updateSize();
	}
}