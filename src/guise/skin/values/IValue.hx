package guise.skin.values;
import composure.core.ComposeItem;
import nme.Vector;

import msignal.Signal;

/**
 * ...
 * @author Tom Byrne
 */

interface IValue 
{

	public var currentValue(get_currentValue, null):Float;
	
	public function update(context:ComposeItem):Array<AnySignal>;
	
}