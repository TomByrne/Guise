package guiseSkins.trans;

/**
 * ...
 * @author Tom Byrne
 */


class PropSetter implements IPropEaser{
	private static var _pool:Array<PropSetter>;
	public static function getNew(subject:Dynamic, prop:Dynamic, value:Dynamic):PropSetter {
		if (_pool == null) {
			_pool = [];
			return new PropSetter(subject, prop, value);
		}else if (_pool.length>0) {
			var ret = _pool.pop();
			ret.subject = subject;
			ret.prop = prop;
			ret.value = value;
			return ret;
		}else {
			return new PropSetter(subject, prop, value);
		}
	}
	
	public var subject:Dynamic;
	public var prop:Dynamic;
	public var value:Dynamic;
	
	public function new(subject:Dynamic, prop:Dynamic, value:Dynamic) {
		this.subject = subject;
		this.prop = prop;
		this.value = value;
	}
	public function release():Void {
		subject = null;
		value = null;
		_pool.push(this);
	}
	public function update(fract:Float):Void {
		UtilFunctions.setProperty(subject, prop, value);
	}
}