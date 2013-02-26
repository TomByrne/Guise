package guise.platform.cross;

interface IAccessRequest 
{
	@:isVar public var layerName(default, set):String;
	public function getAccessTypes():Array<Class<Dynamic>>;
	
}