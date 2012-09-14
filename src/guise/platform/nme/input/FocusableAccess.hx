package guise.platform.nme.input;
import guise.platform.IPlatformAccess;
import nme.events.Event;
import nme.events.FocusEvent;
import nme.display.InteractiveObject;
import msignal.Signal;
/**
 * ...
 * @author Tom Byrne
 */

class FocusableAccess implements IFocusableAccess
{
	public var interactiveObject(default, set_interactiveObject):InteractiveObject;
	private function set_interactiveObject(value:InteractiveObject):InteractiveObject {
		if(interactiveObject!=null){
			interactiveObject.removeEventListener(FocusEvent.FOCUS_IN, onFocusIn);
			interactiveObject.removeEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
		}
		this.interactiveObject = value;
		if(interactiveObject!=null){
			interactiveObject.addEventListener(FocusEvent.FOCUS_IN, onFocusIn);
			interactiveObject.addEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
		}
		return value;
	}

	public function new(?interactiveObject:InteractiveObject) 
	{
		this.interactiveObject = interactiveObject;
	}
	private function onFocusIn(e:Event):Void {
		focused = true;
		if (focusedChanged != null) focusedChanged.dispatch(this);
	}
	private function onFocusOut(e:Event):Void {
		focused = false;
		if (focusedChanged != null) focusedChanged.dispatch(this);
	}
	
	public var focused(default, null):Bool;
	
	public var focusedChanged(get_focusedChanged, null):Signal1 < IFocusableAccess >;
	private function get_focusedChanged():Signal1 < IFocusableAccess >{
		if (focusedChanged == null) focusedChanged = new Signal1();
		return focusedChanged;
	}
}