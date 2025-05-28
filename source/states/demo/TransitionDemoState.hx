package states.demo;

import flixel.util.FlxTimer;
import ui.font.BitmapText.PressStart;
import flixel.FlxSubState;
import bitdecay.flixel.transitions.TiledSpriteTransition;
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
	var tileTrans:TiledSpriteTransition;

	var currentIndex = 0;
	var transitionNames:Array<String> = [];
	var transitionBuilders:Array<() -> FlxSubState> = [];
	var infoLabel:PressStart;

	override public function create() {
		super.create();

		infoLabel = new PressStart(0, 20, "");
		infoLabel.borderColor = FlxColor.BLUE;
		infoLabel.borderStyle = OUTLINE;
		infoLabel.screenCenter();
		add(infoLabel);

		addExample("Cascade", () -> {
			var tweenIn = (x, y) -> {
				var t = new FlxSprite(x, y);
				t.makeGraphic(40, 40, FlxColor.fromHSB(FlxG.random.int(0, 359), 1, .7));
				t.scale.set();
				t.alpha = 0;
				FlxTween.tween(t, {
					"scale.x": 1,
					"scale.y": 1,
					angle: 360,
					alpha: 1
				}, 1);
				return t;
			};
			var tweenOut = (s) -> {
				FlxTween.linearMotion(s, s.x, s.y, s.x, camera.viewBottom, FlxG.random.float(.9, 1.1), true, {
					ease: FlxEase.quadIn
				});
			};
			var dir = FlxPoint.get(1, 0);
			dir.degrees = FlxG.random.int(0, 359);
			return new CascadingTileTransition(dir, 40, 40, 1, tweenIn, tweenOut);
		});
		addExample("Tiled", () -> {
			var tileSprite = new FlxSprite();
			Aseprite.loadAllAnimations(tileSprite, AssetPaths.items__json);
			var anims = AsepriteMacros.tagNames("assets/aseprite/items.json");
			return new TiledSpriteTransition(tileSprite, anims.items_0_aseprite, () -> {}, true);
		});
	}

	function addExample(name:String, builder:() -> FlxSubState) {
		transitionNames.push(name);
		transitionBuilders.push(builder);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);

		if (FlxG.keys.justPressed.LEFT) {
			currentIndex = (currentIndex + transitionNames.length - 1) % transitionNames.length;
		} else if (FlxG.keys.justPressed.RIGHT) {
			currentIndex = (currentIndex + 1) % transitionNames.length;
		}

		infoLabel.text = '${transitionNames[currentIndex]} (enter to see. left/right to choose)';
		infoLabel.screenCenter(X);

		if (FlxG.keys.justPressed.ENTER) {
			var subState = transitionBuilders[currentIndex]();
			FlxTimer.wait(3, () -> {
				closeSubState();
			});
			openSubState(subState);
		}
	}
}
