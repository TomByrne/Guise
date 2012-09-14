package guiseSkins.trans;

/**
 * ...
 * @author Tom Byrne
 */

class PropEaser implements IPropEaser {
	private static var _pool:Array<PropEaser>;
	public static function getNew(subject:Dynamic, prop:Dynamic, start:Float, end:Float):PropEaser {
		if (_pool == null) {
			_pool = [];
			return new PropEaser(subject, prop, start, end);
		}else if (_pool.length>0) {
			var ret =  _pool.pop();
			ret.subject = subject;
			ret.prop = prop;
			ret.start = start;
			ret.end = end;
			return ret;
		}else {
			return new PropEaser(subject, prop, start, end);
		}
	}
	
	public var subject:Dynamic;
	public var prop:Dynamic;
	public var start:Float;
	public var end:Float;
	
	public var inited:Bool;
	public var diff:Float;
	
	public function new(subject:Dynamic, prop:Dynamic, start:Float, end:Float) {
		this.subject = subject;
		this.prop = prop;
		this.start = start;
		this.end = end;
		inited = false;
	}
	public function release():Void {
		subject = null;
		_pool.push(this);
		inited = false;
	}
	public function update(fract:Float):Void {
		if (!inited) {
			inited = true;
			diff = end - start;
		}
		var newValue:Float = start + diff * fract;
		UtilFunctions.setProperty(subject, prop, newValue);
	}
}