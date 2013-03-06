package guise.skin.values;
import composure.core.ComposeItem;
import haxe.rtti.Meta;

import msignal.Signal;


class Bind implements IValue
{
	public var currentValue(get_currentValue, null):Float;
	private function get_currentValue():Float {
		return _value;
	}
	
	public var modifier:Float->Float;
	
	private var traitType:Dynamic;
	private var prop:String;
	private var changeSignal:String;
	
	private var _value:Float;

	public function new(traitType:Dynamic, prop:String, ?changeSignal:String, ?modifier:Float->Float) {
		this.traitType = traitType;
		this.prop = prop;
		this.changeSignal = changeSignal;
		this.modifier = modifier;
	}
	
	public function update(context:ComposeItem):Array<AnySignal> {
		var trait:Dynamic = context.getTrait(traitType);
		if (!trait) {
			//throw "No trait of type " + Type.getClassName(traitType) + " was found for style binding";
			return [context.traitAdded];
		}
		_value = Reflect.getProperty(trait, prop);
		if (modifier != null) {
			_value = modifier(_value);
		}
		if (changeSignal == null) {
			changeSignal = getChangeSignalMeta(Type.getClass(trait), prop);
		}
		
		if (changeSignal != null) {
			var trait:Dynamic = context.getTrait(traitType);
			if(trait!=null){
				return [Reflect.getProperty(trait, changeSignal)];
			}
		}
		return null;
		
	}
	private function getChangeSignalMeta(type:Class<Dynamic>, prop:String):Null<String> {
		
		var meta = Meta.getFields(type);
		var fieldMeta = Reflect.getProperty(meta, prop);
		if (fieldMeta!=null && fieldMeta.change!=null) {
			return fieldMeta.change[0];
		}else {
			return getChangeSignalMeta(Type.getSuperClass(type), prop );
		}
	}
}