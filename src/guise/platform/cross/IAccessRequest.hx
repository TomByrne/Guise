package guise.platform.cross;

interface IAccessRequest 
{
	public var layerName(default, set_layerName):String;
	public function getAccessTypes():Array<Class<Dynamic>>;
	
}