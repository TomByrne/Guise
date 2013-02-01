package guise.core;

import msignal.Signal;
/**
 * ...
 * @author Tom Byrne
 */

interface IPosition 
{
	public var posChanged(default, null):Signal1<IPosition>;
	
	public var x(default, null):Float;
	public var y(default, null):Float;

	public function set(x:Float, y:Float):Void ;
	
}
class Position implements IPosition
{
	public var posChanged(default, null):Signal1<IPosition>;
	
	public var x(default, null):Float;
	public var y(default, null):Float;

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