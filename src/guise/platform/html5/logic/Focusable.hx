package guise.platform.html5.logic;
import composure.traits.AbstractTrait;
import guise.accessTypes.IFocusableAccess;
import js.Dom;

import msignal.Signal;
import guise.platform.html5.display.DisplayTrait;

class Focusable extends AbstractTrait, implements IFocusableAccess
{
	@inject
	public var displayTrait(default, set_displayTrait):DisplayTrait;
	private function set_displayTrait(value:DisplayTrait):DisplayTrait {
		if (displayTrait!=null) {
			displayTrait.domElement.onfocus = null;
			displayTrait.domElement.onblur = null;
		}
		displayTrait = value;
		if (displayTrait != null) {
			displayTrait.domElement.onfocus = onFocus;
			displayTrait.domElement.onblur = onBlur;
		}
		return value;
	}
	
	public var layerName(default, set_layerName):String;
	private function set_layerName(value:String):String {
		this.layerName = value;
		return value;
	}
	
	@lazyInst
	public var focusedChanged:Signal1<IFocusableAccess>;
	public var focused(default, null):Bool ;

	public function new() 
	{
		super();
	}
	
	private function onFocus(event:Event):Void {
		this.focused = true;
		LazyInst.exec(focusedChanged.dispatch(this));
	}
	private function onBlur(event:Event):Void {
		this.focused = false;
		LazyInst.exec(focusedChanged.dispatch(this));
	}
	
}