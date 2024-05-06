package misc;

class Macros {
	/**
	 * Shorthand for retrieving compiler flag values
	 *
	 * @param key The key to get a defined value for
	 *
	 * @returns The value of the given key. If no value is defined for key, null is returned.
	 */
	public static macro function getDefine(key:String):haxe.macro.Expr {
		return macro $v{haxe.macro.Context.definedValue(key)};
	}

	/**
	 * Shorthand for setting compiler flags
	 *
	 * @param key The key to set a defined value for
	 * @param value The value to set for a defined value
	 */
	public static macro function setDefine(key:String, value:String):haxe.macro.Expr {
		haxe.macro.Compiler.define(key, value);
		return macro null;
	}

	/**
	 * Shorthand for checking if a compiler flag is defined
	 *
	 * @param key The key to check for a  defined value for
	 *
	 * @returns True if the key has a defined value, false otherwise
	 */
	public static macro function isDefined(key:String):haxe.macro.Expr {
		return macro $v{haxe.macro.Context.defined(key)};
	}

	public static macro function getGitCommitShortHash():haxe.macro.Expr.ExprOf<String> {
		#if !display
		try {
			var process = new sys.io.Process('git', ['rev-parse', '--short=10', 'HEAD']);
			if (process.exitCode() != 0) {
				var message = process.stderr.readAll().toString();
				var pos = haxe.macro.Context.currentPos();
				// haxe.macro.Context.error("Cannot execute `git rev-parse HEAD`. " + message, pos);
			}

			// read the output of the process
			var commitHash:String = process.stdout.readLine();

			process.close();

			// Generates a string expression
			return macro $v{commitHash};
		} catch (e) {
			var output = 'Unable to get git hash: ${e}';
			return macro $v{output};
		}
		#else
		// `#if display` is used for code completion. In this case returning an
		// empty string is good enough; We don't want to call git on every hint.
		var commitHash:String = "";
		return macro $v{commitHash};
		#end
	}
}
