package guise.accessTypes;

import msignal.Signal;
import guise.platform.IPlatformAccess;

/**
 * @author Tom Byrne
 */

class CoreAccessTypes 
{}

interface IFrameTicker implements IAccessType
{
	public var frameTick(default, null):Signal0;
	public var actualFPS(default, null):Float;
	public function setIntendedFPS(fps:Int):Void;
	
}