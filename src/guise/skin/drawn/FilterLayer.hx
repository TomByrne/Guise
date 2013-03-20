package guise.skin.drawn;
import guise.accessTypes.IFilterableAccess;
import guise.platform.cross.IAccessRequest;
import guise.states.StateStyledTrait;

class FilterLayer extends StateStyledTrait<Array<FilterType>> implements IAccessRequest
{
	private static var ACCESS_TYPES:Array<Class<Dynamic>> = [IFilterableAccess];
	
	@injectAdd
	private function onFilterAdd(access:IFilterableAccess):Void {
		if (layerName != null && access.layerName != layerName) return;
		
		_filterable = access;
		invalidate();
	}
	@injectRemove
	private function onFilterRemove(access:IFilterableAccess):Void {
		if (access != _filterable) return;
		
		_filterable = null;
	}
	
	@:isVar public var layerName(default, set):String;
	private function set_layerName(value:String):String {
		this.layerName = value;
		return value;
	}
	
	private var _filterable:IFilterableAccess;

	public function new(?layerName:String, normalStyle:Array<FilterType>=null) 
	{
		super(normalStyle);
		this.layerName = layerName;
		
	}
	public function getAccessTypes():Array<Class<Dynamic>> {
		return ACCESS_TYPES;
	}
	override private function _isReadyToDraw():Bool {
		return super._isReadyToDraw() && _filterable != null;
	}
	override private function _clearStyle():Void {
		_filterable.setFilters(null);
	}
	override private function _drawStyle():Void {
		_filterable.setFilters(currentStyle);
	}
	
}