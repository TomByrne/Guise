package guise.logic.input;
import guise.core.IActive;
import composure.traits.AbstractTrait;
import guise.accessTypes.IMouseInteractionsAccess;
import msignal.Signal;


class MouseOverTrait extends AbstractTrait
{
	private static var ACCESS_TYPES:Array<Class<Dynamic>> = [IMouseInteractionsAccess];
	
	
	@inject
	public var active(default, set_active):IActive;
	public function set_active(value:IActive):IActive {
		this.active = value;
		return value;
	}
	
	public var mouseOver(default, null):Bool;
	private var _mouseOverChanged:Signal1<MouseOverTrait>;
	public var mouseOverChanged(get_mouseOverChanged, null):Signal1<MouseOverTrait>;
	private function get_mouseOverChanged():Signal1<MouseOverTrait> {
		if (_mouseOverChanged == null) {
			_mouseOverChanged = new Signal1();
		}
		return _mouseOverChanged;
	}
	
	private var _mouseOver:Bool;
	private var _mouseInteractions:IMouseInteractionsAccess;
	
	@:isVar public var layerName(default, set_layerName):String;
	private function set_layerName(value:String):String {
		this.layerName = value;
		return value;
	}

	public function new(?layerName:String) 
	{
		super();
		
		this.layerName = layerName;
	}
	public function getAccessTypes():Array<Class<Dynamic>> {
		return ACCESS_TYPES;
	}
	@injectAdd
	private function onMouseIntAdd(access:IMouseInteractionsAccess):Void {
		if (layerName != null && access.layerName != layerName) return;
		
		_mouseInteractions = access;
		_mouseInteractions.rolledOver.add(onRolledOver);
		_mouseInteractions.rolledOut.add(onRolledOut);
		assessMouseOver();
	}
	@injectRemove
	private function onMouseIntRemove(access:IMouseInteractionsAccess):Void {
		if (access != _mouseInteractions) return;
		
		_mouseInteractions.rolledOver.remove(onRolledOver);
		_mouseInteractions.rolledOut.remove(onRolledOut);
		_mouseOver = false;
		_mouseInteractions = null;
	}
	private function onRolledOver(?info:MouseInfo):Void {
		_mouseOver = true;
		assessMouseOver();
	}
	private function onRolledOut(?info:MouseInfo):Void {
		_mouseOver = false;
		assessMouseOver();
	}
	
	private function assessMouseOver():Void {
		var value:Bool = ((active == null || active.active) && _mouseInteractions != null && _mouseOver);
		
		if (this.mouseOver != value) {
			this.mouseOver = value;
			if (_mouseOverChanged != null)_mouseOverChanged.dispatch(this);
		}
	}
}