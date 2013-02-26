package guise.core;

import msignal.Signal;
/**
 * ...
 * @author Tom Byrne
 */

interface IPosition 
{
	@:isVar public var posChanged(default, null):Signal1<IPosition>;
	
	@:isVar public var x(default, null):Float;
	@:isVar public var y(default, null):Float;

	public function set(x:Float, y:Float):Void ;
	
}
class Position implements IPosition
{
	@:isVar public var posChanged(default, null):Signal1<IPosition>;
	
	@:isVar public var x(default, null):Float;
	@:isVar public var y(default, null):Float;

	public function new(?x:Null<Float>, ?y:Null<Float>) 
	{
		posChanged = new Signal1();
		if(x!=null && y!=null)set(x, y);
	}
	
	public function set(x:Float, y:Float):Void {
		if (this.x != x || this.y != y) {
			this.x = x;
			this.y = y;
			posChanged.dispatch(this);
		}
	}
	
}