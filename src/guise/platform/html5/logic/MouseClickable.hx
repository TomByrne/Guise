package guise.platform.html5.logic;
import composure.traits.AbstractTrait;
import guise.accessTypes.IMouseClickableAccess;

import msignal.Signal;
import guise.platform.html5.display.DisplayTrait;
import js.html.MouseEvent;

class MouseClickable extends AbstractTrait implements IMouseClickableAccess
{
	@inject
	@:isVar public var displayTrait(default, set):DisplayTrait;
	private function set_displayTrait(value:DisplayTrait):DisplayTrait {
		if (displayTrait!=null) {
			displayTrait.domElement.onclick = null;
			displayTrait.domElement.ondblclick = null;
		}
		displayTrait = value;
		if (displayTrait != null) {
			untyped displayTrait.domElement.onclick = onClicked;
			untyped displayTrait.domElement.ondblclick = onDoubleClicked;
		}
		return value;
	}
	
	private var clickInfo:ClickInfo;
	
	@:isVar public var layerName(default, set):String;
	private function set_layerName(value:String):String {
		this.layerName = value;
		return value;
	}

	public function new() 
	{
		super();
	}
	
	private function setClickInfo(left:Bool, altHeld:Bool, ctrlHeld:Bool, shiftHeld:Bool):Void {
		if (clickInfo == null) {
			clickInfo = new ClickInfo();
		}
		clickInfo.left = left;
		clickInfo.altHeld = altHeld;
		clickInfo.ctrlHeld = ctrlHeld;
		clickInfo.shiftHeld = shiftHeld;
	}
	
	private function onClicked(event:MouseEvent):Void {
		setClickInfo(true, event.altKey, event.ctrlKey, event.shiftKey);
		LazyInst.exec(clicked.dispatch(clickInfo));
	}
	private function onDoubleClicked(event:MouseEvent):Void {
		setClickInfo(true, event.altKey, event.ctrlKey, event.shiftKey);
		LazyInst.exec(doubleClicked.dispatch(clickInfo));
	}
	
	@lazyInst public var clicked:Signal1<ClickInfo>;
	@lazyInst public var doubleClicked:Signal1<ClickInfo>;
}