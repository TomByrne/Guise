package guise.platform.starling.addTypes;
import starling.display.DisplayObject;

interface IDisplayObjectType 
{

	public function getDisplayObject():DisplayObject;
	public function setSize(width:Float, height:Float):Void;
	
}