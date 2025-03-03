package states;

import flixel.FlxG;
import flixel.addons.transition.FlxTransitionableState;
import flixel.text.FlxText.FlxTextAlign;
import flixel.text.FlxBitmapText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import haxefmod.flixel.FmodFlxUtilities;
import misc.FlxTextFactory;
import ui.MenuBuilder;

using states.FlxStateExt;

class FailState extends FlxTransitionableState {
	var _btnDone:FlxButton;

	var _txtTitle:FlxBitmapText;

	override public function create():Void {
		super.create();
		bgColor = FlxColor.TRANSPARENT;

		_txtTitle = FlxTextFactory.make("Game Over", FlxG.width / 2, FlxG.height / 4, 40, FlxTextAlign.CENTER);

		add(_txtTitle);

		_btnDone = MenuBuilder.createTextButton("Main Menu", clickMainMenu);
		_btnDone.setPosition(FlxG.width / 2 - _btnDone.width / 2, FlxG.height - _btnDone.height - 40);
		_btnDone.updateHitbox();
		add(_btnDone);
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
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
