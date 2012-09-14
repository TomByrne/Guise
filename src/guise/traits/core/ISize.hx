package guise.traits.core;

import msignal.Signal;
 /* ...
 * @author Tom Byrne
 */

interface ISize 
{
	public var sizeChanged(default, null):Signal1<ISize>;
	
	public var width(default, null):Float;
	public var height(default, null):Float;

	public function set(width:Float, height:Float):Void;
	
}