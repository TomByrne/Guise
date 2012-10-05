package guiseSkins.trans;

/**
 * ...
 * @author Tom Byrne
 */

class EnumEaser implements IPropEaser
{
	private static var _pool:Array<EnumEaser>;
	public static function getNew(enumVal:Dynamic, params:Array<Dynamic>, parent:Dynamic, prop:String):EnumEaser {
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
	public var params:Array<Dynamic>;
	public var parent:Dynamic;
	public var prop:String;
	
	private var inited:Bool;
	private var enumType:Enum<Dynamic>;
	private var enumConst:String;

	public function new(enumVal:Dynamic, params:Array<Dynamic>, parent:Dynamic, prop:String) 
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
		inited = false;
	}
	public function update(fract:Float):Void {
		if (!inited) {
			inited = true;
			enumType = Type.getEnum(enumVal);
			enumConst = Type.enumConstructor(enumVal);
		}
		Reflect.setField(parent, prop, Type.createEnum(enumType, enumConst, params));
	}
}