package states.test;

import flixel.FlxState;
import ui.Styles;
import flixel.tweens.FlxEase;
import ui.ItemScrollWindow;
import flixel.util.FlxColor;
import flixel.math.FlxPoint;
import ui.BaseHeaderWindow;
import flixel.FlxG;
import flixel.FlxSprite;

using states.FlxStateExt;

class UITestState extends FlxState {
	// var testWindow:BaseHeaderWindow;
	var testGridWindow:BaseHeaderWindow;
	var testNoLayoutWindow:BaseHeaderWindow;

	var testWindow:ItemScrollWindow;

	override public function create() {
		super.create();

		testWindow = new ItemScrollWindow(50, 50, 100, 100, Styles.windows.basic_0, Styles.windows.rabbitBG_0);
		// testWindow.bg.setScrollSpeed(FlxPoint.weak(-5, 0), 50);
		// testWindow.bg.color = FlxColor.GRAY.getDarkened(.7);
		testWindow.bg.setScrollSpeed(FlxPoint.weak(5, 0), 50);
		testWindow.bg.color = FlxColor.GRAY.getDarkened(.7);
		testWindow.withLayout(Vertical(10));
		testWindow.padding = 5;
		testWindow.style.ease = FlxEase.bounceOut;
		add(testWindow);

		for (i in 0...6) {
			var spr = new FlxSprite(0, 0);
			spr.makeGraphic(FlxG.random.int(10, 20), FlxG.random.int(10, 20));
			testWindow.addItem(spr);
		}

		testGridWindow = new BaseHeaderWindow("Test Grid", 200, 50, 100, 100, Styles.windows.basic_0, Styles.windows.rabbitBG_0);
		testGridWindow.header.bg.setScrollSpeed(FlxPoint.weak(-5, 0), 50);
		testGridWindow.header.bg.color = FlxColor.GRAY.getDarkened(.7);
		testGridWindow.content.bg.setScrollSpeed(FlxPoint.weak(5, 0), 50);
		testGridWindow.content.bg.color = FlxColor.GRAY.getDarkened(.7);
		testGridWindow.content.withLayout(Grid(3, 3, 5, 5));
		testGridWindow.content.padding = 5;
		add(testGridWindow);

		var spr = new FlxSprite(0, 0);
		spr.makeGraphic(FlxG.random.int(10, 20), FlxG.random.int(10, 20));
		testGridWindow.content.addItem(spr, {col: 0, row: 0});

		spr = new FlxSprite(0, 0);
		spr.makeGraphic(FlxG.random.int(10, 20), FlxG.random.int(10, 20));
		testGridWindow.content.addItem(spr, {col: 1, row: 0});

		spr = new FlxSprite(0, 0);
		spr.makeGraphic(FlxG.random.int(10, 20), FlxG.random.int(10, 20));
		testGridWindow.content.addItem(spr, {col: 2, row: 0});

		spr = new FlxSprite(0, 0);
		spr.makeGraphic(FlxG.random.int(10, 20), FlxG.random.int(10, 20));
		testGridWindow.content.addItem(spr, {col: 2, row: 1});

		spr = new FlxSprite(0, 0);
		spr.makeGraphic(FlxG.random.int(10, 20), FlxG.random.int(10, 20));
		testGridWindow.content.addItem(spr, {col: 2, row: 2});

		testNoLayoutWindow = new BaseHeaderWindow("Test None", 150, 100, 100, 100, Styles.windows.basic_0, Styles.windows.rabbitBG_0);
		add(testNoLayoutWindow);

		spr = new FlxSprite(0, 0);
		spr.makeGraphic(FlxG.random.int(10, 20), FlxG.random.int(10, 20));
		testNoLayoutWindow.content.addItem(spr);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);

		if (FlxG.mouse.pressed) {
			testGridWindow.x += FlxG.mouse.deltaX;
			testGridWindow.y += FlxG.mouse.deltaY;
		}

		if (FlxG.keys.pressed.U) {
			testWindow.scrollUp();
		} else if (FlxG.keys.pressed.J) {
			testWindow.scrollDown();
		}
	}
}
