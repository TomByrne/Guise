package guise.skin.values;
import composure.core.ComposeItem;

import msignal.Signal;
/**
 * ...
 * @author Tom Byrne
 */

class Bind implements IValue
{
	public var currentValue(get_currentValue, null):Float;
	private function get_currentValue():Float {
		return _value;
	}
	
	private var traitType:Dynamic;
	private var prop:String;
	private var changeSignal:String;
	
	private var _value:Float;

	public function new(traitType:Dynamic, prop:String, changeSignal:String=null) {
		this.traitType = traitType;
		this.prop = prop;
		this.changeSignal = changeSignal;
	}
	
	public function update(context:ComposeItem):Array<AnySignal> {
		var trait:Dynamic = context.getTrait(traitType);
		if (!trait) {
			throw "No trait of type " + Type.getClassName(traitType) + " was found for style binding";
		}
		_value = Reflect.getProperty(trait, prop);
		
		if (changeSignal != null) {
			var trait:Dynamic = context.getTrait(traitType);
			if(trait!=null){
				return [Reflect.getProperty(trait, changeSignal)];
			}
		}
		return null;
		
	}
}