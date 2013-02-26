package guise.platform.waxe.display;

import guise.layout.IBoxPos;
import wx.Button;
import wx.Panel;

import composure.traits.AbstractTrait;
import msignal.Signal;
import guise.platform.cross.display.AbsDisplayTrait;
import wx.Frame;


class WindowTrait extends DisplayTrait<Frame>// implements IWindowInfo
{
	private static var _inst:WindowTrait;
	public static function inst():WindowTrait {
		if (_inst == null) {
			_inst = new WindowTrait();
		}
		return _inst;
	}
	
	/*@lazyInst
	@:isVar public var availSizeChanged(default, null):Signal1<IWindowInfo>;
	
	@:isVar public var availWidth(default, null):Int;
	@:isVar public var availHeight(default, null):Int;*/
	
	private var frame:Frame;

	public function new() 
	{
		super(null);
		_sizeListen = true;
		_posListen = true;
		
		frame = ApplicationMain.frame;
		window = frame;
		
		//window = wx.Panel.create(frame);
		/*window.onresize = onWindowResized;
		
		setAvailSize(window.screen.availWidth, window.screen.availHeight);*/
	}
	
	override private function onPosValid(x:Float, y:Float):Void {
		//window.moveTo(Std.int(x), Std.int(y));
	}
	override private function onSizeValid(w:Float, h:Float):Void {
		//window.innerWidth = Std.int(w);
		//window.innerHeight = Std.int(h);
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