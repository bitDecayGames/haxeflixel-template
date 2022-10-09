package states;

import flixel.FlxG;
import flixel.addons.ui.FlxUIState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import haxefmod.flixel.FmodFlxUtilities;
import achievements.Achievements;
import helpers.UiHelpers;

using states.FlxStateExt;

class AchievementsState extends FlxUIState {
	private static var NUM_OF_COLUMNS:Int = 3;
	private static var VERTICAL_SPACING:Float = 100;
	private static var HORIZONTAL_SPACING:Float = 0;
	private static var VERTICAL_OFFSET:Float = 100;

	var _txtTitle:FlxText;
	var _btnDone:FlxButton;

	override public function create():Void {
		super.create();
		Achievements.ACHIEVEMENTS_DISPLAYED = 0;
		bgColor = FlxColor.TRANSPARENT;

		_txtTitle = new FlxText();
		_txtTitle.size = 40;
		_txtTitle.alignment = FlxTextAlign.CENTER;
		_txtTitle.text = "Achievements";
		_txtTitle.setPosition((FlxG.width - _txtTitle.width) / 2, VERTICAL_OFFSET * .5);
		add(_txtTitle);

		// if (!Achievements.ACHIEVEMENT_SCREEN.achieved) {
		// 	add(Achievements.ACHIEVEMENT_SCREEN.toToast(true));
		// }

		addAchievementToasts();

		_btnDone = UiHelpers.createMenuButton("Main Menu", clickMainMenu);
		_btnDone.setPosition(FlxG.width / 2 - _btnDone.width / 2, FlxG.height - _btnDone.height - 40);
		_btnDone.updateHitbox();
		add(_btnDone);
		// restore mouse
		FlxG.mouse.visible = true;
	}

	function clickMainMenu():Void {
		FmodFlxUtilities.TransitionToState(new MainMenuState());
	}

	function addAchievementToasts() {
		var columnWidth:Float = FlxG.width / NUM_OF_COLUMNS;
		var i = 0;
		for (def in Achievements.ALL) {
			var a = def.toToast(false);
			add(a);
			a.setPosition(columnWidth * (i % NUM_OF_COLUMNS) + HORIZONTAL_SPACING, Math.floor(i / NUM_OF_COLUMNS) * VERTICAL_SPACING + VERTICAL_OFFSET);
			i++;
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
