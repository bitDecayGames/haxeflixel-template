package states;

import events.gen.Event;
import achievements.GameEvents;
import bitdecay.flixel.debug.tools.draw.DebugDraw;
import bitdecay.flixel.debug.DebugSuite;
import entities.Item;
import flixel.util.FlxColor;
import debug.DebugLayers;
import achievements.Achievements;
import flixel.addons.transition.FlxTransitionableState;
import entities.Player;
import flixel.FlxSprite;
import flixel.FlxG;

// import events.gen.PlayerSpawn;
// import events.gen.TestHello;
using states.FlxStateExt;

class PlayState extends FlxTransitionableState {
	var player:FlxSprite;

	override public function create() {
		super.create();
		// Lifecycle.startup.dispatch();

		FlxG.camera.pixelPerfectRender = true;

		player = new Player();
		add(player);
		GameEvents.fire(new PlayerSpawn(player.x, player.y));

		var item = new Item();
		item.y = 50;
		add(item);

		add(Achievements.ACHIEVEMENT_NAME_HERE.toToast(true, true));

		QuickLog.error('Example error');
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
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
