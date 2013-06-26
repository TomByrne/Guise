package guise.platform.basisApple.logic;
import composure.traits.AbstractTrait;
import guise.accessTypes.IMouseClickableAccess;
import basis.object.IObject;
import apple.ui.*;

import msignal.Signal;
import guise.platform.basisApple.display.DisplayTrait;

class MouseClickable extends AbstractTrait implements IMouseClickableAccess
{
	@inject
	@:isVar public var displayTrait(default, set):DisplayTrait<UIControl>;
	private function set_displayTrait(value:DisplayTrait<UIControl>):DisplayTrait<UIControl> {
		if (displayTrait!=null) {
			//displayTrait.view.removeEventListener(UIControl.UIControlTouchUpInside, onClicked);
		}
		displayTrait = value;
		if (displayTrait != null) {
			displayTrait.view.addEventListener(UIControl.UIControlTouchUpInside, onClicked);
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
	
	/*private function setClickInfo(left:Bool, altHeld:Bool, ctrlHeld:Bool, shiftHeld:Bool):Void {
		if (clickInfo == null) {
			clickInfo = new ClickInfo();
		}
		clickInfo.left = left;
		clickInfo.altHeld = altHeld;
		clickInfo.ctrlHeld = ctrlHeld;
		clickInfo.shiftHeld = shiftHeld;
	}*/
	
	private function onClicked(object:IObject, type:String):Void {
		//setClickInfo(true, event.altKey, event.ctrlKey, event.shiftKey);
		LazyInst.exec(clicked.dispatch(clickInfo));
	}
	/*private function onDoubleClicked(object:IObject, type:String):Void {
		//setClickInfo(true, event.altKey, event.ctrlKey, event.shiftKey);
		LazyInst.exec(doubleClicked.dispatch(clickInfo));
	}*/
	
	@lazyInst public var clicked:Signal1<ClickInfo>;

	public var doubleClicked(get, null):Signal1<ClickInfo>;
	private function get_doubleClicked():Signal1<ClickInfo>{
		throw "Double Click not available on this platform";
		return null;
	}
}