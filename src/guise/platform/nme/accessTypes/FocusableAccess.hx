package guise.platform.nme.accessTypes;
import composure.traits.AbstractTrait;
import guise.accessTypes.IFocusableAccess;
import nme.display.InteractiveObject;
import nme.events.Event;
import nme.events.FocusEvent;
import msignal.Signal;
import guise.platform.nme.accessTypes.AdditionalTypes;


class FocusableAccess extends AbstractTrait, implements IFocusableAccess
{
	@inject
	public var interactiveType(default, set_interactiveType):IInteractiveObjectType;
	private function set_interactiveType(value:IInteractiveObjectType):IInteractiveObjectType {
		if(interactiveObject!=null){
			interactiveObject.removeEventListener(FocusEvent.FOCUS_IN, onFocusIn);
			interactiveObject.removeEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
		}
		this.interactiveType = value;
		this.interactiveObject = (interactiveType == null?null:interactiveType.getInteractiveObject());
		if(interactiveObject!=null){
			interactiveObject.addEventListener(FocusEvent.FOCUS_IN, onFocusIn);
			interactiveObject.addEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
		}
		return value;
	}
	
	@lazyInst
	public var focusedChanged:Signal1 < IFocusableAccess >;
	
	public var layerName:String;
	public var focused(default, null):Bool;
	public var interactiveObject:InteractiveObject;

	public function new(?layerName:String, ?interactiveObject:InteractiveObject) 
	{
		super();
		this.interactiveObject = interactiveObject;
		this.layerName = layerName;
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