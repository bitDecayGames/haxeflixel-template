package states;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import haxe.ui.focus.FocusManager;
import haxefmod.flixel.FmodFlxUtilities;
import helpers.UiHelpers;
import misc.FlxTextFactory;
import ui.ReturnToMain;

using extensions.FlxStateExt;

class FailState extends FlxState {
	var menu:ReturnToMain;

	var _txtTitle:FlxText;

	override public function create():Void {
		super.create();
		bgColor = FlxColor.TRANSPARENT;

		_txtTitle = FlxTextFactory.make("Game Over", FlxG.width / 2, FlxG.height / 4, 40, FlxTextAlign.CENTER);

		add(_txtTitle);

		menu = new ReturnToMain(clickMainMenu);
		add(menu);

		FocusManager.instance.focus = menu.mainMenuButton;
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		FmodManager.Update();

		_txtTitle.x = FlxG.width / 2 - _txtTitle.width / 2;
	}

	function clickMainMenu():Void {
		FmodFlxUtilities.TransitionToState(new MainMenuState());
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
