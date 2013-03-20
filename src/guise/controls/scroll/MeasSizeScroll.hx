package guise.controls.scroll;

import composure.traits.AbstractTrait;
import guise.controls.scroll.IScrollMetrics;
import guise.layout.IBoxPos;
import guise.meas.IMeasurement;

class MeasSizeScroll extends AbstractTrait
{
	@inject
	private var size(default, set_size):IBoxPos;
	private function set_size(value:IBoxPos):IBoxPos {
		if (this.size!=null) {
			size.sizeChanged.remove(onSizeChanged);
		}
		this.size = value;
		if (this.size!=null) {
			size.sizeChanged.add(onSizeChanged);
			onSizeChanged(size);
		}
		return value;
	}
	
	@inject
	private var meas(default, set_meas):IMeasurement;
	private function set_meas(value:IMeasurement):IMeasurement {
		if (this.meas!=null) {
			meas.measChanged.remove(onMeasChanged);
		}
		this.meas = value;
		if (this.meas!=null) {
			meas.measChanged.add(onMeasChanged);
			onMeasChanged(meas);
		}
		return value;
	}
	
	private var _hScroll:HScrollMetrics;
	private var _vScroll:VScrollMetrics;

	public function new() 
	{
		super();
		_hScroll = new HScrollMetrics();
		_vScroll = new VScrollMetrics();
		
		addSiblingTrait(_hScroll);
		addSiblingTrait(_vScroll);
	}
	
	private function onSizeChanged(from:IBoxPos):Void {
		_hScroll.setPageSize(from.w);
		_vScroll.setPageSize(from.h);
	}
	
	private function onMeasChanged(from:IMeasurement):Void {
		_hScroll.setRange(from.measWidth);
		_vScroll.setRange(from.measHeight);
	}
	
}