package guise.traits.core;

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