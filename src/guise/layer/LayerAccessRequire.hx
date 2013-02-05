package guise.layer;
import guise.accessTypes.IAccessType;

/**
 * ...
 * @author Tom Byrne
 */

class LayerAccessRequire 
{
	public var layerName:String;
	public var accessTypes:Array<Class<Dynamic>>;

	public function new(?layerName:String, ?accessTypes:Array<Class<Dynamic>>) 
	{
		this.layerName = layerName;
		this.accessTypes = accessTypes;
	}
	
	public function add(type:Class<Dynamic>):Void {
		if (accessTypes == null) accessTypes = [];
		accessTypes.push(type);
	}
}