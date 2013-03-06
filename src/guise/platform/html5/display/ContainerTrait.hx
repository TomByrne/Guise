package guise.platform.html5.display;
import js.Dom;
import js.Lib;


class ContainerTrait extends DisplayTrait
{

	public function new(?domElement:HtmlDom) {
		if (domElement == null) {
			domElement = Lib.document.createElement("div");
		}
		super(domElement);
	}
	
}