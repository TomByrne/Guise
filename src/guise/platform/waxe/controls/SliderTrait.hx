package guise.platform.waxe.controls;

import guise.data.INumRange;
import guise.platform.waxe.display.DisplayTrait;
import wx.EventID;
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
		super(function(parent:Window):Slider return Slider.create(parent));
		
		addHandler(this, EventID.SCROLL_CHANGED, onSliderChange);
	}
	private function onSliderChange(e:Dynamic):Void {
		if(range!=null){
			range.value = range.min + (window.value / window.size.width) * (range.max - range.min);
		}
	}
	override private function onParentAdded(parent:DisplayTrait<Window>):Void {
		super.onParentAdded(parent);
		if (range != null) onRangeChanged(range);
	}
	
	private function onRangeChanged(from:INumRange):Void {
		if (window == null) return;
		window.value = Std.int((range.value-range.min)/(range.max-range.min)*window.size.width);
	}
	override private function onSizeValid(w:Float, h:Float):Void {
		super.onSizeValid(w, h);
		window.setRange(0, Std.int(w));
	}
}