package guiseSkins.styled.values;
import composure.core.ComposeItem;

/**
 * ...
 * @author Tom Byrne
 */

class Value implements IValue
{
	public var currentValue(get_currentValue, null):Float;
	private function get_currentValue():Float {
		return value;
	}
	
	public var value(get_value, set_value):Float;
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
	
	public function update(context:ComposeItem):Void {
		// ignore
	}
}