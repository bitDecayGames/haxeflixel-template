package states;

import flixel.addons.ui.FlxUITypedButton;
import flixel.addons.ui.FlxUIButton;
import flixel.addons.ui.FlxUICheckBox;
import flixel.addons.ui.FlxUI;
import flixel.addons.ui.FlxUICursor;
import haxefmod.flixel.FmodFlxUtilities;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.addons.ui.FlxUIState;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import helpers.UiHelpers;
import misc.FlxTextFactory;
#if windows
import lime.system.System;
#end

using extensions.FlxStateExt;

class MainMenuState extends FlxUIState {
	var _btnPlay:FlxButton;
	var _btnCredits:FlxButton;
	var _btnExit:FlxButton;

	var _txtTitle:FlxText;

	override public function create():Void {
		_xml_id = "main_menu";
		_makeCursor = true;
		super.create();

		cursor.loadGraphic(AssetPaths.pointer__png, true, 32, 32);
		cursor.animation.add("pointing", [0, 1], 3);
		cursor.animation.play("pointing");

		// Allow menu control with various control methods
		cursor.setDefaultKeys(FlxUICursor.KEYS_ARROWS | FlxUICursor.KEYS_WASD | FlxUICursor.GAMEPAD_DPAD);

		FmodManager.PlaySong(FmodSongs.LetsGo);
		FlxG.log.notice("loaded scene");
		bgColor = FlxColor.TRANSPARENT;
		FlxG.camera.pixelPerfectRender = true;

		// TODO: Still need to rig up the actual behavior here

		// _btnPlay = UiHelpers.createMenuButton("Play", clickPlay);
		// _btnPlay.setPosition(FlxG.width / 2 - _btnPlay.width / 2, FlxG.height - _btnPlay.height - 100);
		// _btnPlay.updateHitbox();
		// add(_btnPlay);

		// _btnCredits = UiHelpers.createMenuButton("Credits", clickCredits);
		// _btnCredits.setPosition(FlxG.width / 2 - _btnCredits.width / 2, FlxG.height - _btnCredits.height - 70);
		// _btnCredits.updateHitbox();
		// add(_btnCredits);

		// #if windows
		// _btnExit = UiHelpers.createMenuButton("Exit", clickExit);
		// _btnExit.setPosition(FlxG.width / 2 - _btnExit.width / 2, FlxG.height - _btnExit.height - 40);
		// _btnExit.updateHitbox();
		// add(_btnExit);
		// #end
	}

	override public function getEvent(name:String, sender:Dynamic, data:Dynamic, ?params:Array<Dynamic>):Void {
		if (name == FlxUITypedButton.CLICK_EVENT) {
			trace("click!");
			var button_action:String = params[0];
			trace('Action: "${button_action}"');

			if (button_action == "play") {
				clickPlay();
			}

			if (button_action == "credits") {
				clickCredits();
			}
		}
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		FmodManager.Update();
	}

	function clickPlay():Void {
		trace("playing");
		FmodFlxUtilities.TransitionToStateAndStopMusic(new VictoryState());
	}

	function clickCredits():Void {
		trace("crediting");
		FmodFlxUtilities.TransitionToState(new CreditsState());
	}

	#if windows
	function clickExit():Void {
		System.exit(0);
	}
	#end

	override public function onFocusLost() {
		super.onFocusLost();
		this.handleFocusLost();
	}

	override public function onFocus() {
		super.onFocus();
		this.handleFocus();
	}
}
