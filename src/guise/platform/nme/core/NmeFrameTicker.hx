package guise.platform.nme.core;
import guise.platform.cross.core.IFrameTicker;
import nme.Lib;
import nme.events.Event;

import msignal.Signal;

class NmeFrameTicker extends guise.platform.cross.core.FrameTicker
{

	public function new(intendedFPS:Int=60) 
	{
		Lib.stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		super();
	}
	
	override public function setIntendedFPS(fps:Int):Void {
		Lib.stage.frameRate = fps;
	}
	
	public function onEnterFrame(e:Event):Void {
		tick();
	}
}