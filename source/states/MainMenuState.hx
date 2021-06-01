package states;

import config.Configure;
import input.SimpleController;
import ui.MenuCursor;
import haxe.ui.core.Component;
import haxe.ui.focus.FocusManager;
import flixel.FlxSprite;
import ui.MainMenu;
import flixel.FlxState;
import haxe.ui.Toolkit;
import states.transitions.Trans;
import states.transitions.SwirlTransition;
import com.bitdecay.analytics.Bitlytics;
import flixel.FlxG;
import flixel.util.FlxColor;
import haxefmod.flixel.FmodFlxUtilities;

using extensions.FlxStateExt;
using extensions.FlxObjectExt;
using ui.ComponentExt;

#if windows
import lime.system.System;
#end

class MainMenuState extends FlxState {

	var cursor:FlxSprite;
	var menuFocus:Component;

	override public function create():Void {
		super.create();

		var bgImage = new FlxSprite(AssetPaths.title_image__png);
		add(bgImage);

		cursor = new MenuCursor();

		if (Configure.config.menus.controllerNavigation ||
			Configure.config.menus.keyboardNavigation) {
			add(cursor);
		} else {
			cursor.visible = false;
		}

		Toolkit.init({container: this});
		var menu = new MainMenu(clickPlay, clickCredits);
		add(menu);

		FocusManager.instance.pushView(menu.menuItems);
		menuFocus = FocusManager.instance.focusNext();

		FmodManager.PlaySong(FmodSongs.LetsGo);
		bgColor = FlxColor.TRANSPARENT;
		FlxG.camera.pixelPerfectRender = true;

		#if !windows
		menu.quitButton.visible = false;
		#else
		menu.quitButton.onClick = _ -> {
			System.exit(0);
		};
		#end

		// Trigger our focus logic as we are just creating the scene
		this.handleFocus();
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		FmodManager.Update();

		if (SimpleController.just_pressed(Button.UP)) {
			menuFocus = FocusManager.instance.focusPrev();
			while(!menuFocus.visible) {
				menuFocus = FocusManager.instance.focusPrev();
			}
		}

		if (SimpleController.just_pressed(Button.DOWN)) {
			menuFocus = FocusManager.instance.focusNext();
			while(!menuFocus.visible) {
				menuFocus = FocusManager.instance.focusNext();
			}
		}

		// TODO: This positioning could be better
		cursor.setPositionPoint(menuFocus.recursivePosition());
		cursor.y -= 8;
		cursor.x -= 40;

		if (FlxG.keys.pressed.D && FlxG.keys.justPressed.M) {
			// Keys D.M. for Disable Metrics
			Bitlytics.Instance().EndSession(false);
			FmodManager.PlaySoundOneShot(FmodSFX.MenuSelect);
			trace("---------- Bitlytics Stopped ----------");
		}
	}

	function clickPlay():Void {
		FmodManager.StopSong();
		FmodManager.PlaySoundOneShot(FmodSFX.MenuSelect);
		var swirlOut = new SwirlTransition(Trans.OUT, () -> {
			// make sure our music is stopped;
			FmodManager.StopSongImmediately();
			FlxG.switchState(new PlayState());
		}, FlxColor.GRAY);
		openSubState(swirlOut);
	}

	function clickCredits():Void {
		FmodManager.PlaySoundOneShot(FmodSFX.MenuSelect);
		FmodFlxUtilities.TransitionToState(new CreditsState());
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
