package guise.platform.waxe.controls;
import guise.meas.IMeasurement;
import guise.platform.waxe.display.DisplayTrait;
import wx.ScrolledWindow;
import wx.Window;


class PanelTrait extends DisplayTrait<ScrolledWindow>
{
	@inject
	@:isVar public var meas(default, set_meas):IMeasurement;
	private function set_meas(value:IMeasurement):IMeasurement {
		if (this.meas != null) {
			this.meas.measChanged.remove(onMeasChanged);
		}
		this.meas = value;
		if (this.meas != null) {
			this.meas.measChanged.remove(onMeasChanged);
			onMeasChanged(meas);
		}
		return value;
	}
	
	public function new() 
	{
		_allowSizing = true;
		super(function(parent:Window):ScrolledWindow return ScrolledWindow.create(parent));
	}
	override private function onParentAdded(parent:DisplayTrait<Window>):Void {
		super.onParentAdded(parent);
		if (meas != null) onMeasChanged(meas);
	}
	
	private function onMeasChanged(meas:IMeasurement):Void {
		if (window == null) return;
		window.setScrollBars(1, 1, Std.int(meas.measWidth), Std.int(meas.measHeight));
	}
}