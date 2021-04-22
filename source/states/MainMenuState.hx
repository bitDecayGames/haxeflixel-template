package states;

import flixel.FlxSprite;
import ui.MainMenu;
import flixel.FlxState;
import haxe.ui.Toolkit;
import states.transitions.Trans;
import states.transitions.SwirlTransition;
import com.bitdecay.analytics.Bitlytics;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import haxefmod.flixel.FmodFlxUtilities;

using extensions.FlxStateExt;

#if windows
import lime.system.System;
#end

class MainMenuState extends FlxState {
	override public function create():Void {
		super.create();

		var bgImage = new FlxSprite(AssetPaths.title_image__png);
		add(bgImage);

		Toolkit.init({container: this});
		var menu = new MainMenu(clickPlay, clickCredits);
		add(menu);

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

		if (FlxG.keys.pressed.D && FlxG.keys.justPressed.M) {
			// Keys D.M. for Disable Metrics
			Bitlytics.Instance().EndSession(false);
			FmodManager.PlaySoundOneShot(FmodSFX.MenuSelect);
			trace("---------- Bitlytics Stopped ----------");
		}
	}

	function clickPlay():Void {
		FmodManager.StopSong();
		var swirlOut = new SwirlTransition(Trans.OUT, () -> {
			// make sure our music is stopped;
			FmodManager.StopSongImmediately();
			FlxG.switchState(new PlayState());
		}, FlxColor.GRAY);
		openSubState(swirlOut);
	}

	function clickCredits():Void {
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
