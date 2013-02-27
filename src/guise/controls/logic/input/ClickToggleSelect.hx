package guise.controls.logic.input;
import composure.traits.AbstractTrait;
import guise.controls.data.ISelected;
import guise.accessTypes.IMouseClickableAccess;
import guise.platform.cross.IAccessRequest;

class ClickToggleSelect extends AbstractTrait implements IAccessRequest
{
	private static var ACCESS_TYPES:Array<Class<Dynamic>> = [IMouseClickableAccess];
	
	@inject
	public var selected:ISelected;
	
	@:isVar public var layerName(default, set):String;
	private function set_layerName(value:String):String {
		this.layerName = value;
		return value;
	}
	
	private var _mouseClickable:IMouseClickableAccess;

	public function new(?layerName:String) 
	{
		super();
		this.layerName = layerName;
	}
	@injectAdd
	private function onMouseClickAdd(access:IMouseClickableAccess):Void {
		if (layerName != null && access.layerName != layerName) return;
		
		_mouseClickable = access;
		_mouseClickable.clicked.add(onClicked);
	}
	@injectRemove
	private function onMouseClickRemove(access:IMouseClickableAccess):Void {
		if (access != _mouseClickable) return;
		
		_mouseClickable.clicked.remove(onClicked);
		_mouseClickable = null;
	}
	
	private function onClicked(info:ClickInfo):Void {
		if (selected != null) selected.setSelected(!selected.selected);
	}
	public function getAccessTypes():Array<Class<Dynamic>> {
		return ACCESS_TYPES;
	}
	
}