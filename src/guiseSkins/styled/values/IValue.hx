package guiseSkins.styled.values;
import composure.core.ComposeItem;

/**
 * ...
 * @author Tom Byrne
 */

interface IValue 
{

	public var currentValue(get_currentValue, null):Float;
	public function update(context:ComposeItem):Void;
	
}