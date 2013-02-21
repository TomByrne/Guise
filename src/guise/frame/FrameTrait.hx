package guise.frame;

#if macro
import haxe.macro.Expr;
import haxe.macro.Context;
#end

class FrameTrait
{
	#if macro
	private static function getName(expr:Expr):String {
		switch(expr.expr) {
			case EConst(c):
				switch(c) {
					case CIdent(s):return s;
					default: // ignore
				}
			default: // ignore
		}
		Context.error("Should pass a method name", Context.currentPos());
		return null;
	}
	#end
	
	private var _bundleMap:Hash<FrameCallBundle>;
	private var _frameCalls:Array<FrameCallBundle>;
	
	public function new(){
		_frameCalls = [];
		_bundleMap = new Hash();
	}
	@:macro public function add(thisE:Expr, call:Expr, ?dependsOn:Expr , ?valid:Expr ):Expr {
		var name:Expr = Context.parse('"'+getName(call)+'"', Context.currentPos());
		return macro $thisE.addFrameCall($name, $call, $dependsOn, $valid);
	}
	
	public function addFrameCall(name:String, call:FrameCall, ?dependsOn:Array < FrameCall > , valid:Bool = true ):Void {
		var depends:Array<FrameCallBundle>;
		if (dependsOn != null) {
			depends = [];
			for (depCall in dependsOn) {
				var bundle:FrameCallBundle = _bundleMap.get(name);
				if (bundle==null) throw "Dependant call has not been registered (call addFrameCall for dependancies first)";
				depends.push(bundle);
			}
		}else {
			depends = null;
		}
		var bundle:FrameCallBundle = { frameCall:call, invalidates:null, dependsOn:depends, valid:valid };
		_bundleMap.set(name, bundle);
		_frameCalls.push(bundle);
		
		if(depends!=null){
			for (depBund in depends) {
				if (depBund.invalidates == null) {
					depBund.invalidates = [bundle];
				}else {
					depBund.invalidates.push(bundle);
				}
			}
		}
	}
	@:macro public function invalidate(thisE:Expr, call:Expr):Expr{
		var name:Expr = Context.parse('"'+getName(call)+'"', Context.currentPos());
		return macro $thisE.invalidateByName($name);
	}
	public function invalidateByName(name:String):Void {
		var bundle = _bundleMap.get(name);
		bundle.valid = false;
		invalidateList(bundle.invalidates);
	}
	private function invalidateList(calls:Null<Array<FrameCallBundle>>):Void {
		if (calls != null) {
			for (invBund in calls) {
				invBund.valid = false;
				invalidateList(invBund.invalidates);
			}
		}
	}
	public function validate():Void {
		for (bund in _frameCalls) {
			if (bund.valid) continue;
			
			if (bund.dependsOn != null) {
				var skip:Bool = false;
				for (depBund in bund.dependsOn) {
					if (!depBund.valid) {
						skip = true;
						break;
					}
				}
				if (skip) {
					continue;
				}
			}
			bund.valid = true;
			if (!bund.frameCall()) {
				/* This looks like a strange way to set valid, but
				 * it allows it to be invalidated as a result 
				 * of it's own frameCall()
				 */
				bund.valid = false;
			}
		}
	}
	
}

typedef FrameCall = Void->Bool;

typedef FrameCallBundle = {
	var valid:Bool;
	var frameCall:FrameCall;
	var invalidates:Null<Array < FrameCallBundle >>;
	var dependsOn:Null<Array < FrameCallBundle >>;
}