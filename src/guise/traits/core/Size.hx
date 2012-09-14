package guise.traits.core;

import msignal.Signal;
 /* ...
 * @author Tom Byrne
 */

class Size implements ISize
{
	public var sizeChanged(default, null):Signal1<ISize>;
	
	public var width(default, null):Float;
	public var height(default, null):Float;

	public function new(?width:Null<Float>, ?height:Null<Float>) 
	{
		sizeChanged = new Signal1();
		if(width!=null && height!=null)set(width, height);
	}
	
	public function set(width:Float, height:Float):Void {
		if (this.width != width || this.height != height) {
			this.width = width;
			this.height = height;
			sizeChanged.dispatch(this);
		}
	}
	
}