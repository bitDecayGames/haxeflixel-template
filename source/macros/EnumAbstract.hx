package macros;

import haxe.macro.Expr;
import haxe.macro.Context;

using haxe.macro.Tools;

class EnumAbstract {
	public static macro function list(e:Expr) {
		return macro $a{
			getFields(e).map(function(s) {
				var name = s.name;
				return macro $e.$name;
			})
		}
	}

	public static macro function count(e:Expr) {
		return macro $v{getFields(e).length}
	}

	#if macro
	public static function getFields(e:Expr) {
		return switch Context.follow(Context.getType(e.toString())) {
			case TAbstract(_.get() => {meta: meta, impl: impl}, _) if (meta.has(':enum')):
				impl.get().statics.get().filter(function(s) return s.meta.has(':enum') && s.meta.has(':impl'));
			default:
				Context.error('Only applicable to @:enum abstract', e.pos);
		}
	}
	#end
}
