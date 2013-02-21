package guise.layout;
import composure.traits.AbstractTrait;
import guise.frame.FrameTrait;
import guise.meas.IMeasurement;
import msignal.Signal;

class AbsLayout extends AbstractTrait, implements IMeasurement {
	
	@lazyInst
	public var measChanged:Signal1<IMeasurement>;
	
	public var measWidth(get_measWidth, null):Float;
	private function get_measWidth():Float {
		return _measWidth;
	}
	
	public var measHeight(get_measHeight, null):Float;
	private function get_measHeight():Float {
		return _measHeight;
	}
	
	@inject
	public var boxPos(default, set_boxPos):IBoxPos;
	private function set_boxPos(value:IBoxPos):IBoxPos {
		if (boxPos != null) {
			boxPos.sizeChanged.remove(onSizeChanged);
		}
		this.boxPos = value;
		if (boxPos != null) {
			boxPos.sizeChanged.add(onSizeChanged);
			onSizeChanged(boxPos);
		}
		return value;
	}
	
	private var _measWidth:Float;
	private var _measHeight:Float;
	private var _frameTrait:FrameTrait;
	
	public function new() {
		super();
		addSiblingTrait(_frameTrait = new FrameTrait());
	}
	
	private function onSizeChanged(from:IBoxPos):Void {
		// override me
	}
	
	private function setMeas(measWidth:Float, measHeight:Float):Void {
		if (measWidth != _measWidth || measHeight != _measHeight) {
			_measWidth = measWidth;
			_measHeight = measHeight;
			LazyInst.exec(measChanged.dispatch(this));
		}
	}
	
	private inline function addFrameCall(call:FrameCall, ?dependsOn:Array < FrameCall > , valid:Bool = true ):Void {
		_frameTrait.add(call, dependsOn , valid);
	}
	private inline function invalidate(call:FrameCall):Void {
		_frameTrait.invalidate(call);
	}
	/*private inline function validate():Void {
		_frameTrait.validate();
	}*/
	
}