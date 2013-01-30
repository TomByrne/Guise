package guise.platform.html.display;
import composure.traits.AbstractTrait;
import guise.platform.cross.display.AbsDisplayTrait;
import guise.layout.IPositionable;
import js.Dom;
import composure.injectors.Injector;
import composure.traitCheckers.TraitTypeChecker;

/**
 * @author Tom Byrne
 */

class DomElementTrait extends AbsDisplayTrait, implements IPositionable
{
	public var domElement(default, null):HtmlDom;
	
	private var _parent:DomContainerTrait;
	private var _allowSizing:Bool;

	public function new(?domElement:HtmlDom) 
	{
		super();
		setDomElement(domElement);
		
		var injector = new Injector(DomContainerTrait, onParentAdded, onParentRemoved, true, false, true);
		injector.stopAscendingAt = TraitTypeChecker.create(DomElementTrait);
		injector.matchTrait = TraitTypeChecker.create(DomContainerTrait,true,this);
		addInjector(injector);
	}
	private function onParentAdded(parent:DomContainerTrait):Void {
		if (_parent != null) return;
		
		_parent = parent;
		if (domElement != null && parent.domElement != null) {
			parent.domElement.appendChild(domElement);
		}
	}
	private function onParentRemoved(parent:DomContainerTrait):Void {
		if (_parent != parent) return;
		
		if(domElement!=null && parent.domElement!=null){
			parent.domElement.removeChild(domElement);
		}
		_parent = null;
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
	public function setAllowSizing(value:Bool):Void {
		_allowSizing = value;
		if(size!=null)sizeChanged();
	}
	private function _setPosition(x:Float, y:Float):Void {
		if (!Math.isNaN(y) && !Math.isNaN(x)) {
			trace("pos: "+x+" "+y+" "+domElement+" "+Type.getClassName(Type.getClass(this)));
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
		if (!_allowSizing) return;
		
		if (!Math.isNaN(w) && !Math.isNaN(h)) {
			domElement.style.width = Std.int(w) + "px";
			domElement.style.height = Std.int(h) + "px";
		}else {
			domElement.style.width = null;
			domElement.style.height = null;
		}
	}
	
}