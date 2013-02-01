package guise.skin.values;
import composure.core.ComposeItem;

import msignal.Signal;
/**
 * ...
 * @author Tom Byrne
 */

class Calc implements IValue
{
	public var currentValue(get_currentValue, null):Float;
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
		
		switch(operator) {
			case Add:
				_value = 0;
				for (value in values) {
					_value += value.currentValue;
				}
			case Multiply:
				_value = values[0].currentValue;
				for (i in 1...values.length) {
					var value = values[i].currentValue;
					_value *= value;
				}
			case Max:
				_value = values[0].currentValue;
				for (i in 1...values.length) {
					var value = values[i].currentValue;
					if (value > _value)_value = value;
				}
			case Min:
				_value = values[0].currentValue;
				for (i in 1...values.length) {
					var value = values[i].currentValue;
					if (value < _value)_value = value;
				}
		}
		return ret;
	}
}

enum Operator {
	Add;
	Multiply;
	Max;
	Min;
}