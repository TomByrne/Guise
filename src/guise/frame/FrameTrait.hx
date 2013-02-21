package guise.frame;
import composure.traits.AbstractTrait;
import cmtc.ds.hash.ObjectHash;

class FrameTrait
{
	private var _callToBundle:ObjectHash<FrameCall, FrameCallBundle>;
	private var _frameCalls:Array<FrameCallBundle>;

	public function new(){
		_frameCalls = [];
		_callToBundle = new ObjectHash();
	}
	
	public function addFrameCall(call:FrameCall, ?dependsOn:Array < FrameCall > , valid:Bool = true ):Void {
		var depends:Array<FrameCallBundle>;
		if (dependsOn != null) {
			depends = [];
			for (depCall in dependsOn) {
				var bundle:FrameCallBundle = _callToBundle.get(depCall);
				if (bundle==null) throw "Dependant call has not been registered (call addFrameCall for dependancies first)";
				depends.push(bundle);
			}
		}else {
			depends = null;
		}
		var bundle:FrameCallBundle = { frameCall:call, invalidates:null, dependsOn:depends, valid:valid };
		_callToBundle.set(call, bundle);
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
	public function invalidate(call:FrameCall):Void {
		var bundle = _callToBundle.get(call);
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