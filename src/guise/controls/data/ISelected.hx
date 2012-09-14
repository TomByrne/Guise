package guise.controls.data;

import msignal.Signal;
/**
 * ...
 * @author Tom Byrne
 */

interface ISelected 
{
	public var selectedChanged(default, null):Signal1<ISelected>;
	
	public var selected(default, null):Bool;
	
	public function set(selected:Bool):Void;
}


// Default implementation
class Selected implements ISelected
{
	public var selectedChanged(default, null):Signal1<ISelected>;
	
	public var selected(default, null):Bool;

	public function new(selected:Null<Bool>=null) 
	{
		selectedChanged = new Signal1();
		set(selected);
	}
	
	public function set(selected:Bool):Void {
		if (this.selected != selected) {
			this.selected = selected;
			selectedChanged.dispatch(this);
		}
	}
}