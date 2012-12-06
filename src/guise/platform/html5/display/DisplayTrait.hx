package guise.platform.html5.display;
import composure.traits.AbstractTrait;
import guise.layout.IDisplayPosition;
import guise.layout.IPositionable;
import js.Dom;
import composure.injectors.Injector;
import composure.traitCheckers.TraitTypeChecker;
import guise.platform.cross.display.AbsDisplayTrait;

/**
 * @author Tom Byrne
 */

class DisplayTrait extends AbsDisplayTrait, implements IPositionable
{
	public var domElement(default, null):HtmlDom;
	
	private var _parent:ContainerTrait;
	private var _allowSizing:Bool;

	public function new(?domElement:HtmlDom) 
	{
		super();
		_sizeListen = true;
		_posListen = true;
		setDomElement(domElement);
		
		var injector = new Injector(ContainerTrait, onParentAdded, onParentRemoved, true, false, true);
		injector.stopAscendingAt = TraitTypeChecker.create(DisplayTrait);
		injector.matchTrait = TraitTypeChecker.create(ContainerTrait,true,this);
		addInjector(injector);
	}
	private function onParentAdded(parent:ContainerTrait):Void {
		if (_parent != null) return;
		
		_parent = parent;
		if (domElement != null && parent.domElement != null) {
			parent.domElement.appendChild(domElement);
		}
	}
	private function onParentRemoved(parent:ContainerTrait):Void {
		if (_parent != parent) return;
		
		if(domElement!=null && parent.domElement!=null){
			parent.domElement.removeChild(domElement);
		}
		_parent = null;
	}
	
	private function setDomElement(value:HtmlDom):Void {
		this.domElement = value;
	}
	override private function onPosChanged(from:IDisplayPosition):Void {
		_setPosition(from.x, from.y);
	}
	override private function onSizeChanged(from:IDisplayPosition):Void {
		_setSize(from.width, from.height);
	}
	public function setPosition(x:Float, y:Float, w:Float, h:Float):Void {
		_setPosition(x, y);
		_setSize(w, h);
	}
	public function setAllowSizing(value:Bool):Void {
		_allowSizing = value;
		if(position!=null)onSizeChanged(position);
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