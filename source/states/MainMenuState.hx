package states;

import config.Configure;
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

		FlxG.log.notice("systemMouse: " + FlxG.mouse.useSystemCursor);
		FlxG.log.notice("cursor visible: " + FlxG.mouse.visible);

		_xml_id = "main_menu";

		if (Configure.get().menus.keyboardNavigation || Configure.get().menus.controllerNavigation) {
			_makeCursor = true;
		}

		super.create();

		if (_makeCursor) {
			cursor.loadGraphic(AssetPaths.pointer__png, true, 32, 32);
			cursor.animation.add("pointing", [0, 1], 3);
			cursor.animation.play("pointing");

			var keys:Int = 0;
			if (Configure.get().menus.keyboardNavigation) {
				keys |= FlxUICursor.KEYS_ARROWS | FlxUICursor.KEYS_WASD;
			}
			if (Configure.get().menus.controllerNavigation) {
				keys |= FlxUICursor.GAMEPAD_DPAD;
			}
			cursor.setDefaultKeys(keys);
		}

		FmodManager.PlaySong(FmodSongs.LetsGo);
		FlxG.log.notice("loaded scene");
		bgColor = FlxColor.TRANSPARENT;
		FlxG.camera.pixelPerfectRender = true;

		#if !windows
		// Hide exit button for non-windows targets
		var test = _ui.getAsset("exit_button");
		test.visible = false;
		#end
	}

	override public function getEvent(name:String, sender:Dynamic, data:Dynamic, ?params:Array<Dynamic>):Void {
		if (name == FlxUITypedButton.CLICK_EVENT) {
			var button_action:String = params[0];
			trace('Action: "${button_action}"');

			if (button_action == "play") {
				clickPlay();
			}

			if (button_action == "credits") {
				clickCredits();
			}

			#if windows
			if (button_action == "exit") {
				clickExit();
			}
			#end
		}
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		FmodManager.Update();
		FlxG.watch.addQuick("systemMouse: ", FlxG.mouse.useSystemCursor);
		FlxG.watch.addQuick("cursor visible: ", FlxG.mouse.visible);
	}

	function clickPlay():Void {
		FmodFlxUtilities.TransitionToStateAndStopMusic(new VictoryState());
	}

	function clickCredits():Void {
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
