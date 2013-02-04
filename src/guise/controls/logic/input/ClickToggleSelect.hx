package guise.controls.logic.input;
import composure.traits.AbstractTrait;
import guise.controls.data.ISelected;
import guise.accessTypes.IMouseClickableAccess;

class ClickToggleSelect extends AbstractTrait
{
	@inject
	public var selected:ISelected;
	
	
	private var _mouseClickable:IMouseClickableAccess;
	private var _layerName:String;

	public function new(?layerName:String) 
	{
		super();
		_layerName = layerName;
		//addSiblingTrait(new PlatformAccessor(I_mouseClickable, layerName, onMouseClickAdd, onMouseClickRemove));
	}
	@injectAdd
	private function onMouseClickAdd(access:IMouseClickableAccess):Void {
		if (_layerName != null && access.layerName != _layerName) return;
		
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
		if (selected != null) selected.set(!selected.selected);
	}
	
}