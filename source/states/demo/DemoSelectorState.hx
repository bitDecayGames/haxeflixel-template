package states.demo;

import flixel.text.FlxText.FlxTextBorderStyle;
import ui.BaseHeaderWindow;
import flixel.util.FlxColor;
import ui.Styles;
import ui.ItemScrollWindow;
import flixel.FlxG;
import ui.MenuBuilder;
import flixel.FlxState;

/**
 * A state to allow quickly jumping between different demos of available features within this template
**/
class DemoSelectorState extends FlxState {
	override function create() {
		super.create();

		var selectorWindow = new ItemScrollWindow(50, 50, FlxG.width - 100, FlxG.height - 100, Styles.windows.basic_0, Styles.windows.rabbitBG_0);
		selectorWindow.withLayout(Vertical(10));
		selectorWindow.padding = 10;
		selectorWindow.bg.color = FlxColor.GRAY.getDarkened(.5);
		selectorWindow.addItem(MenuBuilder.createTextButton("UI Windows", () -> FlxG.switchState(UIDemoState.new)));

		var headerWindow = new BaseHeaderWindow(50, 50, "Demo Selector", selectorWindow, Styles.windows.basic_0, Styles.windows.rabbitBG_0);
		headerWindow.header.bg.color = FlxColor.GRAY.getDarkened(.5);
		headerWindow.headerText.borderStyle = FlxTextBorderStyle.OUTLINE;
		add(headerWindow);
	}
}
