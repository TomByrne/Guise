package guise.platform.cross.core;
import haxe.Timer;
import msignal.Signal;
import guise.accessTypes.CoreAccessTypes;

/**
 * @author Tom Byrne
 */

class FrameTicker implements IFrameTicker
{
	public var frameTick(default, null):Signal0;
	public var actualFPS(default, null):Float;
	
	private var _timer:Timer;
	private var _frames:Array<Float>;

	public function new(intendedFPS:Int=60) {
		
		_frames = [];
		frameTick = new Signal0();
		
		setIntendedFPS(intendedFPS);
	}
	
	public function setIntendedFPS(fps:Int):Void {
		var ms:Int = Std.int(1000 / fps);
		if (_timer != null) {
			_timer.stop();
		}
		_timer = new Timer(ms);
		_timer.run = tick;
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