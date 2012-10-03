package guise.platform.html.display;

import guise.traits.core.IPosition;
import guise.traits.core.Position;
import guise.traits.core.Size;
import guise.platform.types.DisplayAccessTypes;
import guise.core.AbsPosSizeAwareTrait;

import js.Lib;
import js.Dom;
import js.w3c.html5.Canvas2DContext;
import js.w3c.html5.Core;
import js.Dom.HtmlDom;
import composure.traits.AbstractTrait;
import msignal.Signal;

/**
 * @author Tom Byrne
 */

class WindowTrait extends AbsPosSizeAwareTrait, implements IScreenInfo
{
	public var availSizeChanged(default, null):Signal1<IScreenInfo>;
	
	public var availWidth(default, null):Int;
	public var availHeight(default, null):Int;
	
	var window:js.Window;

	public function new() 
	{
		super();
		
		availSizeChanged = new Signal1();
		
		window = Lib.window;
		window.onresize = onWindowResized;
		
		setAvailSize(window.screen.availWidth, window.screen.availHeight);
	}
	
	override private function posChanged():Void {
		if (!Math.isNaN(position.y) && !Math.isNaN(position.x)) {
			window.moveTo(Std.int(position.x), Std.int(position.y));
		}
	}
	override private function sizeChanged():Void {
		if (!Math.isNaN(size.width) && !Math.isNaN(size.height)) {
			window.innerWidth = Std.int(size.width);
			window.innerHeight = Std.int(size.height);
			size.set(window.innerWidth, window.innerHeight);
		}
	}
	
	private function setAvailSize(width:Int, height:Int):Void {
		if (this.availWidth != width || this.availHeight != height) {
			this.availWidth = width;
			this.availHeight = height;
			
			availSizeChanged.dispatch(this);
		}
	}
	private function onWindowResized(e:Event):Void {
		size.set(window.innerWidth, window.innerHeight);
	}
}