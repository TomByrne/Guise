package guise.platform.basisApple.display;

import msignal.Signal;
import apple.ui.*;
import apple.quartzcore.CALayer;

#if ios
import basis.ios.IOSApplication;
#elseif osx
import basis.osx.OSXApplication;
#end


class WindowTrait extends DisplayTrait<UIView>// implements IWindowInfo
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

	public function new() 
	{
		view = new UIView();
		super(view);


		_sizeListen = false;
		_posListen = false;
		IOSApplication.instance.addToRootView(view);

		
		view.autoresizingMask = UIView.UIViewAutoresizingFlexibleLeftMargin | UIView.UIViewAutoresizingFlexibleWidth | 
							UIView.UIViewAutoresizingFlexibleRightMargin | UIView.UIViewAutoresizingFlexibleTopMargin | UIView.UIViewAutoresizingFlexibleHeight | 
							UIView.UIViewAutoresizingFlexibleBottomMargin;

		view.frame = UIScreen.getApplicationFrame();

		/*var scroll = new UIScrollView();
		scroll.frame = [0,0,200,500];
		view.addSubview(scroll);
		
		
		var _inputLabel = new UILabel();
		scroll.addSubview(_inputLabel);
		_inputLabel.text  = "Input";
		_inputLabel.frame = [5.0, 60, 200, 30];

		var _sampleButton:UIButton = UIButton.buttonWithType(UIButton.UIButtonTypeRoundedRect);
		_sampleButton.frame = [50.0,220,100,30];
		_sampleButton.setTitleForState("Button", UIControl.UIControlStateNormal);
		scroll.addSubview(_sampleButton);*/

		
		//window = wx.Panel.create(frame);
		/*window.onresize = onWindowResized;
		
		setAvailSize(window.screen.availWidth, window.screen.availHeight);*/
	}
	
	/*override private function onPosValid(x:Float, y:Float):Void {
		//window.moveTo(Std.int(x), Std.int(y));
	}
	override private function onSizeValid(w:Float, h:Float):Void {
		//window.innerWidth = Std.int(w);
		//window.innerHeight = Std.int(h);
	}*/
	
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