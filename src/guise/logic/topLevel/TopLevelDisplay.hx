package guise.logic.topLevel;
import composure.core.ComposeItem;

class TopLevelDisplay
{
	@:isVar public var item(default, null):ComposeItem;
	@:isVar public var fitInWindow(default, null):Bool;

	public function new(item:ComposeItem, fitInWindow:Bool) 
	{
		this.item = item;
		this.fitInWindow = fitInWindow;
	}
	
}