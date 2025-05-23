package states;

import ui.MenuBuilder;
import com.bitdecay.analytics.Bitlytics;
import bitdecay.flixel.transitions.SwirlTransition;
import bitdecay.flixel.transitions.TransitionDirection;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.util.FlxSpriteUtil;
import haxefmod.flixel.FmodFlxUtilities;
import input.SimpleController;
import states.AchievementsState;

using states.FlxStateExt;

class MainMenuState extends FlxTransitionableState {
	var startButton:FlxButton;
	var handleInput = true;

	override public function create():Void {
		super.create();
		bgColor = FlxColor.TRANSPARENT;
		FlxG.camera.pixelPerfectRender = true;

		var bgImage = new FlxSprite(AssetPaths.title__png);
		bgImage.scale.set(camera.width / bgImage.width, camera.height / bgImage.height);
		bgImage.screenCenter();
		add(bgImage);

		// This can be swapped out for an image instead
		startButton = MenuBuilder.createTextButton("Play", clickPlay, MenuSelect, MenuHover);
		startButton.screenCenter(X);
		startButton.y = FlxG.height * .6;
		add(startButton);

		FmodPlugin.playSong(FmodSong.LetsGo);

		// we will handle transitions manually
		transOut = null;
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);

		if (FlxG.keys.pressed.D && FlxG.keys.justPressed.M) {
			// Keys D.M. for Disable Metrics
			Bitlytics.Instance().EndSession(false);
			FmodPlugin.playSFX(FmodSFX.MenuSelect);
			trace("---------- Bitlytics Stopped ----------");
		}

		if (handleInput && SimpleController.just_pressed(START)) {
			handleInput = false;
			FlxSpriteUtil.flicker(startButton, 0, 0.25);
			new FlxTimer().start(1, (t) -> {
				clickPlay();
			});
		}
	}

	function clickPlay():Void {
		FmodManager.StopSong();
		var swirlOut = new SwirlTransition(TransitionDirection.OUT, () -> {
			// make sure our music is stopped;
			FmodManager.StopSongImmediately();
			FlxG.switchState(() -> {
				new PlayState();
			});
		}, FlxColor.GRAY, 0.75);
		openSubState(swirlOut);
	}

	// If we want to add a way to go to credits from main menu, call this
	function clickCredits():Void {
		FmodFlxUtilities.TransitionToState(new CreditsState());
	}

	// If we want to add a way to go to achievements from main menu, call this
	function clickAchievements():Void {
		FmodFlxUtilities.TransitionToState(new AchievementsState());
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
