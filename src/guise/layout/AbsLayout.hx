package guise.layout;
import composure.traits.AbstractTrait;
import guise.frame.FrameTrait;
import guise.meas.IMeasurement;
import msignal.Signal;

class AbsLayout extends AbstractTrait {
	
	
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
	
	private var _meas:SimpleMeas;
	private var _frameTrait:FrameTrait;
	
	public function new() {
		super();
		addSiblingTrait(_meas = new SimpleMeas());
		addSiblingTrait(_frameTrait = new FrameTrait());
	}
	
	private function onSizeChanged(from:IBoxPos):Void {
		// override me
	}
	
	private function setMeas(measWidth:Float, measHeight:Float):Void {
		_meas.set(measWidth, measHeight);
	}
	
	private inline function addFrameCall(call:FrameCall, ?dependsOn:Array < FrameCall > , valid:Bool = true ):Void {
		_frameTrait.add(call, valid, dependsOn );
	}
	private inline function invalidate(call:FrameCall):Void {
		_frameTrait.invalidate(call);
	}
	/*private inline function validate():Void {
		_frameTrait.validate();
	}*/
	
}