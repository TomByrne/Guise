package guiseSkins.styled;
import guise.platform.types.DisplayAccessTypes;
import guise.platform.PlatformAccessor;
/**
 * ...
 * @author Tom Byrne
 */

class FilterLayer extends AbsStyledLayer<Array<FilterType>>
{
	public var filterAccess(default, set_filterAccess):IFilterableAccess;
	private function set_filterAccess(value:IFilterableAccess):IFilterableAccess {
		_filterable = value;
		if (_filterable != null) {
			invalidate();
		}
		return value;
	}
	
	
	private var _filterable:IFilterableAccess;

	public function new(layerName:String=null, normalStyle:Array<FilterType>=null) 
	{
		super(normalStyle);
		
		//addSiblingTrait(new PlatformAccessor(IFilterableAccess, layerName, onFilterableAdd, onFilterableRemove));
	}
	/*private function onFilterableAdd(access:IFilterableAccess):Void {
		_filterable = access;
		invalidate();
	}
	private function onFilterableRemove(access:IFilterableAccess):Void {
		_filterable.setFilters();
		_filterable = null;
	}*/
	override private function _drawStyle():Void {
		if (_filterable == null) return;
		
		_filterable.setFilters(currentStyle);
	}
	
}