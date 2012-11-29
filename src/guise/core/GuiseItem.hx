package guise.core;

import guise.traits.core.CascadingActive;
import guise.traits.core.IActive;
import guise.traits.core.IPosition;
import guise.traits.core.ISize;
import composure.core.ComposeGroup;

/**
 * This class provides a simple setup for many of the UI elements.
 * I should be considered a default setup, but never the superclass of all UI elements.
 * Alternative configurations can and will exist which replace or reconfigure these core traits.
 * 
 * 
 * @author Tom Byrne
 */

class GuiseItem extends ComposeGroup
{
	public var position(default, null):IPosition;
	public var size(default, null):ISize;
	public var active(default, null):IActive;

	public function new(?x:Float, ?y:Float, ?w:Float, ?h:Float) {
		super();
		
		createPosition(x, y);
		createSize(w, h);
		createActive();
	}
	private function createPosition(?x:Float, ?y:Float):Void {
		this.position = new Position(x,y);
		addTrait(this.position);
	}
	private function createSize(?w:Float, ?h:Float):Void {
		this.size = new Size(w,h);
		addTrait(this.size);
	}
	private function createActive():Void {
		this.active = new CascadingActive();
		addTrait(this.active);
	}
}