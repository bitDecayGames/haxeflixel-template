package ui;

import flixel.math.FlxPoint;
import haxe.ui.core.Component;

class ComponentExt {
	public static function recursivePosition(c:Component):FlxPoint {
		var absPos = FlxPoint.get();
		var traceUp = c;
		while (traceUp != null) {
			absPos.x += traceUp.left;
			absPos.y += traceUp.top;
			traceUp = traceUp.parentComponent;
		}
		return absPos;
	}
}
