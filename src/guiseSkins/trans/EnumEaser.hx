package guiseSkins.trans;

/**
 * ...
 * @author Tom Byrne
 */

class EnumEaser extends PropEaser
{
	private static var _pool:Array<EnumEaser>;
	public static function getNew(enumVal:Enum, params:Array, parent:Dynamic, prop:String):EnumEaser {
		if (_pool == null) {
			_pool = [];
			return new EnumEaser(enumVal, params, parent, prop);
		}else if (_pool.length>0) {
			var ret =  _pool.pop();
			ret.enumVal = enumVal;
			ret.params = params;
			ret.parent = parent;
			ret.prop = prop;
			return ret;
		}else {
			return new EnumEaser(enumVal, params, parent, prop);
		}
	}
	
	public var enumVal:Dynamic;
	public var params:Array;
	public var parent:Dynamic;
	public var prop:String;

	public function new(enumVal:Dynamic, params:Array, parent:Dynamic, prop:String) 
	{
		this.enumVal = enumVal;
		this.params = params;
		this.parent = parent;
		this.prop = prop;
	}
	
	public function release():Void {
		parent = null;
		enumVal = null;
		_pool.push(this);
	}
	public function update(fract:Float):Void {
		Reflect.setField(Type.createEnum(Type.getEnum(enumVal), Type.enumConstructor(enumVal), params);
	}
}