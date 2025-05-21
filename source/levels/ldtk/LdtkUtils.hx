package levels.ldtk;

import bitdecay.flixel.spacial.Cardinal;

/**
 * A general utility class to help with parsing things out of our LTDK project
**/
class LdtkUtils {
	public static function toCardinal(d:Ldtk.Enum_Direction):Cardinal {
		switch d {
			case EAST:
				return Cardinal.E;
			case WEST:
				return Cardinal.W;
			case NORTH:
				return Cardinal.N;
			case SOUTH:
				return Cardinal.S;
		}
	}
}
