package states;

import achievements.Achievements;
import entities.Item;
import entities.Player;
import events.gen.Event;
import events.EventBus;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;

// import events.gen.PlayerSpawn;
// import events.gen.TestHello;
using states.FlxStateExt;

class PlayState extends FlxTransitionableState {
	var player:FlxSprite;

	override public function create() {
		super.create();
		// Lifecycle.startup.dispatch();

		FlxG.camera.pixelPerfectRender = true;

		Achievements.onAchieve.add(handleAchieve);
		EventBus.subscribe(ClickCount, (c) -> {
			QLog.notice('I got me an event about ${c.count} clicks having happened.');
		});

		player = new Player();
		add(player);
		EventBus.fire(new PlayerSpawn(player.x, player.y));

		var item = new Item();
		item.y = 50;
		add(item);

		QLog.error('Example error');
	}

	function handleAchieve(def:AchievementDef) {
		add(def.toToast(true));
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
