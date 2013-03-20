package guise.skin.values;
import composure.core.ComposeItem;

import msignal.Signal;


class Calc implements IValue
{
	public var currentValue(get, null):Float;
	private function get_currentValue():Float{
		return _value;
	}
	private var _value:Float;
	
	public var values:Array<IValue>;
	public var operator:Operator;
	

	public function new(?operator:Operator, ?values:Array<IValue>) 
	{
		this.values = values;
		this.operator = operator;
	}
	
	public function update(context:ComposeItem):Array<AnySignal> {
		var ret:Array<AnySignal> = null;
		
		for (value in values) {
			var childSignals:Array<AnySignal> = value.update(context);
			if (childSignals!=null) {
				if (ret==null) {
					ret = childSignals;
				}else {
					ret = ret.concat(childSignals);
				}
			}
		}
		
		_value = values[0].currentValue;
		switch(operator) {
			case Add:
				for (i in 1...values.length) {
					var value = values[i].currentValue;
					if (Math.isNaN(value)) continue;
					_value += value;
				}
			case Subtract:
				for (i in 1...values.length) {
					var value = values[i].currentValue;
					if (Math.isNaN(value)) continue;
					_value -= value;
				}
			case Multiply:
				for (i in 1...values.length) {
					var value = values[i].currentValue;
					if (Math.isNaN(value)) continue;
					_value *= value;
				}
			case Divide:
				for (i in 1...values.length) {
					var value = values[i].currentValue;
					if (Math.isNaN(value)) continue;
					_value /= value;
				}
			case Max:
				for (i in 1...values.length) {
					var value = values[i].currentValue;
					if (Math.isNaN(value)) continue;
					if (Math.isNaN(_value) || value > _value)_value = value;
				}
			case Min:
				for (i in 1...values.length) {
					var value = values[i].currentValue;
					if (Math.isNaN(value)) continue;
					if (Math.isNaN(_value) || value < _value)_value = value;
				}
		}
		return ret;
	}
}

enum Operator {
	Add;
	Subtract;
	Multiply;
	Divide;
	Max;
	Min;
}