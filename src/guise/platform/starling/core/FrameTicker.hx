package guise.platform.starling.core;
import guise.frame.IFrameTicker;
import flash.Lib;
import flash.events.Event;

import msignal.Signal;

class FrameTicker extends guise.frame.FrameTicker
{

	public function new(intendedFPS:Int=60) 
	{
		Lib.current.stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		super();
	}
	
	override public function setIntendedFPS(fps:Int):Void {
		Lib.current.stage.frameRate = fps;
	}
	
	public function onEnterFrame(e:Event):Void {
		tick();
	}
}