package guise;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
#end

class Macro 
{
	@:macro public static function val(e:Expr):Expr {
		return interpValue(e);
	}
	#if macro
	public static function interpValue(e:Expr):Expr {
		switch(e.expr) {
			case EField(e1, field):
				var firstChar:String = field.charAt(0);
				if (firstChar == firstChar.toUpperCase()) {
					// this is for directly instantiating an IValue object
					return Context.parse("new " + getClassPath(e) + "()", Context.currentPos());
				}else if (getClassPath(e1) != null) {
					// this is for the Class.prop notation (i.e. wrapping in a Bind object)
					var fieldE:Expr = Context.parse('"' + field + '"', Context.currentPos());
					return macro new guise.values.Bind($e1, $fieldE);
				}
			case EConst(c):
				// This wraps raw numbers and variables in Value objects
				return macro new guise.values.Value($e);
			case EBinop(op, e1, e2):
				// This wraps mathemathical expressions in Calc objects
				e1 = interpValue(e1);
				e2 = interpValue(e2);
				switch(op) {
					case OpAdd:
						return macro new guise.values.Calc(guise.values.Calc.Operator.Add, [$e1, $e2]);
					case OpSub:
						return macro new guise.values.Calc(guise.values.Calc.Operator.Subtract, [$e1, $e2]);
					case OpDiv:
						return macro new guise.values.Calc(guise.values.Calc.Operator.Divide, [$e1, $e2]);
					case OpMult:
						return macro new guise.values.Calc(guise.values.Calc.Operator.Multiply, [$e1, $e2]);
					case OpLt:
						return macro new guise.values.Calc(guise.values.Calc.Operator.Min, [$e1, $e2]);
					case OpGt:
						return macro new guise.values.Calc(guise.values.Calc.Operator.Max, [$e1, $e2]);
					default:
						Context.error("Unsupported operator: " + op, Context.currentPos());
				}
			case EUnop( op, postFix, e ):
				// This wraps mathemathical expressions in Calc objects
				e = interpValue(e);
				switch(op) {
					case OpNeg:
						return macro new guise.values.Calc(guise.values.Calc.Operator.Subtract, [new guise.values.Value(0),$e]);
					case OpIncrement:
					case OpDecrement:
					case OpNot:
					case OpNegBits:
						Context.error("Unsupported operator: " + op, Context.currentPos());
				}
			case EParenthesis(e1):
				return { expr:EParenthesis(interpValue(e1)), pos:e.pos};
			case ECall(e1, params):
				// this is for the Class.prop(signal) notation
				var signal;
				if (params.length == 1 && (signal = getIdent(params[0]))!=null) {
					switch(e1.expr) {
						case EField(e2, field):
							var firstChar:String = field.charAt(0);
							if (firstChar == firstChar.toLowerCase()) {
								var fieldE:Expr = Context.parse('"' + field + '"', Context.currentPos());
								var signalE:Expr = Context.parse('"' + signal + '"', Context.currentPos());
								return macro new guise.values.Bind($e2, $fieldE, $signalE);
							}
						default: // ignore
					}
				}
			default: // ignore
				trace(e);
		}
		return e;
	}
	
	private static function getIdent(e:Expr):String {
		switch(e.expr) {
			case EConst(c):
				switch(c) {
					case CIdent(s), CString(s):
						return s;
					default: // ignore
				}
			default: // ignore
		}
		return null;
	}
	private static function getClassPath(e:Expr):String {
		var ret:String;
		while (true) {
			switch(e.expr) {
				case EConst(c):
					switch(c) {
						case CIdent(i):
							if (ret != null) {
								return i + "." + ret;
							}else {
								return i;
							}
						default: return null;
					}
				case EField(e1, field):
					if (ret != null) {
						ret = field + "." + ret;
					}else {
						var firstChar = field.charAt(0);
						if (firstChar != firstChar.toUpperCase()) {
							return null;
						}
						ret = field;
					}
					e = e1;
				default: return null;
			}
		}
		return null;
	}
	#end
}