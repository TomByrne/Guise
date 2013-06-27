package guise.platform.basisApple.controls;

import guise.controls.data.INumRange;
import guise.platform.basisApple.display.DisplayTrait;
import apple.ui.*;
import basis.object.IObject;

class SliderTrait extends DisplayTrait<UISlider>
{
	@inject
	@:isVar public var range(default, set):INumRange;
	private function set_range(value:INumRange):INumRange {
		if (range!=null) {
			range.rangeChanged.remove(onRangeChanged);
		}
		range = value;
		if (range != null) {
			range.rangeChanged.remove(onRangeChanged);
			onRangeChanged(range);
		}
		return value;
	}

	public function new() 
	{
		_allowSizing = true;
		super(new UISlider());
		view.enabled = true;
		view.addEventListener(UIControl.UIControlValueChanged, onSliderChange);
		this._measWidth = 100;
		this._measHeight = 23;
	}
	private function onSliderChange(object:IObject, type:String):Void {
		if(range!=null){
			range.value = view.value;
		}
	}
	override private function checkMeas():Void {
		//super.checkMeas();
	}
	
	private function onRangeChanged(from:INumRange):Void {
		view.minimumValue = range.min;
		view.maximumValue = range.max;
		view.value = range.value;
	}
}