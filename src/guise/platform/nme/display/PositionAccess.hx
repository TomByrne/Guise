package guise.platform.nme.display;

import guise.platform.types.DisplayAccessTypes;
import nme.display.DisplayObject;

/**
 * ...
 * @author Tom Byrne
 */

class PositionAccess implements IPositionAccess
{
	public var display:DisplayObject;

	public function new(display:DisplayObject) 
	{
		this.display = display;
	}
	
	public function setPos(x:Float, y:Float):Void {
		display.x = x;
		display.y = y;
	}
}