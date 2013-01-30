package guise.accessTypes;

interface IFilterableAccess implements IAccessType {
	function setFilters(?filters:Array<FilterType>):Void;
}
enum FilterType {
	DropShadow(distance:Float, angle:Float, size:Float, color:Int, alpha:Float, ?inner:Bool);
	Glow(size:Float, color:Int, alpha:Float, ?inner:Bool);
}