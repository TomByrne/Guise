package guise.platform.html5.logic;
import composure.traits.AbstractTrait;
import guise.platform.types.InteractionAccessTypes;
import js.Dom;

import msignal.Signal;
import guise.platform.html5.display.DisplayTrait;

/**
 * ...
 * @author Tom Byrne
 */

class MouseClickable extends AbstractTrait, implements IMouseClickable
{
	@inject
	public var displayTrait(default, set_displayTrait):DisplayTrait;
	private function set_displayTrait(value:DisplayTrait):DisplayTrait {
		if (displayTrait!=null) {
			displayTrait.domElement.onclick = null;
		}
		displayTrait = value;
		if (displayTrait != null) {
			if(_clicked!=null && _clicked.numListeners>0)displayTrait.domElement.onclick = onClicked;
			if (_doubleClicked != null && _doubleClicked.numListeners>0)displayTrait.domElement.ondblclick = onDoubleClicked;
		}
		return value;
	}
	
	private var clickInfo:ClickInfo;

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
	
	private function onClicked(event:Event):Void {
		if (_clicked != null) {
			setClickInfo(true, event.altKey, event.ctrlKey, event.shiftKey);
			_clicked.dispatch(clickInfo);
		}
	}
	private function onDoubleClicked(event:Event):Void {
		if (_doubleClicked != null) {
			setClickInfo(true, event.altKey, event.ctrlKey, event.shiftKey);
			_doubleClicked.dispatch(clickInfo);
		}
	}
	
	private var _clicked:Signal1<ClickInfo>;
	public var clicked(get_clicked, null):Signal1<ClickInfo>;
	private function get_clicked():Signal1<ClickInfo> {
		if (_clicked == null) {
			_clicked = new Signal1();
			if(displayTrait!=null)displayTrait.domElement.onclick = onClicked;
		}
		return _clicked;
	}
	
	private var _doubleClicked:Signal1<ClickInfo>;
	public var doubleClicked(get_doubleClicked, null):Signal1<ClickInfo>;
	private function get_doubleClicked():Signal1<ClickInfo> {
		if (_doubleClicked == null) {
			_doubleClicked = new Signal1();
			if (displayTrait != null) displayTrait.domElement.ondblclick = onDoubleClicked;
		}
		return _doubleClicked;
	}
}