package guise.platform.waxe.display;

import guise.core.IWindowInfo;
import guise.platform.waxe.controls.PanelTrait;
import wx.Frame;
import msignal.Signal;
import wx.Panel;
import wx.Window;


class WindowTrait extends DisplayTrait<Frame>, implements IWindowInfo
{
	private static var _inst:WindowTrait;
	public static function inst():WindowTrait {
		if (_inst == null) {
			_inst = new WindowTrait();
		}
		return _inst;
	}
	
	@lazyInst
	public var availSizeChanged:Signal1<IWindowInfo>;
	
	public var availWidth(default, null):Int;
	public var availHeight(default, null):Int;

	public function new() 
	{
		super(null);
		_allowSizing = false;
		_sizeListen = true;
		_posListen = true;
		
		window = ApplicationMain.frame;
		window.onSize = onWindowResized;
		
		setAvailSize(window.size.width, window.size.height);
	}
	
	override private function onPosValid(x:Float, y:Float):Void {
		//window.moveTo(Std.int(x), Std.int(y));
	}
	override private function onSizeValid(w:Float, h:Float):Void {
		//window.innerWidth = Std.int(w);
		//window.innerHeight = Std.int(h);
	}
	
	private function setAvailSize(width:Int, height:Int):Void {
		if (this.availWidth != width || this.availHeight != height) {
			this.availWidth = width;
			this.availHeight = height;
			
			LazyInst.exec(availSizeChanged.dispatch(this));
		}
	}
	private function onWindowResized(e:Dynamic):Void {
		setAvailSize(window.size.width, window.size.height);
	}
}