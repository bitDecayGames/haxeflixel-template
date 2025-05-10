package debug;

import bitdecay.flixel.debug.DebugUI;
import openfl.display.BitmapData;
import bitdecay.flixel.debug.SimpleDebugToolWindow;
import bitdecay.flixel.debug.DebugTool;

class TestTool extends DebugTool<SimpleDebugToolWindow> {
	public function new() {
		super('testTool', DebugUI.emptyIconData());
	}

	override function makeWindow(icon:BitmapData):SimpleDebugToolWindow {
		return new SimpleDebugToolWindow("Test Window", icon, [
			{
				label: "Button A",
				onClick: (_, _) -> {
					trace("you tapped A");
				}
			},
			{
				label: "Button B",
				onClick: (_, _) -> {
					trace("you tapped B");
				}
			}
		]);
	}
}
