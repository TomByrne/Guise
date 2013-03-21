package guise.meas;
import msignal.Signal;
#if !macro
import guise.values.ValueUtils;
import composure.traits.AbstractTrait;
import guise.values.IValue;
#else
import haxe.macro.Expr;
import guise.macro.ValueMacro;
#end


interface IMeasurement 
{
	public var measChanged(get_measChanged, null):Signal1<IMeasurement>;
	
	public var measWidth(get_measWidth, null):Float;
	
	public var measHeight(get_measHeight, null):Float;
	
}


// default implementation
class Meas
#if !macro
extends AbstractTrait, implements IMeasurement
#end
{
	#if !macro
	
	@lazyInst
	public var measChanged:Signal1<IMeasurement>;
	
	public var measWidth(get_measWidth, null):Float;
	private function get_measWidth():Float {
		validate();
		return _measWidth;
	}
	
	public var measHeight(get_measHeight, null):Float;
	private function get_measHeight():Float {
		validate();
		return _measHeight;
	}
	
	private var _invalid:Bool;
	
	private var _measWidth:Float;
	private var _measHeight:Float;
	
	private var _valWidth:IValue;
	private var _valHeight:IValue;
	
	private var _sigWidth:Array<AnySignal>;
	private var _sigHeight:Array<AnySignal>;
	
	public function new(?measWidth:Float, ?measHeight:Float) {
		super();
		_sigWidth = [];
		_sigHeight = [];
		set(measWidth, measHeight);
	}
	
	override private function onItemAdd():Void {
		super.onItemAdd();
		//addListeners();
		invalidate();
	}
	override private function onItemRemove():Void {
		super.onItemRemove();
		//removeListeners();
		ValueUtils.clear(_sigHeight, onSignalChange);
		ValueUtils.clear(_sigWidth, onSignalChange);
	}
	/*private function addListeners():Void {
		var doInval:Bool = false;
		if (_valWidth != null) {
			_sigWidth = _valWidth.update(item);
			if(_sigWidth!=null){
				for (signal in _sigWidth) {
					signal.add(onSignalChange);
				}
			}
			doInval = true;
		}
		if (_valHeight != null) {
			_sigHeight = _valWidth.update(item);
			if(_sigHeight!=null){
				for (signal in _sigHeight) {
					signal.add(onSignalChange);
				}
			}
			doInval = true;
		}
		if (doInval) invalidate();
	}
	private function removeListeners():Void{
		if (_sigWidth != null) {
			for (signal in _sigWidth) {
				signal.remove(onSignalChange);
			}
		}
		if (_sigHeight != null) {
			for (signal in _sigHeight) {
				signal.remove(onSignalChange);
			}
		}
	}*/
	private function onSignalChange(?param1:Dynamic, ?param2:Dynamic):Void {
		invalidate();
	}
	
	private function invalidate():Void {
		_invalid = true;
		LazyInst.exec(measChanged.dispatch(this) );
	}
	private function validate():Void {
		if (_invalid) {
			var newWidth:Float;
			//_valWidth.update(item); 
			if (_valWidth != null) {
				if(item!=null)ValueUtils.update(_valWidth, item, _sigWidth, onSignalChange, true);
				newWidth = _valWidth.currentValue;
			}else {
				newWidth = _measWidth;
			}
			var newHeight:Float;
			//_valHeight.update(item);
			if (_valHeight != null) {
				if(item!=null)ValueUtils.update(_valHeight, item, _sigHeight, onSignalChange, true);
				newHeight = _valHeight.currentValue;
			}else {
				newHeight = _measHeight;
			}
			set(newWidth, newHeight);
			_invalid = false;
		}
	}
	
	public function set(measWidth:Float, measHeight:Float):Void {
		if (measWidth != _measWidth || measHeight != _measHeight) {
			_measWidth = measWidth;
			_measHeight = measHeight;
			_invalid = false;
			LazyInst.exec(measChanged.dispatch(this));
		}
	}
	
	public function setValues(widthVal:IValue, heightVal:IValue):Void {
		//removeListeners();
		
		_valWidth = widthVal;
		_valHeight = heightVal;
		
		/*if (item!=null) {
			addListeners();
		}*/
	}
	#end
	
	@:macro public function setVal(thisE:Expr, widthVal:Expr, heightVal:Expr):Expr {
		widthVal = ValueMacro.interpValue(widthVal);
		heightVal = ValueMacro.interpValue(heightVal);
		return macro $thisE.setValues($widthVal, $heightVal);
	}
}

#if !macro
@:build(LazyInst.check())
class SimpleMeas implements IMeasurement {
	
	@lazyInst
	public var measChanged:Signal1<IMeasurement>;
	
	public var measWidth(get_measWidth, null):Float;
	private function get_measWidth():Float {
		return _measWidth;
	}
	
	public var measHeight(get_measHeight, null):Float;
	private function get_measHeight():Float {
		return _measHeight;
	}
	
	private var _measWidth:Float;
	private var _measHeight:Float;
	
	public function new(?measWidth:Float, ?measHeight:Float) {
		set(measWidth, measHeight);
	}
	
	public function set(measWidth:Float, measHeight:Float):Void {
		if (measWidth != _measWidth || measHeight != _measHeight) {
			_measWidth = measWidth;
			_measHeight = measHeight;
			LazyInst.exec(measChanged.dispatch(this));
		}
	}
}
#end