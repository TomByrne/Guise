package guise.platform.html5.controls;
import guise.platform.html5.display.ContainerTrait;
import js.html.Element;

import js.Dom;

class PanelTrait extends ContainerTrait
{

	public function new() 
	{
		super();
		_allowSizing = true;
	}
	
	override private function setDomElement(value:Element):Void {
		super.setDomElement(value);
		value.style.overflow = "auto";
	}
}