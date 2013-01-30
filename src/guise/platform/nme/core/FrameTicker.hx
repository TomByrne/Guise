package guise.platform.nme.core;
import nme.Lib;
import nme.events.Event;
import guise.accessTypes.CoreAccessTypes;

import msignal.Signal;
/**
 * ...
 * @author Tom Byrne
 */

class FrameTicker extends guise.platform.cross.core.FrameTicker
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