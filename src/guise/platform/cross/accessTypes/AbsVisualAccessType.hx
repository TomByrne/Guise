package guise.platform.cross.accessTypes;
import guise.accessTypes.IVisualAccessType;
import msignal.Signal;

@:build(LazyInst.check())
class AbsVisualAccessType implements IVisualAccessType
{
	@:isVar public var idealDepth(default, set_idealDepth):Int;
	private function set_idealDepth(value:Int):Int {
		this.idealDepth = value;
		LazyInst.exec(idealDepthChanged.dispatch(this));
		return value;
	}
	@lazyInst public var idealDepthChanged:Signal1<IVisualAccessType>;
	
	
	
	@:isVar public var layerName(default, set_layerName):String;
	private function set_layerName(value:String):String {
		this.layerName = value;
		return value;
	}

	public function new(?layerName:String) 
	{
		this.layerName = layerName;
	}
	
}