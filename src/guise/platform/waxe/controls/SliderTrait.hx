package guise.platform.waxe.controls;

import guise.controls.data.INumRange;
import guise.platform.waxe.display.DisplayTrait;
import wx.Window;
import wx.Slider;

class SliderTrait extends DisplayTrait<Slider>
{
	@inject
	public var range(default, set_range):INumRange;
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
		/*_slider = cast Lib.document.createElement("input");
		_slider.setAttribute("type", "range");
		_slider.onchange = onSliderChange;*/
		super(function(parent:Window):Slider return Slider.create(parent));
	}
	/*private function onSliderChange(e:Event):Void {
		if(range!=null){
			range.value = Std.parseFloat(_slider.value);
		}
	}*/
	
	private function onRangeChanged(from:INumRange):Void {
		//_slider.setAttribute("min", Std.string(range.min));
		//_slider.setAttribute("max", Std.string(range.max));
		//_slider.setAttribute("value", Std.string(range.value));
		setIncrements();
	}
	/*override private function _setSize(w:Float, h:Float):Void {
		super._setSize(w, h);
		setIncrements();
	}*/
	private function setIncrements():Void {
		if (range == null || position == null) return;
		
		var incr:Float = (range.max - range.min) / position.w;
		//_slider.setAttribute("step", Std.string(incr));
	}
}