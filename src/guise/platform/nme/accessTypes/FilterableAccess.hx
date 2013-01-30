package guise.platform.nme.accessTypes;
import guise.accessTypes.IFilterableAccess;
import nme.display.DisplayObject;
import nme.filters.BitmapFilter;
import nme.filters.DropShadowFilter;
import nme.filters.GlowFilter;

/**
 * ...
 * @author Tom Byrne
 */

class FilterableAccess implements IFilterableAccess
{
	
	public var displayObject(default, set_displayObject):DisplayObject;
	private function set_displayObject(value:DisplayObject):DisplayObject {
		if (displayObject != null) {
			displayObject.filters = null;
		}
		displayObject = value;
		if (displayObject != null) {
			displayObject.filters = _lastFilters;
		}
		return value;
	}
	
	private var _lastFilters:Array<BitmapFilter>;
	//private var _typeToFilt:IntHash<BitmapFilter>;
	
	public var layerName:String;

	public function new(?displayObject:DisplayObject, ?layerName:String) 
	{
		this.layerName = layerName;
		this.displayObject = displayObject;
	}
	public function setFilters(?filters:Array<FilterType>):Void {
		var newFilters:Array<BitmapFilter> = [];
		//var newTypeToFilt = new IntHash<BitmapFilter>();
		//var alphaMulti:Float = getAlphaMulti();
		for (i in 0 ... filters.length) {
			var filt:FilterType = filters[i];
			//var oldFilt:BitmapFilter = _typeToFilt.get(i);
			switch(filt) {
				case DropShadow(dist, angle, size, color, alpha, inner):
					var filter:DropShadowFilter = new DropShadowFilter(dist, transAngle(angle,inner), color, alpha, size, size, 1, 1, inner);
					//newTypeToFilt.set(i, filter);
					newFilters.push(filter);
				case Glow(size, color, alpha, inner):
					var filter:GlowFilter = new GlowFilter(color, alpha, size, size, 2, 1, inner);
					//newTypeToFilt.set(i, filter);
					newFilters.push(filter);
			}
		}
		//_typeToFilt = newTypeToFilt;
		_lastFilters = newFilters;
		if (displayObject != null) {
			displayObject.filters = _lastFilters;
		}
	}
	private inline function transAngle(rads:Float, inner:Bool):Float {
		// for whatever reason, jeash appears to orient it's angles differently to flash
		#if js
			var ang:Float = 90 - (rads * 180 / Math.PI);
			return inner? -ang:ang;
		#else
			return rads * 180 / Math.PI;
		#end
	}
	/*private inline function getAlphaMulti():Float {
		// jeash doesn't really support alpha, so flash should match jeash
		#if js
			return 1;
		#else
			return 2;
		#end
	}*/
	
}