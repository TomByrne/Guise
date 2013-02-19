package guise.layer;
import guise.accessTypes.IAccessType;
import guise.platform.cross.IAccessRequest;


class LayerAccessRequire implements IAccessRequest
{
	@:isVar public var layerName(default, set_layerName):String;
	private function set_layerName(value:String):String {
		this.layerName = value;
		return value;
	}
	
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
	
	public function getAccessTypes():Array<Class<Dynamic>> {
		return accessTypes;
	}
}