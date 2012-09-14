package guise.layout;

import guise.layout.AbstractLayout;

/**
 * ...
 * @author Tom Byrne
 */


class Position extends LayoutInfo<Position>
{
	public var x:Float;
	public var y:Float;
	public var w:Float;
	public var h:Float;

	public function new(?x:Float, ?y:Float, ?w:Float, ?h:Float) {
		this.x = x;
		this.y = y;
		this.w = w;
		this.h = h;
	}
	
	
	public function set(x:Float, y:Float, w:Float, h:Float):Void {
		this.x = x;
		this.y = y;
		this.w = w;
		this.h = h;
		layoutChanged();
	}
	public function setPosition(x:Float, y:Float):Void {
		this.x = x;
		this.y = y;
		layoutChanged();
	}
	public function setSize(w:Float, h:Float):Void {
		this.w = w;
		this.h = h;
		layoutChanged();
	}
}