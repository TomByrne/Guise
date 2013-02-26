package guise.skin.values;
import composure.core.ComposeItem;

import msignal.Signal;
/**
 * ...
 * @author Tom Byrne
 */

class Value implements IValue
{
	public var currentValue(get, null):Float;
	private function get_currentValue():Float {
		return value;
	}
	
	public var value(get, set):Float;
	private function get_value():Float {
		return value;
	}
	private function set_value(value:Float):Float {
		this.value = value;
		return value;
	}

	public function new(?value:Float) {
		this.value = value;
	}
	
	public function update(context:ComposeItem):Array<AnySignal> {
		return null;
	}
}