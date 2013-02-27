package guise.controls.data;

import msignal.Signal;

interface INumRange 
{

	@:isVar public var rangeChanged(get, null):Signal1<INumRange>;
	
	@:isVar public var max(default, null):Float;
	@:isVar public var min(default, null):Float;
	@:isVar public var value(default, set):Float;
	public var valueNorm(get, set):Float;
}

// Default implementation
@:build(LazyInst.check())
class NumRange implements INumRange
{
	@lazyInst public var rangeChanged:Signal1<INumRange>;
	
	@change("rangeChanged")
	public var min(default, null):Float;
	
	@change("rangeChanged")
	public var max(default, null):Float;
	
	@change("rangeChanged")
	public var value(default, set_value):Float;
	private function set_value(value:Float):Float {
		if (enforceRange) {
			if (!Math.isNaN(max) && value > max) {
				value = max;
			}
			if (!Math.isNaN(min) && value < min) {
				value = min;
			}
		}
		
		if (this.value != value) {
			this.value = value;
			_valueNorm = (value-min) / (max - min );
			LazyInst.exec(rangeChanged.dispatch(this));
		}
		return value;
	}
	@change("rangeChanged")
	public var valueNorm(get_valueNorm, set_valueNorm):Float;
	private function get_valueNorm():Float {
		return _valueNorm;
	}
	private function set_valueNorm(value:Float):Float {
		this.value = min+(value*(max-min));
		return valueNorm;
	}
	
	public var enforceRange:Bool = true;
	
	private var _valueNorm:Float;

	public function new(min:Float=0, max:Float=1, value:Float=0) 
	{
		rangeChanged = new Signal1();
		setRange(min, max);
		this.value = value;
	}
	
	public function setRange(min:Float, max:Float):Void {
		if (this.min != min || this.max != max) {
			this.min = min;
			this.max = max;
			LazyInst.exec(rangeChanged.dispatch(this));
		}
	}
	
}