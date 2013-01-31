package guise.platform.nme.accessTypes;
import composure.traits.AbstractTrait;
import guise.platform.nme.accessTypes.AdditionalTypes;
import guise.accessTypes.IFilterableAccess;
import nme.display.DisplayObject;
import nme.filters.BitmapFilter;
import nme.filters.DropShadowFilter;
import nme.filters.GlowFilter;

class FilterableAccess extends AbstractTrait, implements IFilterableAccess
{
	
	@injectAdd
	public function onDisplayAdd(access:IDisplayObjectType):Void {
		var display:DisplayObject = access.getDisplayObject();
		if (layerName != null && display.name != layerName) return;
		
		_displayType = access;
		_displayObject = display;
		_displayObject.filters = _lastFilters;
	}
	@injectRemove
	public function onDisplayRemove(access:IDisplayObjectType):Void {
		if (access != _displayType) return;
		
		_displayType = null;
		_displayObject = null;
	}
	
	
	private var _displayType:IDisplayObjectType;
	private var _displayObject:DisplayObject;
	
	private var _lastFilters:Array<BitmapFilter>;
	
	public var layerName(default, set_layerName):String;
	private function set_layerName(value:String):String {
		this.layerName = value;
		return value;
	}

	public function new(?layerName:String) 
	{
		super();
		this.layerName = layerName;
	}
	public function setFilters(?filters:Array<FilterType>):Void {
		var newFilters:Array<BitmapFilter> = [];
		for (i in 0 ... filters.length) {
			var filt:FilterType = filters[i];
			switch(filt) {
				case DropShadow(dist, angle, size, color, alpha, inner):
					var filter:DropShadowFilter = new DropShadowFilter(dist, transAngle(angle,inner), color, alpha, size, size, 1, 1, inner);
					newFilters.push(filter);
				case Glow(size, color, alpha, inner):
					var filter:GlowFilter = new GlowFilter(color, alpha, size, size, 2, 1, inner);
					newFilters.push(filter);
			}
		}
		_lastFilters = newFilters;
		if (_displayObject != null) {
			_displayObject.filters = _lastFilters;
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