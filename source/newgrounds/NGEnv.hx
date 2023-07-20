package newgrounds;

import misc.Macros;

class NGEnv {
	public static function getNGAppID():String {
		if (Macros.isDefined("NG_APP_ID")) {
			var define = Macros.getDefine("NG_APP_ID");
			// our define comes back as <val>=<val>
			// Take the first half explicitly, as splitting on '=' might have unexpected
			// behavior if the token has '=' characters in it
			return define.substr(0, Std.int(define.length / 2));
		} else {
			#if debug
			trace('no NG_APP_ID found');
			#end
			return "";
		}
	}

	public static function getNGEncryptKey():String {
		if (Macros.isDefined("NG_ENCRYPTION_KEY")) {
			var define = Macros.getDefine("NG_ENCRYPTION_KEY");
			// our define comes back as <val>=<val>
			// Take the first half explicitly, as splitting on '=' might have unexpected
			// behavior if the token has '=' characters in it
			return define.substr(0, Std.int(define.length / 2));
		} else {
			#if debug
			trace('no NG_ENCRYPT_KEY found');
			#end
			return "";
		}
	}
}