package guise.platform.basisApple.controls;
import guise.meas.IMeasurement;
import guise.platform.basisApple.display.DisplayTrait;
import apple.ui.*;


class PanelTrait extends DisplayTrait<UIScrollView>
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
		super(new UIScrollView());
	}
	override private function onParentAdded(parent:DisplayTrait<UIView>):Void {
		super.onParentAdded(parent);
		if (meas != null) onMeasChanged(meas);
	}
	
	private function onMeasChanged(meas:IMeasurement):Void {
		if (view == null) return;
		view.contentSize = [meas.measWidth, meas.measHeight];
		//window.setScrollBars(1, 1, Std.int(meas.measWidth), Std.int(meas.measHeight));
	}
}