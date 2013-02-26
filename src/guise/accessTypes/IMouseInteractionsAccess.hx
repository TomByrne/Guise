package guise.accessTypes;

import msignal.Signal;

interface IMouseInteractionsAccess extends IAccessType
{
	public var pressed(get, null):Signal1<MouseInfo>;
	public var released(get, null):Signal1<MouseInfo>;
	
	public var rolledOver(get, null):Signal1<MouseInfo>;
	public var rolledOut(get, null):Signal1<MouseInfo>;
	
	public var moved(get, null):Signal1<MouseInfo>;
}
class MouseInfo {
	public var mouseX:Float;
	public var mouseY:Float;
	
	public function new() {
		
	}
}