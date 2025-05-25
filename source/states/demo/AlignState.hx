package states.demo;

import haxe.EnumTools;
import flixel.FlxG;
import ui.font.BitmapText.PressStart;
import bitdecay.flixel.spacial.Align;
import flixel.FlxState;
import flixel.util.FlxColor;
import flixel.FlxSprite;

using states.FlxStateExt;

class AlignState extends FlxState {
	var mode:AlignMode = EDGE;
	var modeLabel:PressStart;
	var a:FlxSprite;
	var b:FlxSprite;

	override public function create() {
		super.create();

		var mouseInstruct = new PressStart(0, 20, "Click and drag to move white square");
		mouseInstruct.screenCenter(X);

		var keyInstruct = new PressStart("Arrow keys to align in current mode");

		modeLabel = new PressStart(0, 20, "");
		modeLabel.borderColor = FlxColor.BLUE;
		modeLabel.borderStyle = OUTLINE;
		modeLabel.screenCenter(X);

		Align.center(keyInstruct, mouseInstruct, X);
		Align.stack(keyInstruct, mouseInstruct, DOWN, 5);
		Align.stack(modeLabel, keyInstruct, DOWN, 5);

		a = new FlxSprite(50, 50);
		a.makeGraphic(20, 20, FlxColor.WHITE);

		b = new FlxSprite();
		b.screenCenter();
		b.makeGraphic(30, 30, FlxColor.YELLOW.getDarkened(.5));

		add(mouseInstruct);
		add(keyInstruct);
		add(modeLabel);
		add(b);
		add(a);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);

		if (FlxG.mouse.pressed) {
			a.x += FlxG.mouse.deltaX;
			a.y += FlxG.mouse.deltaY;
		}

		if (FlxG.keys.justPressed.ENTER) {
			if (mode == EDGE) {
				mode = CENTER;
			} else if (mode == CENTER) {
				mode = STACK;
			} else if (mode == STACK) {
				mode = EDGE;
			}
		}

		if (FlxG.keys.justPressed.UP) {
			switch (mode) {
				case EDGE:
					Align.edge(a, b, UP);
				case CENTER:
					Align.center(a, b, Y);
				case STACK:
					Align.stack(a, b, UP);
			}
		} else if (FlxG.keys.justPressed.DOWN) {
			switch (mode) {
				case EDGE:
					Align.edge(a, b, DOWN);
				case CENTER:
					Align.center(a, b, Y);
				case STACK:
					Align.stack(a, b, DOWN);
			}
		} else if (FlxG.keys.justPressed.LEFT) {
			switch (mode) {
				case EDGE:
					Align.edge(a, b, LEFT);
				case CENTER:
					Align.center(a, b, X);
				case STACK:
					Align.stack(a, b, LEFT);
			}
		} else if (FlxG.keys.justPressed.RIGHT) {
			switch (mode) {
				case EDGE:
					Align.edge(a, b, RIGHT);
				case CENTER:
					Align.center(a, b, X);
				case STACK:
					Align.stack(a, b, RIGHT);
			}
		}

		modeLabel.text = '$mode mode (enter to cycle)';
		modeLabel.screenCenter(X);
	}
}

enum AlignMode {
	EDGE;
	CENTER;
	STACK;
}
