package guise.platform.html5.display;

import js.Browser;
import js.html.Element;

class ContainerTrait extends DisplayTrait
{

	public function new(?domElement:Element) {
		if (domElement == null) {
			domElement = Browser.document.createElement("div");
		}
		super(domElement);
	}
	
}