package guise.utils;

/**
 * ...
 * @author Tom Byrne
 */

class Clone 
{
	public static function clone<T>(object:T):T {
		return cloneInline(object);
	}
	public static inline function cloneInline<T>(item:T):T {
		switch(Type.typeof(item)) {
			case TEnum(e):
				return cloneEnum(cast item);
			case TObject:
				return cloneObject(item);
			case TClass(c):
				if (Std.is(item, String)) {
					return item;
				}else {
					return cloneObject(item);
				}
			default:
				return item;
		}
	}
	public static function cloneEnum<T>(enumVal:T, ?paramMask:Array<Dynamic>):T {
		var params:Array<Dynamic> = Type.enumParameters(cast enumVal);
		var cloneParams:Array<Dynamic> = [];
		if(paramMask!=null){
			for (i in 0 ... params.length) {
				var mask:Dynamic = paramMask[i];
				if(mask==MaskValues.CLONE){
					cloneParams.push(clone(params[i]));
				}else {
					cloneParams.push(mask);
				}
			}
		}else {
			for (i in 0 ... params.length) {
				cloneParams.push(clone(params[i]));
			}
		}
		return Type.createEnum(Type.getEnum(cast enumVal), Type.enumConstructor(cast enumVal), cloneParams);
	}
	public static inline function cloneObject<T>(item:T):T {
		var ret;
		#if nme
			if (Std.is(item, nme.display.BitmapData)) return item; // can't clone Bitmaps yet
		else #end if (Std.is(item, Array)) {
			var ret = Type.createInstance(Type.getClass(item), []); 
			untyped { 
				for( ii in 0...item.length ) 
				ret.push(clone(item[ii])); 
			} 
			return ret; 
		}else if ( Type.getClass(item) == null ) {
			var object = cast item;
			
			#if js // js has an issue with typedef cloning
			if (object.iterator != null && object.instanceKeys != null) {
				
				var keys:Array<String> = cast object.instanceKeys();
				var obj : Dynamic = { }; 
				obj.constructor = object.constructor;
				for (i in keys) {
					Reflect.setField(obj, i, clone(Reflect.field(object, i)));
				}
				return obj;
			}else{
			#end
			
			var obj : Dynamic = {}; 
			for( ff in Reflect.fields(object) ) 
				Reflect.setField(obj, ff, clone(Reflect.field(object, ff))); 
			return obj; 
			
			#if js
			}
			#end
		}else{ 
			var object = cast item;
			var obj = Type.createEmptyInstance(Type.getClass(object)); 
			for( ff in Reflect.fields(object) ) 
				Reflect.setProperty(obj, ff, clone(Reflect.field(object, ff))); 
			return obj; 
		}
	}
	
}
enum MaskValues {
	CLONE;
}