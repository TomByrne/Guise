package guise.platform.nme.accessTypes;
import guise.accessTypes.IFocusableAccess;
import guise.platform.cross.accessTypes.AbsVisualAccessType;
import guise.platform.nme.addTypes.IDisplayObjectType;
import guise.platform.nme.addTypes.IInteractiveObjectType;
import nme.display.DisplayObject;
import nme.display.InteractiveObject;
import msignal.Signal;
import nme.events.Event;
import nme.events.FocusEvent;

@:build(LazyInst.check())
class AbsIntObjAccess extends AbsVisualAccessType, implements IDisplayObjectType, implements IInteractiveObjectType, implements IFocusableAccess
{
	private var interactiveObject:InteractiveObject;
	
	
	@:isVar public var focused(default, null):Bool;
	@lazyInst public var focusedChanged:Signal1 < IFocusableAccess >;

	public function new(?layerName:String) 
	{
		super(layerName);
	}
	
	public function getDisplayObject():DisplayObject {
		return interactiveObject;
	}
	public function getInteractiveObject():InteractiveObject {
		return interactiveObject;
	}
	
	private function setInteractiveObject(intObj:InteractiveObject):Void {
		if (interactiveObject == intObj) return;
		
		if(interactiveObject!=null){
			interactiveObject.removeEventListener(FocusEvent.FOCUS_IN, onFocusIn);
			interactiveObject.removeEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
		}
		
		interactiveObject = intObj;
		
		if(interactiveObject!=null){
			interactiveObject.addEventListener(FocusEvent.FOCUS_IN, onFocusIn);
			interactiveObject.addEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
		}
	}
	
	private function onFocusIn(e:Event):Void {
		focused = true;
		LazyInst.exec(focusedChanged.dispatch(this));
	}
	private function onFocusOut(e:Event):Void {
		focused = false;
		LazyInst.exec(focusedChanged.dispatch(this));
	}
}