package states;

import events.gen.Event;
import events.EventBus;
import entities.Item;
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

		EventBus.subscribe(ClickCount, (c) -> {
			QLog.notice('I got me an event about ${c.count} clicks having happened.');
		});

		player = new Player();
		add(player);
		EventBus.fire(new PlayerSpawn(player.x, player.y));

		var item = new Item();
		item.y = 50;
		add(item);

		add(Achievements.ACHIEVEMENT_NAME_HERE.toToast(true, true));

		QLog.error('Example error');
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);

		if (FlxG.mouse.justPressed) {
			EventBus.fire(new Click(FlxG.mouse.x, FlxG.mouse.y));
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
