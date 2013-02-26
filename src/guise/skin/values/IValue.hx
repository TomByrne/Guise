package guise.skin.values;
import composure.core.ComposeItem;

import msignal.Signal;

/**
 * ...
 * @author Tom Byrne
 */

interface IValue 
{

	public var currentValue(get, null):Float;
	
	public function update(context:ComposeItem):Array<AnySignal>;
	
}