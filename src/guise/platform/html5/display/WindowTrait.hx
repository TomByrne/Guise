package guise.platform.html5.display;

import guise.layout.IDisplayPosition;
import guise.traits.core.IPosition;
import guise.accessTypes.DisplayAccessTypes;

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

class WindowTrait extends AbsDisplayTrait, implements IWindowInfo
{
	@lazyInst
	public var availSizeChanged(default, null):Signal1<IWindowInfo>;
	
	public var availWidth(default, null):Int;
	public var availHeight(default, null):Int;
	
	var window:js.Window;

	public function new() 
	{
		super();
		_sizeListen = true;
		_posListen = true;
		
		availSizeChanged = new Signal1();
		
		window = Lib.window;
		window.onresize = onWindowResized;
		
		setAvailSize(window.screen.availWidth, window.screen.availHeight);
	}
	
	override private function onPosChanged(from:IDisplayPosition):Void {
		if (!Math.isNaN(position.y) && !Math.isNaN(position.x)) {
			window.moveTo(Std.int(position.x), Std.int(position.y));
		}
	}
	override private function onSizeChanged(from:IDisplayPosition):Void {
		if (!Math.isNaN(position.width) && !Math.isNaN(position.height)) {
			window.innerWidth = Std.int(position.width);
			window.innerHeight = Std.int(position.height);
		}
	}
	
	private function setAvailSize(width:Int, height:Int):Void {
		if (this.availWidth != width || this.availHeight != height) {
			this.availWidth = width;
			this.availHeight = height;
			
			LazyInst.exec(availSizeChanged.dispatch(this));
		}
	}
	private function onWindowResized(e:Event):Void {
		setAvailSize(window.screen.availWidth, window.screen.availHeight);
	}
}