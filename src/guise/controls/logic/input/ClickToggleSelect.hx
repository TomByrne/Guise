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
	
	@inject
	public var mouseClickable(default, set_mouseClickable):IMouseClickable;
	private function set_mouseClickable(value:IMouseClickable):IMouseClickable{
		
		if(mouseClickable!=null){
			mouseClickable.clicked.remove(onClicked);
			mouseClickable = null;
		}
		
		mouseClickable = value;
		if(mouseClickable!=null){
			mouseClickable = value;
			mouseClickable.clicked.add(onClicked);
		}
		return value;
	}

	public function new(?layerName:String) 
	{
		super();
		addSiblingTrait(new PlatformAccessor(IMouseClickable, layerName, onMouseClickAdd, onMouseClickRemove));
	}
	private function onMouseClickAdd(access:IMouseClickable):Void {
		if(mouseClickable==null)mouseClickable = access;
	}
	private function onMouseClickRemove(access:IMouseClickable):Void {
		if (mouseClickable == access) mouseClickable = null;
	}
	
	private function onClicked(info:ClickInfo):Void {
		if (selected != null) selected.set(!selected.selected);
	}
	
}