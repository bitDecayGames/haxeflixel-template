package states;

import levels.ldtk.Ldtk.LdtkProject;
import levels.ldtk.LdtkTilemap;
import levels.ldtk.BDTilemap;
import achievements.Achievements;
import entities.Item;
import entities.Player;
import events.gen.Event;
import events.EventBus;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;

using states.FlxStateExt;

class PlayState extends FlxTransitionableState {
	var player:FlxSprite;

	var ldtk = new LdtkProject();
	var terrainLayer:BDTilemap;

	override public function create() {
		super.create();

		FlxG.camera.pixelPerfectRender = true;

		Achievements.onAchieve.add(handleAchieve);
		EventBus.subscribe(ClickCount, (c) -> {
			QLog.notice('I got me an event about ${c.count} clicks having happened.');
		});

		QLog.error('Example error');

		loadLevel("Level_0");
	}

	function loadLevel(level:String) {
		var level = ldtk.getLevel(null, level);
		terrainLayer = new BDTilemap();
		terrainLayer.loadLdtk(level.l_Terrain);
		add(terrainLayer);

		if (level.l_Objects.all_Spawn.length == 0) {
			throw('no spawn found in level ${level}');
		}

		var spawnPoint = level.l_Objects.all_Spawn[0];

		player = new Player();
		player.setPosition(spawnPoint.pixelX, spawnPoint.pixelY);
		add(player);
		EventBus.fire(new PlayerSpawn(player.x, player.y));
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
