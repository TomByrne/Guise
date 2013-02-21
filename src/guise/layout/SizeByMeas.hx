package guise.layout;
import composure.traits.AbstractTrait;
import guise.meas.IMeasurement;
import msignal.Signal;

class SizeByMeas extends AbstractTrait, implements IBoxPos
{
	@lazyInst
	public var changed:Signal1<IBoxPos>;
	
	@lazyInst
	public var posChanged:Signal1<IBoxPos>;
	
	@lazyInst
	public var sizeChanged:Signal1<IBoxPos>;
	
	@inject
	@:isVar private var measurement(default, set_measurement):IMeasurement;
	private function set_measurement(value:IMeasurement):IMeasurement {
		if (measurement != null) {
			measurement.measChanged.remove(onMeasChanged);
		}
		this.measurement = value;
		if (measurement != null) {
			measurement.measChanged.add(onMeasChanged);
			setSize(measurement.measWidth, measurement.measHeight);
		}
		return value;
	}
	
	public var x(default, null):Float;
	public var y(default, null):Float;
	public var w(default, null):Float;
	public var h(default, null):Float;

	public function new(x:Float=0, y:Float=0) 
	{
		super();
		setPos(x, y);
	}
	
	private function onMeasChanged(from:IMeasurement):Void {
		setSize(from.measWidth, from.measHeight);
	}
	
	public function setPos(x:Float, y:Float):Void {
		if (this.x != x || this.y != y) {
			this.x = x;
			this.y = y;
			LazyInst.exec(posChanged.dispatch(this));
			LazyInst.exec(changed.dispatch(this));
		}
	}
	private function setSize(width:Float, height:Float):Void {
		if (this.w != width || this.h != height) {
			this.w = width;
			this.h = height;
			LazyInst.exec(sizeChanged.dispatch(this));
			LazyInst.exec(changed.dispatch(this));
		}
	}
	
}