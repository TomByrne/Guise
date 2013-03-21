package guise.data;

import msignal.Signal;

/**
 * IControlInfo is a visual tip attached to a control to explain it's use to a user.
 * 
 * This can include a tooltip, a validation warning, a call-to-action, etc.
 */
interface IControlInfo
{
	public var infoChanged(get_infoChanged, null):Signal1<IControlInfo>;
	
	public var info(default, null):String;
	public var type(default, null):ControlInfoType;
	
	public function setInfo(text:String):Void;
}

enum ControlInfoType {
	FocusTip; // used to give information about the control when it is focused
	//ValidationError; // used to give information about the control when it's value is invalid
	//CallToAction; // used to draw attention to a control 
}


// Default implementation
@:build(LazyInst.check())
class ControlInfo implements IControlInfo
{
	@lazyInst public var infoChanged:Signal1<IControlInfo>;
	
	public var info(default, null):String;
	public var type(default, null):ControlInfoType;

	public function new(type:ControlInfoType, ?info:Null<String>) 
	{
		this.type = type;
		setInfo(info);
	}
	
	public function setInfo(info:String):Void {
		if (this.info == info) return;
		
		this.info = info;
		LazyInst.exec(infoChanged.dispatch(this));
	}
	
}