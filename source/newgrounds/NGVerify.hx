package newgrounds;

import achievements.Achievements;
import io.newgrounds.NG;
import io.newgrounds.utils.MedalList;

class NGVerify {
	#if (ngdebug || debug)
	public static function verifyMedals(list:MedalList) {
		for (id in list.keys()) {
			var medal = NG.core.medals[id];
			if (Achievements.ALL.exists(medal.id)) {
				var def = Achievements.ALL.get(medal.id);
				if (def.title != medal.name) {
					trace('!! NG medal and local name do not match: Local:"${def.title}" - NG: "${medal.name}"');
				}
				if (def.description != medal.description) {
					trace('!! NG medal and local description do not match: Local:"${def.description}" - NG: "${medal.description}"');
				}
				if (def.secret != medal.secret) {
					trace('!! NG medal and local secret status do not match: Local:"${def.secret}" - NG: "${medal.secret}"');
				}
			} else {
				trace('medal ${medal.id} "${medal.name}" returned from newgrounds, but no local achievement exists');
			}
		}
	}
	#end
}