package guise.platform.nme.addTypes;
import guise.accessTypes.IVisualAccessType;
import nme.display.DisplayObject;

interface IDisplayObjectType implements IVisualAccessType
{

	public function getDisplayObject():DisplayObject;
	
}