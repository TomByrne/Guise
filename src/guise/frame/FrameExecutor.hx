package guise.frame;
import composure.core.ComposeGroup;
import composure.core.ComposeItem;
import composure.traits.AbstractTrait;
import guise.platform.cross.IAccessRequest;

class FrameExecutor extends AbstractTrait, implements IAccessRequest
{
	private static var ACCESS_TYPES:Array<Class<Dynamic>> = [IFrameTicker];
	
	
	@:isVar public var layerName(default, set_layerName):String;
	private function set_layerName(value:String):String {
		this.layerName = value;
		return value;
	}
	
	@inject
	@:isVar public var frameTicker(default, set_frameTicker):IFrameTicker;
	private function set_frameTicker(value:IFrameTicker):IFrameTicker {
		if (frameTicker != null) {
			frameTicker.frameTick.remove(onFrameTick);
		}
		this.frameTicker = value;
		if (frameTicker != null) {
			frameTicker.frameTick.add(onFrameTick);
		}
		return value;
	}

	public function new(?layerName:String) 
	{
		super();
		this.layerName = layerName;
	}
	public function getAccessTypes():Array<Class<Dynamic>> {
		return ACCESS_TYPES;
	}
	
	private function onFrameTick():Void {
		validate(item);
	}
	private function validate(item:ComposeItem):Void {
		var frameTraits = item.getTraits(FrameTrait);
		for (frameTrait in frameTraits) {
			frameTrait.validate();
		}
		if (Std.is(item, ComposeGroup)) {
			var group:ComposeGroup = cast item;
			for (child in group.children) {
				validate(child);
			}
		}
	}
}