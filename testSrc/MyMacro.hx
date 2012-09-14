package ;

import haxe.macro.Expr;
import haxe.macro.Type;
import haxe.macro.Context;


class MyMacro
{

	@:macro public static function inject() : Array<Field> {
		var type:Type = Context.getLocalType();
		switch(type) {
			case TInst( t , params ):
				t.get();
			default:
		}
        return Context.getBuildFields();
    }
}