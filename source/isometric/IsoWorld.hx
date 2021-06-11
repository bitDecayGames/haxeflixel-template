package isometric;

import flixel.math.FlxPoint;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxColor;
import flixel.math.FlxMath;
import flixel.FlxSprite;

class IsoWorld extends FlxSprite {
	private var tileWidth:Int;
	private var tileHeight:Int;

	// convenience floats since the half values are used frequently
	private var halfTileWidth:Float;
	private var halfTileHeight:Float;

	public function new(tileWidth:Int, tileHeight:Int) {
		super();
		this.tileWidth = tileWidth;
		this.tileHeight = tileHeight;
		halfTileWidth = tileWidth * 0.5;
		halfTileHeight = tileHeight * 0.5;
	}

	// private function calculateWorldImage() {
	// 	var totalX = FlxMath.absInt(worldMaxX - worldMinX);
	// 	var totalY = FlxMath.absInt(worldMaxY - worldMinY);
	// 	if (totalX == 0 || totalY == 0) {
	// 		return;
	// 	}
	// 	var totalWidth = Std.int((totalX + totalY) * halfTileWidth);
	// 	var totalHeight = Std.int((totalX + totalY) * halfTileHeight);
	// 	makeGraphic(totalWidth, totalHeight, 0x55FF00FF, false, "isoworld");
	// 	var offset = totalHeight * .5 + halfTileHeight;
	// 	var scaleX = 1.0; // halfTileWidth;
	// 	var scaleY = 1.0; // halfTileHeight;
	// 	for (xI in 0...(totalX + 1)) {
	// 		var isoX = xI * scaleX;
	// 		var start = isometricToCartesian(isoX, 0);
	// 		var end = isometricToCartesian(isoX, totalY * halfTileHeight);
	// 		FlxSpriteUtil.drawLine(this, start.x, -start.y + offset, end.x, -end.y + offset, {thickness: 1, color: 0xFFFF00FF});
	// 	}
	// 	for (yI in 0...(totalY + 1)) {
	// 		var isoY = yI * scaleY;
	// 		var start = isometricToCartesian(0, isoY).add(-x, -y);
	// 		var end = isometricToCartesian(totalX * halfTileWidth, isoY).add(-x, -y);
	// 		FlxSpriteUtil.drawLine(this, start.x, -start.y + offset, end.x, -end.y + offset, {thickness: 1, color: 0xFFFF00FF});
	// 	}
	// 	FlxSpriteUtil.drawCircle(this, 0, 0, 5);
	// }
	// get the relative isometric coordinate given a standard cartesian (x,y)
	public function cartesianToIsometric(cartesianX:Float, cartesianY:Float):FlxPoint {
		var cartX = cartesianX - x;
		var cartY = cartesianY - y;
		return FlxPoint.get((cartX / halfTileWidth) - (((cartY / halfTileHeight) + (cartX / halfTileWidth)) / 2.0),
			((cartY / halfTileHeight) + (cartX / halfTileWidth)) / 2.0);
	}

	// get the world cartesian point (accounting for this object's x,y) from an isometric coordinate
	public function isometricToCartesian(isoX:Float, isoY:Float):FlxPoint {
		return FlxPoint.get((halfTileWidth * isoX) + (halfTileWidth * isoY), (-halfTileHeight * isoX) + (halfTileHeight * isoY)).add(x, y);
	}
}
