package guise.platform.nme.accessTypes;
import composure.traits.AbstractTrait;
import guise.accessTypes.IMouseClickableAccess;
import guise.platform.nme.display.DisplayTrait;
import nme.display.InteractiveObject;
import nme.events.MouseEvent;

import msignal.Signal;


/**
 * ...
 * @author Tom Byrne
 */

class MouseClickableAccess extends AbstractTrait, implements IMouseClickableAccess
{
	@inject
	public var displayTrait(default, set_displayTrait):DisplayTrait;
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
	
	public var interactiveObject(default, set_interactiveObject):InteractiveObject;
	private function set_interactiveObject(value:InteractiveObject):InteractiveObject {
		if (interactiveObject!=null) {
			interactiveObject.removeEventListener(MouseEvent.CLICK, onClicked);
			interactiveObject.removeEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClicked);
		}
		interactiveObject = value;
		if (interactiveObject!=null) {
			if(_clicked!=null && _clicked.numListeners>0)interactiveObject.addEventListener(MouseEvent.CLICK, onClicked);
			if (_doubleClicked != null && _doubleClicked.numListeners>0) interactiveObject.addEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClicked);
		}
		return value;
	}
	
	private var clickInfo:ClickInfo;
	
	public var layerName(default, set_layerName):String;
	private function set_layerName(value:String):String {
		this.layerName = value;
		return value;
	}

	public function new(?layerName:String, ?interactiveObject:InteractiveObject) 
	{
		super();
		this.layerName = layerName;
		this.interactiveObject = interactiveObject;
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
		if (_clicked != null) {
			setClickInfo(true, event.altKey, event.ctrlKey, event.shiftKey);
			_clicked.dispatch(clickInfo);
		}
	}
	private function onDoubleClicked(event:MouseEvent):Void {
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
			if(interactiveObject!=null)interactiveObject.addEventListener(MouseEvent.CLICK, onClicked);
		}
		return _clicked;
	}
	
	private var _doubleClicked:Signal1<ClickInfo>;
	public var doubleClicked(get_doubleClicked, null):Signal1<ClickInfo>;
	private function get_doubleClicked():Signal1<ClickInfo> {
		if (_doubleClicked == null) {
			_doubleClicked = new Signal1();
			if (interactiveObject != null) interactiveObject.addEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClicked);
		}
		return _doubleClicked;
	}
}