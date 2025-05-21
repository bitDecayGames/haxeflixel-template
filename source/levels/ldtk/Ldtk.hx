package levels.ldtk;

/**
 * Uses the macro magic to load our world.ldtk into compile-time data we can use
 * and get auto-complete on
**/
private typedef _Tmp = haxe.macro.MacroType<[ldtk.Project.build("assets/world.ldtk")]>;

@:forward
abstract LdtkProject(Ldtk) to Ldtk {
	public function new() {
		this = new Ldtk();
	}

	public inline extern overload function getWorldOf(levelId:String)
		return getWorldByLevelId(levelId);

	public inline extern overload function getWorldOf(levelUid:Int)
		return getWorldByLevelUid(levelUid);

	function getWorldByLevelId(levelId:String):Null<Ldtk_World> {
		for (world in this.worlds) {
			final level = world.getLevel(levelId);
			if (level != null)
				return world;
		}
		return null;
	}

	function getWorldByLevelUid(levelUid:Int):Null<Ldtk_World> {
		for (world in this.worlds) {
			final level = world.getLevel(levelUid);
			if (level != null)
				return world;
		}
		return null;
	}

	public inline extern overload function getLevel(worldId:String, levelId:String)
		return getLevelById(worldId, levelId);

	public inline extern overload function getLevel(worldId:String, levelUid:Int)
		return getLevelByUid(worldId, levelUid);

	public inline extern overload function getLevel(levelId:String)
		return getLevelById(null, levelId);

	public inline extern overload function getLevel(levelUid:Int)
		return getLevelByUid(null, levelUid);

	function getLevelById(?worldId:String, levelId:String):Null<Ldtk_Level> {
		if (worldId == null) {
			for (world in this.worlds) {
				final level = world.getLevel(levelId);
				if (level != null)
					return level;
			}
			return null;
		}

		return this.getWorld(worldId).getLevel(levelId);
	}

	function getLevelByUid(?worldId:String, levelUid:Int):Null<Ldtk_Level> {
		if (worldId == null) {
			for (world in this.worlds) {
				final level = world.getLevel(levelUid);
				if (level != null)
					return level;
			}
			return null;
		}

		return this.getWorld(worldId).getLevel(levelUid);
	}
}
