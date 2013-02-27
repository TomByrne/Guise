package guise.platform.nme.accessTypes;
import composure.traits.AbstractTrait;
import guise.accessTypes.IKeyboardAccess;
import guise.platform.nme.display.DisplayTrait;
import nme.display.InteractiveObject;
import nme.events.KeyboardEvent;
import msignal.Signal;
import guise.accessTypes.IMouseInteractionsAccess;


class KeyboardAccess implements IKeyboardAccess
{
	@inject
	@:isVar public var displayTrait(default, set):DisplayTrait;
	private function set_displayTrait(value:DisplayTrait):DisplayTrait {
		if (displayTrait!=null) {
			if (displayTrait.displayObject == interactiveObject) {
				interactiveObject = null;
			}
		}
		displayTrait = value;
		if (displayTrait != null) {
			if (interactiveObject==null && Std.is(displayTrait.displayObject, InteractiveObject)) {
				interactiveObject = cast displayTrait.displayObject;
			}
		}
		return value;
	}
	
	@:isVar public var interactiveObject(default, set):InteractiveObject;
	private function set_interactiveObject(value:InteractiveObject):InteractiveObject {
		if (interactiveObject!=null) {
			interactiveObject.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			interactiveObject.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			_isDown = new Map();
		}
		interactiveObject = value;
		if (interactiveObject!=null) {
			interactiveObject.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			interactiveObject.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}
		return value;
	}
	
	private var _upSignals:Map<String, Signal2<IKeyboardAccess,KeyInfo>>;
	private var _downSignals:Map<String, Signal2<IKeyboardAccess,KeyInfo>>;
	private var _keyInfos:Map<String, KeyInfo>;
	private var _isDown:Map<String, Bool>;
	

	@:isVar public var layerName(default, set):String;
	private function set_layerName(value:String):String {
		this.layerName = value;
		return value;
	}
	
	public function new(?layerName:String, ?interactiveObject:InteractiveObject) 
	{
		
		this.interactiveObject = interactiveObject;
		
		this.layerName = layerName;
		
		_upSignals = new Map();
		_downSignals = new Map();
		_keyInfos = new Map();
		_isDown = new Map();
	}
	
	private function onKeyUp(e:KeyboardEvent):Void {
		dispatchSignals(e.keyCode, e.charCode, e.ctrlKey, e.altKey, e.shiftKey, _upSignals, false);
	}
	
	private function onKeyDown(e:KeyboardEvent):Void {
		if (_isDown.get("k_"+e.keyCode) == true) return; // will filter out held keys.
		dispatchSignals(e.keyCode, e.charCode, e.ctrlKey, e.altKey, e.shiftKey, _downSignals, true);
	}
	
	private function dispatchSignals(keyCode:Int, charCode:Int, ctrl:Bool, alt:Bool, shift:Bool, signals:Map<String, Signal2<IKeyboardAccess,KeyInfo>>, isDown:Bool):Void {
		var modStrs:Array<String> = [""];
		if (ctrl) {
			modStrs.push(":ctrl_");
			if (alt) {
				modStrs.push(":ctrl_alt_");
				if (shift) {
					modStrs.push(":ctrl_alt_shift");
				}
			}
		}
		if (alt) {
			modStrs.push(":alt_");
			if (shift) {
				modStrs.push(":alt_shift");
			}
		}
		if (shift) {
			modStrs.push(":shift");
		}
		for (modStr in modStrs) {
			var kStr:String = "k_" + keyCode + modStr;
			var cStr:String = "c_" + charCode + modStr;
			
			dispatchFrom(kStr, signals);
			dispatchFrom(cStr, signals);
			_isDown.set(kStr, isDown);
			_isDown.set(cStr, isDown);
		}
	}
	public function dispatchFrom(key:String, signals:Map<String, Signal2<IKeyboardAccess,KeyInfo>>):Void {
		var signal = signals.get(key);
		if (signal != null) {
			signal.dispatch(this, _keyInfos.get(key));
		}
	}
	
	public function keyUp(keyInfo:KeyInfo):Signal2<IKeyboardAccess,KeyInfo> {
		return getSignal(keyInfo, _upSignals);
	}
	public function keyDown(keyInfo:KeyInfo):Signal2 < IKeyboardAccess, KeyInfo > {
		return getSignal(keyInfo, _downSignals);
	}
	public function getSignal(keyInfo:KeyInfo, from:Map<String, Signal2<IKeyboardAccess,KeyInfo>>):Signal2<IKeyboardAccess,KeyInfo> {
		var key:String = getKey(keyInfo);
		var ret:Signal2<IKeyboardAccess,KeyInfo> = from.get(key);
		if (ret == null) {
			ret = new Signal2<IKeyboardAccess,KeyInfo>();
			_keyInfos.set(key, keyInfo);
			from.set(key, ret);
		}
		return ret;
	}
	
	public function isDown(keyInfo:KeyInfo):Bool {
		var key:String = getKey(keyInfo);
		if (_isDown.exists(key)) {
			return _isDown.get(key);
		}else {
			return false;
		}
	}
	
	private function getKey(keyInfo:KeyInfo):String {
		switch(keyInfo) {
			case Key(keyCode, mods):
				return "k_" + keyCode + getModStr(mods);
			case Char(charCode, mods):
				return "c_" + charCode + getModStr(mods);
		}
	}
	private function getModStr(mods:Array<ModKeys>):String{
		if (mods != null) {
			var modStr:String = ":";
			if (Lambda.indexOf(mods, Ctrl)!=-1) modStr += "ctrl_";
			if (Lambda.indexOf(mods, Alt)!=-1) modStr += "alt_";
			if (Lambda.indexOf(mods, Shift)!=-1) modStr += "shift";
			return modStr;
		}else {
			return "";
		}
	}
}