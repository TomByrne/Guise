package guise.platform.html5.display;

import guise.layout.IDisplayPosition;
import guise.traits.core.IPosition;

import js.Lib;
import js.Dom;
import js.w3c.html5.Canvas2DContext;
import js.w3c.html5.Core;
import js.Dom.HtmlDom;
import composure.traits.AbstractTrait;
import msignal.Signal;
import guise.platform.cross.display.AbsDisplayTrait;

/**
 * @author Tom Byrne
 */

class WindowTrait extends AbsDisplayTrait//, implements IWindowInfo
{
	/*@lazyInst
	public var availSizeChanged(default, null):Signal1<IWindowInfo>;
	
	public var availWidth(default, null):Int;
	public var availHeight(default, null):Int;*/
	
	var window:js.Window;

	public function new() 
	{
		super();
		_sizeListen = true;
		_posListen = true;
		
		window = Lib.window;
		/*window.onresize = onWindowResized;
		
		setAvailSize(window.screen.availWidth, window.screen.availHeight);*/
	}
	
	override private function onPosValid(x:Float, y:Float):Void {
		window.moveTo(Std.int(x), Std.int(y));
	}
	override private function onSizeValid(w:Float, h:Float):Void {
		window.innerWidth = Std.int(w);
		window.innerHeight = Std.int(h);
	}
	
	/*private function setAvailSize(width:Int, height:Int):Void {
		if (this.availWidth != width || this.availHeight != height) {
			this.availWidth = width;
			this.availHeight = height;
			
			LazyInst.exec(availSizeChanged.dispatch(this));
		}
	}
	private function onWindowResized(e:Event):Void {
		setAvailSize(window.screen.availWidth, window.screen.availHeight);
	}*/
}