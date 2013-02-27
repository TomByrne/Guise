package guise.controls.data;

import msignal.Signal;

interface ISelected 
{
	@:isVar public var selectedChanged(get, null):Signal1<ISelected>;
	
	@:isVar public var selected(default, null):Bool;
	
	public function setSelected(selected:Bool):Void;
}

// Default implementation
@:build(LazyInst.check())
class Selected implements ISelected
{
	@lazyInst public var selectedChanged:Signal1<ISelected>;
	
	@change("selectedChanged")
	public var selected(default, null):Bool;

	public function new(selected:Null<Bool>=null) 
	{
		setSelected(selected);
	}
	
	public function setSelected(selected:Bool):Void {
		if (this.selected == selected) return;
		
		this.selected = selected;
		LazyInst.exec(selectedChanged.dispatch(this));
	}
}