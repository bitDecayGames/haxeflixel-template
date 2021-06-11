package states;

import flixel.util.FlxSort;
import flixel.group.FlxGroup;
import flixel.math.FlxRandom;
import flixel.graphics.frames.FlxTileFrames;
import flixel.math.FlxPoint;
import openfl.display.BitmapData;
import openfl.Assets;
import flixel.graphics.atlas.FlxNode;
import flixel.graphics.atlas.FlxAtlas;
import flixel.addons.transition.FlxTransitionableState;
import signals.Lifecycle;
import entities.Player;
import isometric.IsoWorld;
import flixel.FlxSprite;
import flixel.FlxG;

using extensions.FlxStateExt;

class PlayState extends FlxTransitionableState {
	var player:FlxSprite;
	var isoWorld:IsoWorld;
	var grp:FlxTypedGroup<FlxSprite>;
	var tileFrames:FlxTileFrames;
	var rnd:FlxRandom;

	override public function create() {
		super.create();
		Lifecycle.startup.dispatch();

		FlxG.camera.pixelPerfectRender = true;

		player = new Player();
		add(player);

		var atlas:FlxAtlas = new FlxAtlas("myAtlas");

		// and add nodes (images) to it
		var tilesNode:FlxNode = createNodeAndDisposeBitmap("assets/images/isometric/tiles.png", atlas);
		tileFrames = tilesNode.getTileFrames(FlxPoint.get(100, 80));

		rnd = new FlxRandom();

		isoWorld = new IsoWorld(100, 50);
		isoWorld.x = 230;
		isoWorld.y = 200;
		add(isoWorld);

		grp = new FlxTypedGroup<FlxSprite>();
		add(grp);
		gen();
	}

	function gen() {
		for (s in grp) {
			s.kill();
		}
		grp.clear();
		for (x in 0...10) {
			for (y in 0...10) {
				var spr = new FlxSprite();
				var p = isoWorld.isometricToCartesian(x - 5, y - 5);
				spr.setPosition(p.x, p.y);
				spr.setFrames(tileFrames, false);
				spr.frame = tileFrames.frames[rnd.int(0, tileFrames.frames.length)];
				grp.add(spr);
			}
		}
		grp.sort(FlxSort.byY, FlxSort.ASCENDING);
	}

	/**
	 * Helper method for getting FlxNodes for images, but with image disposing (for memory savings)
	 * @param	source	path to the image
	 * @param	atlas	atlas to load image onto
	 * @return	created FlxNode object for image
	 */
	function createNodeAndDisposeBitmap(source:String, atlas:FlxAtlas):FlxNode {
		var bitmap:BitmapData = Assets.getBitmapData(source);
		var node:FlxNode = atlas.addNode(bitmap, source);
		Assets.cache.removeBitmapData(source);
		bitmap.dispose();
		return node;
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);

		if (FlxG.keys.justPressed.SPACE) {
			gen();
		}
	}

	override public function onFocusLost() {
		super.onFocusLost();
		this.handleFocusLost();
	}

	override public function onFocus() {
		super.onFocus();
		this.handleFocus();
	}
}
