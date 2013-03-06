package guise.platform.starling.addTypes;
import guise.accessTypes.IVisualAccessType;
import starling.display.DisplayObject;

interface IDisplayObjectType implements IVisualAccessType
{

	public function getDisplayObject():DisplayObject;
	public function setSize(width:Float, height:Float):Void;
	
}