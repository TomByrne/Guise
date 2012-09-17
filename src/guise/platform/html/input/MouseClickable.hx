package guise.platform.html.input;
import composure.traits.AbstractTrait;
import guise.platform.types.InteractionAccessTypes;
import js.Dom;

import msignal.Signal;

/**
 * ...
 * @author Tom Byrne
 */

class MouseClickable implements IMouseClickable
{
	public var domElement(default, set_domElement):HtmlDom;
	private function set_domElement(value:HtmlDom):HtmlDom {
		if (domElement!=null) {
			domElement.onclick = null;
		}
		domElement = value;
		if (domElement != null) {
			domElement.onclick = onClicked;
		}
		return value;
	}
	
	private var clickInfo:ClickInfo;

	public function new(?domElement:HtmlDom) 
	{
		this.domElement = domElement;
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
			if(domElement!=null)domElement.addEventListener(MouseEvent.CLICK, onClicked);
		}
		return _clicked;
	}
	
	private var _doubleClicked:Signal1<ClickInfo>;
	public var doubleClicked(get_doubleClicked, null):Signal1<ClickInfo>;
	private function get_doubleClicked():Signal1<ClickInfo> {
		if (_doubleClicked == null) {
			_doubleClicked = new Signal1();
			if (domElement != null) domElement.addEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClicked);
		}
		return _doubleClicked;
	}
}