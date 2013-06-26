package guise.platform.basisApple.core;

import msignal.Signal;

import apple.quartzcore.CADisplayLink;
import apple.foundation.NSRunLoop;
import basis.object.IObject;

import guise.utils.Timer;

class FrameTicker extends guise.frame.IFrameTicker.FrameTicker
{

	private var _intendedFps:Int;
	private var _intendedInt:Float;
	private var _lastFrame:Float;

	public function new(intendedFPS:Int=60) 
	{
		super();

		_lastFrame = -1;

		var link:CADisplayLink = CADisplayLink.displayLinkWithHandler(onRunLoop);
		var loop:NSRunLoop = NSRunLoop.currentRunLoop();
		link.addToRunLoopForMode(loop, CADisplayLink.getNSDefaultRunLoopMode());
	}
	
	override public function setIntendedFPS(fps:Int):Void {
		_intendedFps = fps;
		_intendedInt = (1/fps);
	}
	
	public function onRunLoop(object:IObject, type:String):Void {
		var time:Float = Timer.stamp();

		if(_lastFrame==-1 || actualFPS<_intendedFps || _lastFrame-time>=_intendedInt){
			_lastFrame = time;
			tick();
		}
	}
}