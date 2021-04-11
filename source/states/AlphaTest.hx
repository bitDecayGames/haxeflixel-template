package states;

import openfl.geom.ColorTransform;
import openfl.display.BitmapDataChannel;
import openfl.geom.Point;
import openfl.display.BitmapData;
import openfl.geom.Rectangle;
import flixel.FlxG;
import flixel.system.FlxAssets;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.FlxState;

class AlphaTest extends FlxState {
	override public function create() {
		var bg = new FlxSprite(AssetPaths.flixellogosmall__png);
		bg.scale.x = FlxG.width / bg.width;
		bg.scale.y = FlxG.height / bg.height;
		bg.screenCenter();
		// bg.makeGraphic(FlxG.width, FlxG.height, FlxColor.GRAY);
		add(bg);

		var base:FlxSprite = new FlxSprite();
		base.makeGraphic(FlxG.width, FlxG.height, FlxColor.RED.getDarkened(0.5));
		base.scrollFactor.set();
		add(base);

		// First image: transparent black background, yellow circle
		var tester = new FlxSprite();
		tester.makeGraphic(50, 50, 0x00000000);
		FlxSpriteUtil.drawCircle(tester, 25, 25, 23, 0xffffff00);
		add(tester);

		// Second Image: inverted color channels with same alpha
		// Yellow becomes blue `0xFFFFFF00` -> `0xFF0000FF`
		var invertColor = new FlxSprite();
		invertColor.x = 50;
		invertColor.pixels = tester.pixels.clone();
		invertColor.pixels.colorTransform(new Rectangle(0, 0, tester.width, tester.height), new ColorTransform(-1, -1, -1, 1, 255, 255, 255, 0));
		add(invertColor);

		// Third image: same color channels, inverted alpha
		// I would EXPECT the edge pixels to become opaque black `0x00000000` -> 0xFF000000`
		var invertAlpha = new FlxSprite();
		invertAlpha.x = 100;
		invertAlpha.pixels = tester.pixels.clone();
		invertAlpha.pixels.colorTransform(new Rectangle(0, 0, tester.width, tester.height), new ColorTransform(1, 1, 1, -1, 0, 0, 0, 255));
		add(invertAlpha);

		// Forth image: recommended transform based on articles referenced earlier in this channel
		var invertAlphaBlack = new FlxSprite();
		invertAlphaBlack.x = 150;
		invertAlphaBlack.pixels = tester.pixels.clone();
		invertAlphaBlack.pixels.colorTransform(new Rectangle(0, 0, tester.width, tester.height), new ColorTransform(0, 0, 0, -1, 0, 0, 0, 255));
		add(invertAlphaBlack);

		// FlxSpriteUtil.drawCircle(base, 100, 100, 100, 0xffffff00);

		base.pixels.copyPixels(tester.pixels, new Rectangle(0, 0, 50, 50), new Point(150, 150));

		var mask:FlxSprite = new FlxSprite();
		mask.makeGraphic(FlxG.width, FlxG.height, 0x00ffffff);
		FlxSpriteUtil.drawCircle(mask, mask.getMidpoint().x, mask.getMidpoint().y, 40, FlxColor.WHITE);

		// FlxSpriteUtil.alphaMaskFlxSprite(base, mask, base);
		// invertedAlphaMaskFlxSprite(base, mask, base);
		/** This seems to work
			// var mask = new FlxSprite().makeGraphic(100, 100, FlxColor.TRANSPARENT);
			// FlxSpriteUtil.drawCircle(mask, mask.getMidpoint().x, mask.getMidpoint().y, 40, FlxColor.WHITE);

			// var spr = new FlxSprite(AssetPaths.flixellogosmall__png);
			// add(spr);

			// FlxSpriteUtil.alphaMaskFlxSprite(spr, mask, spr);
		**/
	}

	function invertedAlphaMaskFlxSprite(sprite:FlxSprite, mask:FlxSprite, output:FlxSprite):FlxSprite {
		// Solution based on the discussion here:
		// https://groups.google.com/forum/#!topic/haxeflixel/fq7_Y6X2ngY

		// NOTE: The code below is the same as FlxSpriteUtil.alphaMaskFlxSprite(),
		// except it has an EXTRA section below.

		sprite.drawFrame();
		var data:BitmapData = sprite.pixels.clone();
		data.copyChannel(mask.pixels, new Rectangle(0, 0, sprite.width, sprite.height), new Point(), BitmapDataChannel.ALPHA, BitmapDataChannel.ALPHA);

		// EXTRA:
		// this code applies a -1 multiplier to the alpha channel,
		// turning the opaque circle into a transparent circle.
		data.colorTransform(new Rectangle(0, 0, sprite.width, sprite.height), new ColorTransform(0, 0, 0, -1, 0, 0, 0, 255));
		// end EXTRA

		output.pixels = data;
		return output;
	}
}
