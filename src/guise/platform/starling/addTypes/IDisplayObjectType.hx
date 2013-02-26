package guise.platform.starling.addTypes;
import starling.display.DisplayObject;

interface IDisplayObjectType 
{

	@:isVar public var layerName(default, set):String;
	public function getDisplayObject():DisplayObject;
	public function setSize(width:Float, height:Float):Void;
	
}