package states;

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

		var item = new Item();
		item.y = 50;
		add(item);

		add(Achievements.ACHIEVEMENT_NAME_HERE.toToast(true, true));

		// GameEvents.fire(new PlayerSpawn(515.2, 123.4));

		QuickLog.error('Example error');
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);

		// if (FlxG.keys.justPressed.J) {
		// 	GameEvents.fire(PLAYER_MOVE(START_FALL(FlxG.mouse.y)));
		// }
		// if (FlxG.keys.justPressed.L) {
		// 	GameEvents.fire(PLAYER_MOVE(LAND(FlxG.mouse.y)));
		// }
		// if (FlxG.keys.justPressed.E) {
		// 	GameEvents.fire(PLAYER_DIED(ENEMY('grungus')));
		// }
		// if (FlxG.keys.justPressed.T) {
		// 	GameEvents.fire(PLAYER_DIED(TRAP('booby')));
		// }

		// GameEvents.fire(new events)

		// var cam = FlxG.camera;
		// DebugSuite.tool(DebugDraw, (t) -> {
		// 	t.drawCameraRect(cam.getCenterPoint().x - 5, cam.getCenterPoint().y - 5, 10, 10, DebugLayers.RAYCAST, FlxColor.RED);
		// });

		// GameEvents.fire(new TestHello());
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
