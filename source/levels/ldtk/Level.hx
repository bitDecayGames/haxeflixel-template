package levels.ldtk;

import entities.CameraTransition;
import flixel.math.FlxRect;
import flixel.math.FlxPoint;
import levels.ldtk.Ldtk.LdtkProject;

using levels.ldtk.LdtkUtils;

class Level {
	public var terrainLayer:BDTilemap;
	public var spawnPoint:FlxPoint = FlxPoint.get();

	public var camZones:Map<String, FlxRect>;
	public var camTransitions:Array<CameraTransition>;

	public function new(nameOrIID:String) {
		var project = new LdtkProject();
		var level = project.getLevel(nameOrIID);
		terrainLayer = new BDTilemap();
		terrainLayer.loadLdtk(level.l_Terrain);

		if (level.l_Objects.all_Spawn.length == 0) {
			throw('no spawn found in level ${level}');
		}

		var sp = level.l_Objects.all_Spawn[0];
		spawnPoint.set(sp.pixelX, sp.pixelY);

		var test:Ldtk.Entity_Spawn = null;

		parseCameraZones(level.l_Objects.all_CameraZone);
		parseCameraTransitions(level.l_Objects.all_CameraTransition);
	}

	function parseCameraZones(zoneDefs:Array<Ldtk.Entity_CameraZone>) {
		camZones = new Map<String, FlxRect>();
		for (z in zoneDefs) {
			camZones.set(z.iid, FlxRect.get(z.pixelX, z.pixelY, z.width, z.height));
		}
	}

	function parseCameraTransitions(areaDefs:Array<Ldtk.Entity_CameraTransition>) {
		camTransitions = new Array<CameraTransition>();
		for (def in areaDefs) {
			var transArea = FlxRect.get(def.pixelX, def.pixelY, def.width, def.height);
			var camTrigger = new CameraTransition(transArea);
			for (i in 0...def.f_Directions.length) {
				camTrigger.addGuideTrigger(def.f_Directions[i].toCardinal(), camZones.get(def.f_Zones[i].entityIid));
			}
			camTransitions.push(camTrigger);
		}
	}
}
