package guise.trans;

/**
 * ...
 * @author Tom Byrne
 */

class UtilFunctions 
{
	public static inline function setProperty(subject:Dynamic, prop:Dynamic, value:Dynamic):Void {
		if (Std.is(prop, Int)) {
			untyped subject[prop] = value;
		}else {
			Reflect.setProperty(subject, prop, value);
		}
	}
	
}