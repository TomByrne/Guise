package guise.meas;
import guise.values.IValue;
import guise.states.StateStyledTrait;
import msignal.Signal;

class MeasOverride extends StateStyledTrait<MeasMod>, implements IMeasurement
{
	@lazyInst public var measChanged:Signal1<IMeasurement>;
	
	private var _realMeas:IMeasurement;
	private var _measWidth:Float;
	private var _measHeight:Float;
	private var _ignoreChanged:Bool;

	public function new() 
	{
		super();
	}
	
	@injectAdd
	private function addRealMeas(meas:IMeasurement):Void {
		if (_realMeas != null || _ignoreChanged) return;
		
		_ignoreChanged = true;
		_realMeas = meas;
		_realMeas.measChanged.add(onRealMeasChanged);
		item.removeTrait(_realMeas);
		invalidate();
		_ignoreChanged = false;
		
		_realMeas.measChanged.dispatch(_realMeas); // this helps refresh some layouts
	}
	
	@injectRemove
	private function removeRealMeas(meas:IMeasurement):Void {
		if (_realMeas != meas || _ignoreChanged) return;
		
		_ignoreChanged = true;
		item.addTrait(_realMeas);
		_realMeas.measChanged.remove(onRealMeasChanged);
		_realMeas = null;
		_ignoreChanged = false;
	}
	
	private function onRealMeasChanged(meas:IMeasurement):Void {
		invalidate();
	}
	
	
	public var measWidth(get_measWidth, null):Float;
	private function get_measWidth():Float {
		return _measWidth;
	}
	
	public var measHeight(get_measHeight, null):Float;
	private function get_measHeight():Float {
		return _measHeight;
	}
	
	override private function _isReadyToDraw():Bool {
		return _realMeas != null;
	}
	override private function _clearStyle():Void {
		removeValuesByHandler(onMeasValueChanged);
		
		if (_measWidth != _realMeas.measWidth || _measHeight != _realMeas.measHeight) {
			_measWidth = _realMeas.measWidth;
			_measHeight = _realMeas.measHeight;
			LazyInst.exec(measChanged.dispatch(this));
		}
	}
	override private function _drawStyle():Void {
		removeValuesByHandler(onMeasValueChanged);
		
		var style:MeasMod = currentStyle;
		var measW:Float = getMeas(_realMeas.measWidth, style.width);
		var measH:Float = getMeas(_realMeas.measHeight, style.height);
		
		if (measW != _measWidth || measH != _measHeight) {
			_measWidth = measW;
			_measHeight = measH;
			LazyInst.exec(measChanged.dispatch(this));
		}
	}
	private function getMeas(realMeas:Float, mod:DimMod):Float {
		switch(mod) {
			case None:
				return realMeas;
			case Add(val):
				return realMeas + getValue(val, 0, onMeasValueChanged, false);
			case Multiply(val):
				return realMeas * getValue(val, 0, onMeasValueChanged, false);
		}
	}
	private function onMeasValueChanged(?param1:Dynamic, ?param2:Dynamic):Void {
		invalidate();
	}
}
typedef MeasMod = {
	var width:DimMod;
	var height:DimMod;
}
enum DimMod {
	None;
	Add(val:IValue);
	Multiply(val:IValue);
}