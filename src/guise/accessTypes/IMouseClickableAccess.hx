package guise.accessTypes;

import msignal.Signal;


interface IMouseClickableAccess implements IAccessType
{
	public var clicked(get_clicked, null):Signal1<ClickInfo>;
	public var doubleClicked(get_doubleClicked, null):Signal1<ClickInfo>;
	
}
class ClickInfo {
	public var left:Bool;
	public var altHeld:Bool;
	public var ctrlHeld:Bool;
	public var shiftHeld:Bool;
	
	public function new() {
		
	}
}
