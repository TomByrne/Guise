package guise.trans;

/**
 * ...
 * @author Tom Byrne
 */


class ColorEaser implements IPropEaser {
	private static var _pool:Array<ColorEaser>;
	public static function getNew(subject:Dynamic, prop:Dynamic, start:Int, end:Int):ColorEaser {
		if (_pool == null) {
			_pool = [];
			return new ColorEaser(subject, prop, start, end);
		}else if (_pool.length>0) {
			var ret =  _pool.pop();
			ret.subject = subject;
			ret.prop = prop;
			ret.start = start;
			ret.end = end;
			return ret;
		}else {
			return new ColorEaser(subject, prop, start, end);
		}
	}
	
	public var subject:Dynamic;
	public var prop:Dynamic;
	public var start:Int;
	public var end:Int;
	
	public var inited:Bool;
	
	public var startR:Int;
	public var startG:Int;
	public var startB:Int;
	
	public var diffR:Int;
	public var diffG:Int;
	public var diffB:Int;
	
	public function new(subject:Dynamic, prop:Dynamic, start:Int, end:Int) {
		this.subject = subject;
		this.prop = prop;
		this.start = start;
		this.end = end;
	}
	public function release():Void {
		subject = null;
		_pool.push(this);
		inited = false;
	}
	public function update(fract:Float):Void {
		if (!inited) {
			inited = true;
			
			startR = (( start >> 16 ) & 0xFF);
			startG = (( start >> 8 ) & 0xFF);
			startB = (( start ) & 0xFF);
			
			diffR = (( end >> 16 ) & 0xFF)-startR;
			diffG = (( end >> 8 ) & 0xFF)-startG;
			diffB = (( end ) & 0xFF)-startB;
		}
		var newR:Int = Std.int(startR + diffR * fract);
		var newG:Int = Std.int(startG + diffG * fract);
		var newB:Int = Std.int(startB + diffB * fract);
		var newValue:Int = ( ( newR << 16 ) | ( newG << 8 ) | newB );
		UtilFunctions.setProperty(subject, prop, newValue);
	}
}