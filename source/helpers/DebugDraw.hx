package helpers;

import flixel.FlxG;
import flixel.FlxBasic;
#if FLX_DEBUG
import flixel.math.FlxPoint;
import openfl.display.Graphics;
#end

class DebugDraw extends FlxBasic {
	public static var ME(get, null):DebugDraw;

	static function get_ME():DebugDraw {
		if (ME == null) {
			FlxG.plugins.add(ME = new DebugDraw());
			#if !FLX_DEBUG
			FlxG.log.error("DebugDraw called without debug flag enabled");
			#end
		}

		return ME;
	}

	#if FLX_DEBUG
	private var calls:Array<(Graphics)->Void> = [];
	private var tmpPoint = FlxPoint.get();
	private var tmpPoint2 = FlxPoint.get();
	private var tmpPoint3 = FlxPoint.get();
	private var tmpPoint4 = FlxPoint.get();

	public function drawWorldRect(x:Float, y:Float, width:Float, height:Float, color:Int = 0xFF00FF) {
		calls.push((gfx) -> {
			// TODO: This doesn't take any scroll factor into account. We'd need a better way to pass this in
			tmpPoint.set(x, y).subtract(FlxG.camera.scroll.x, FlxG.camera.scroll.y);
			tmpPoint2.set(x + width, y + height).subtract(FlxG.camera.scroll.x, FlxG.camera.scroll.y);
			tmpPoint3.set(x + width, y).subtract(FlxG.camera.scroll.x, FlxG.camera.scroll.y);
			tmpPoint4.set(x, y + height).subtract(FlxG.camera.scroll.x, FlxG.camera.scroll.y);
			if (!(FlxG.camera.containsPoint(tmpPoint) ||
				FlxG.camera.containsPoint(tmpPoint2) ||
				FlxG.camera.containsPoint(tmpPoint3) ||
				FlxG.camera.containsPoint(tmpPoint4))) {
					// if we don't contain one point on the rectangle, then don't draw it
					return;
			}

			gfx.lineStyle(1, color, 0.8);
			gfx.drawRect(tmpPoint.x, tmpPoint.y, width, height);
		});
	}

	public function drawCameraRect(x:Float, y:Float, width:Float, height:Float, color:Int = 0xFF00FF) {
		calls.push((gfx) -> {
			tmpPoint.set(x, y);
			tmpPoint2.set(x + width, y + height);
			tmpPoint3.set(x + width, y);
			tmpPoint4.set(x, y + height);
			if (!(FlxG.camera.containsPoint(tmpPoint) ||
				FlxG.camera.containsPoint(tmpPoint2) ||
				FlxG.camera.containsPoint(tmpPoint3) ||
				FlxG.camera.containsPoint(tmpPoint4))) {
					// if we don't contain one point on the rectangle, then don't draw it
					return;
			}

			gfx.lineStyle(1, color, 0.8);
			gfx.drawRect(x, y, width, height);
		});
	}

	public function drawWorldLine(startX:Float, startY:Float, endX:Float, endY:Float, color:Int = 0xFF00FF) {
		calls.push((gfx) -> {
			// TODO: This doesn't take any scroll factor into account. We'd need a better way to pass this in
			tmpPoint.set(startX, startY).subtract(FlxG.camera.scroll.x, FlxG.camera.scroll.y);
			tmpPoint2.set(endX, endY).subtract(FlxG.camera.scroll.x, FlxG.camera.scroll.y);
			if (!(FlxG.camera.containsPoint(tmpPoint) ||
				FlxG.camera.containsPoint(tmpPoint2))) {
					// if we don't contain one point of the line, then don't draw it
					return;
			}
			gfx.lineStyle(1, color, 0.8);
			gfx.moveTo(tmpPoint.x, tmpPoint.y);
			gfx.lineTo(tmpPoint2.x, tmpPoint2.y);
		});
	}

	public function drawCameraLine(startX:Float, startY:Float, endX:Float, endY:Float, color:Int = 0xFF00FF) {
		calls.push((gfx) -> {
			tmpPoint.set(startX, startY);
			tmpPoint2.set(endX, endY);
			if (!(FlxG.camera.containsPoint(tmpPoint) ||
				FlxG.camera.containsPoint(tmpPoint2))) {
					// if we don't contain one point of the line, then don't draw it
					return;
			}
			gfx.lineStyle(1, color, 0.8);
			gfx.moveTo(startX, startY);
			gfx.lineTo(endX, endY);
		});
	}
	#else
	// all no-ops when not in debug
	public function drawWorldRect(x:Float, y:Float, width:Float, height:Float, color:Int = 0x0) {}
	public function drawCameraRect(x:Float, y:Float, width:Float, height:Float, color:Int = 0x0) {}
	public function drawWorldLine(startX:Float, startY:Float, endX:Float, endY:Float, color:Int = 0x0) {}
	public function drawCameraLine(startX:Float, startY:Float, endX:Float, endY:Float, color:Int = 0x0) {}
	#end

	override function update(elapsed:Float) {
		super.update(elapsed);
	}

	override function draw() {
		super.draw();

		#if FLX_DEBUG
		trace('drawing ${calls.length} debug draws');
		for (drawCall in calls) {
			drawCall(FlxG.camera.debugLayer.graphics);
		}
		calls = [];
		#end
	}
}