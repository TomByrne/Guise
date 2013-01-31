package guiseSkins.styled;
import guise.accessTypes.IFilterableAccess;
import guise.states.StateStyledTrait;
/**
 * ...
 * @author Tom Byrne
 */

class FilterLayer extends StateStyledTrait<Array<FilterType>>
{
	
	@injectAdd
	private function onFilterAdd(access:IFilterableAccess):Void {
		if (_layerName != null && access.layerName != _layerName) return;
		
		_filterable = access;
		invalidate();
	}
	@injectRemove
	private function onFilterRemove(access:IFilterableAccess):Void {
		if (access != _filterable) return;
		
		_filterable = null;
	}
	
	private var _filterable:IFilterableAccess;
	private var _layerName:String;

	public function new(layerName:String, normalStyle:Array<FilterType>=null) 
	{
		super(normalStyle);
		_layerName = layerName;
		
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