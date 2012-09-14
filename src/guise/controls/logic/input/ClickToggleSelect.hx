package guise.controls.logic.input;
import composure.traits.AbstractTrait;
import guise.controls.data.ISelected;
import guise.platform.types.InteractionAccessTypes;
import guise.platform.PlatformAccessor;

/**
 * ...
 * @author Tom Byrne
 */

class ClickToggleSelect extends AbstractTrait
{
	@inject
	public var selected:ISelected;
	
	
	private var _mouseClickable:IMouseClickable;

	public function new(?layerName:String) 
	{
		super();
		addSiblingTrait(new PlatformAccessor(IMouseClickable, layerName, onMouseClickAdd, onMouseClickRemove));
	}
	private function onMouseClickAdd(access:IMouseClickable):Void {
		_mouseClickable = access;
		_mouseClickable.clicked.add(onClicked);
	}
	private function onMouseClickRemove(access:IMouseClickable):Void {
		_mouseClickable.clicked.remove(onClicked);
		_mouseClickable = null;
	}
	
	private function onClicked(info:ClickInfo):Void {
		if (selected != null) selected.set(!selected.selected);
	}
	
}