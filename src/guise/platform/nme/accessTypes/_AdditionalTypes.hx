package guise.platform.nme.accessTypes;
import nme.display.DisplayObject;
import nme.display.InteractiveObject;

class AdditionalTypes{}

interface IDisplayObjectType 
{

	public function getDisplayObject():DisplayObject;
	
}
interface IInteractiveObjectType 
{

	public function getInteractiveObject():InteractiveObject;
	
}