package guise.platform.html.display;
import composure.traits.AbstractTrait;
import guise.core.AbsPosSizeAwareTrait;
import guise.layout.IPositionable;
import js.Dom;

/**
 * @author Tom Byrne
 */

class DomElementSkin extends AbsPosSizeAwareTrait, implements IPositionable
{
	public var domElement(default, null):HtmlDom;

	public function new(?domElement:HtmlDom) 
	{
		super();
		setDomElement(domElement);
	}
	
	private function setDomElement(value:HtmlDom):Void {
		this.domElement = value;
	}
	override private function posChanged():Void {
		_setPosition(position.x, position.y);
	}
	override private function sizeChanged():Void {
		_setSize(size.width, size.height);
	}
	public function setPosition(x:Float, y:Float, w:Float, h:Float):Void {
		_setPosition(x, y);
		_setSize(w, h);
	}
	private function _setPosition(x:Float, y:Float):Void {
		if (!Math.isNaN(y) && !Math.isNaN(x)) {
			domElement.style.position = "absolute";
			domElement.style.top = Std.int(y) + "px";
			domElement.style.left = Std.int(x) + "px";
		}else {
			domElement.style.position = "static";
			domElement.style.top = null;
			domElement.style.left = null;
		}
	}
	private function _setSize(w:Float, h:Float):Void {
		if (!Math.isNaN(w) && !Math.isNaN(h)) {
			untyped{
				domElement.width = Std.int(w);
				domElement.height = Std.int(h);
			}
		}else {
			untyped{
				domElement.width = null;
				domElement.height = null;
			}
		}
	}
	
}