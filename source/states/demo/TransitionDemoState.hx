package states.demo;

import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.math.FlxPoint;
import bitdecay.flixel.transitions.CascadingTileTransition;
import bitdecay.flixel.graphics.AsepriteMacros;
import bitdecay.flixel.graphics.Aseprite;
import flixel.FlxG;
import flixel.FlxState;
import flixel.util.FlxColor;
import flixel.FlxSprite;

using states.FlxStateExt;

class TransitionDemoState extends FlxState {
	var cascadeTransition:CascadingTileTransition;

	override public function create() {
		super.create();

		cascadeTransition = new CascadingTileTransition(FlxPoint.get(-1, .1), 40, 40, 4, tweenIn, tweenOut);
	}

	function tweenIn(x, y):FlxSprite {
		var t = new FlxSprite(x, y);
		t.makeGraphic(40, 40, FlxColor.fromHSB(FlxG.random.int(0, 6) * 10, 1, .7));
		t.setPosition(x, 0);
		FlxTween.linearMotion(t, t.x, t.y, x, y, FlxG.random.float(.9, 1.1), true, {
			ease: FlxEase.bounceOut
		});
		// t.scale.set();
		// t.alpha = 0;
		// FlxTween.tween(t, {"scale.x": 1, "scale.y": 1, angle: 360, alpha: 1}, 1);
		return t;
	}

	function tweenOut(t:FlxSprite) {
		FlxTween.linearMotion(t, t.x, t.y, t.x, camera.viewBottom, FlxG.random.float(.9, 1.1), true, {
			ease: FlxEase.quadIn
		});
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);

		if (FlxG.keys.justPressed.ENTER) {
			var tile = new FlxSprite();
			var slices = AsepriteMacros.sliceNames("assets/aseprite/items.json");
			Aseprite.loadSlice(tile, AssetPaths.items__json, slices.item1_0);
			destroySubStates = false;
			persistentUpdate = true;
			openSubState(cascadeTransition);
		}

		if (FlxG.keys.justPressed.C) {
			cascadeTransition.modeIn = false;
			cascadeTransition.resetSweep();
		}
	}
}
