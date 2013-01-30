package guise.accessTypes;

import msignal.Signal;

interface IMouseInteractionsAccess implements IAccessType
{
	public var pressed(get_pressed, null):Signal1<MouseInfo>;
	public var released(get_released, null):Signal1<MouseInfo>;
	
	public var rolledOver(get_rolledOver, null):Signal1<MouseInfo>;
	public var rolledOut(get_rolledOut, null):Signal1<MouseInfo>;
	
	public var moved(get_moved, null):Signal1<MouseInfo>;
}
class MouseInfo {
	public var mouseX:Float;
	public var mouseY:Float;
	
	public function new() {
		
	}
}