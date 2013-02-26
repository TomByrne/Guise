package guise.platform.waxe.logic;
import composure.traits.AbstractTrait;
import guise.frame.IFrameTicker;
import guise.platform.waxe.display.WindowTrait;
import msignal.Signal;
import guise.utils.Timer;

class FrameTicker extends AbstractTrait implements IFrameTicker
{
	@:isVar public var frameTick(default, null):Signal0;
	@:isVar public var actualFPS(default, null):Float;
	
	@inject({asc:true})
	@:isVar public var windowTrait(default, set):WindowTrait;
	private function set_windowTrait(value:WindowTrait):WindowTrait {
		if(windowTrait!=null){
			windowTrait.clear(this);
		}
		this.windowTrait = value;
		if (windowTrait != null) {
			windowTrait.addHandler(this, wx.EventID.PAINT, onPaint);
			windowTrait.addHandler(this, wx.EventID.IDLE, onPaint);
		}
		return value;
	}
	
	private var _frames:Array<Float>;

	public function new(){
		super();
		_frames = [];
		frameTick = new Signal0();
	}
	
	private function onPaint(e:Dynamic):Void {
		tick();
	}
	public function setIntendedFPS(fps:Int):Void {
		// set via wxSystemOptions
	}
	
	public function tick():Void {
		var time:Float = Timer.stamp();
		var timePast:Float = time<1?0:time-1; // a second before now (or 0 for the first second)
		while(_frames.length>0 && _frames[0]<timePast){
			_frames.shift();
		}
		_frames.push(time);
		actualFPS = _frames.length;
		
		frameTick.dispatch();
	}
}