package guise.platform.waxe.logic;
import composure.traits.AbstractTrait;
import guise.accessTypes.IMouseClickableAccess;
import guise.accessTypes.IMouseInteractionsAccess;
import wx.Button;

import msignal.Signal;
import guise.platform.waxe.display.DisplayTrait;

class MouseClickable extends AbstractTrait implements IMouseClickableAccess
{
	@inject
	@:isVar public var displayTrait(default, set):DisplayTrait<Button>;
	private function set_displayTrait(value:DisplayTrait<Button>):DisplayTrait<Button> {
		if (displayTrait!=null) {
			displayTrait.clear(this);
			
		}
		displayTrait = value;
		if (displayTrait != null) {
			displayTrait.addHandler(this, wx.EventID.COMMAND_BUTTON_CLICKED, onClicked);
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
	
	private function onClicked(event:Dynamic):Void {
		if (_clicked != null) {
			//setClickInfo(true, event.altKey, event.ctrlKey, event.shiftKey);
			setClickInfo(true, false, false, false);
			_clicked.dispatch(clickInfo);
		}
	}
	/*private function onDoubleClicked(event:Event):Void {
		if (_doubleClicked != null) {
			setClickInfo(true, event.altKey, event.ctrlKey, event.shiftKey);
			_doubleClicked.dispatch(clickInfo);
		}
	}*/
	
	private var _clicked:Signal1<ClickInfo>;
	public var clicked(get, null):Signal1<ClickInfo>;
	private function get_clicked():Signal1<ClickInfo> {
		if (_clicked == null) {
			_clicked = new Signal1();
			if(displayTrait!=null)displayTrait.window.setHandler(wx.EventID.COMMAND_BUTTON_CLICKED,onClicked);
		}
		return _clicked;
	}
	
	private var _doubleClicked:Signal1<ClickInfo>;
	public var doubleClicked(get, null):Signal1<ClickInfo>;
	private function get_doubleClicked():Signal1<ClickInfo> {
		if (_doubleClicked == null) {
			_doubleClicked = new Signal1();
			//if (displayTrait != null) displayTrait.domElement.ondblclick = onDoubleClicked;
		}
		return _doubleClicked;
	}
}