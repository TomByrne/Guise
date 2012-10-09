package guise.platform.waxe.display;
import guise.platform.waxe.IDisplayAwareTrait;
import wx.Window;
import composure.traits.AbstractTrait;
import guise.core.AbsPosSizeAwareTrait;
import guise.layout.IPositionable;
import composure.injectors.Injector;
import composure.traitCheckers.TraitTypeChecker;

import msignal.Signal;

/**
 * @author Tom Byrne
 */

class DisplayTrait extends AbsPosSizeAwareTrait, implements IPositionable
{
	

	@lazyInst
	public var displayChanged:Signal1<DisplayTrait>;
	
	
	public var displayFactory(default, set_displayFactory):DisplayFactory;
	private function set_displayFactory(value:DisplayFactory):DisplayFactory {
		if (display!=null) destroyDisplay();
		displayFactory = value;
		if (_parent.display!=null && displayFactory != null) buildDisplay();
	}
	
	
	public var display(default, null):Window;
	
	private var _parent:ContainerTrait;
	private var _allowSizing:Bool;
	private var _displayAware:Array<IDisplayAwareTrait>;

	public function new() 
	{
		trace("DisplayTrait");
		super();
		
		displayFactory = Window.create;
		
		var injector = new Injector(ContainerTrait, onParentAdded, onParentRemoved, true, false, true);
		injector.stopAscendingAt = TraitTypeChecker.create(DisplayTrait);
		injector.matchTrait = TraitTypeChecker.create(ContainerTrait,true,this);
		addInjector(injector);
	}
	private function onParentAdded(parent:ContainerTrait):Void {
		if (_parent != null) return;
		
		_parent = parent;
		_parent.displayChanged.add(onParentDisplayChanged);
		onParentDisplayChanged(_parent);
	}
	private function onParentRemoved(parent:ContainerTrait):Void {
		if (_parent != parent) return;
		
		_parent = null;
		_parent.displayChanged.remove(onParentDisplayChanged);
		if(display!=null)destroyDisplay();
	}
	public function addDisplayAware(displayAware:IDisplayAwareTrait):Void {
		if (_displayAware == null)_displayAware = [];
		_displayAware.push(displayAware);
		if (display != null) displayAware.displaySet(this);
	}
	public function removeDisplayAware(displayAware:IDisplayAwareTrait):Void {
		if (display != null) displayAware.displayClear(this);
		_displayAware.remove(displayAware);
	}
	
	private function onParentDisplayChanged(from:DisplayTrait):Void {
		if (display != null) destroyDisplay();
		if (_parent.display!=null && displayFactory != null) buildDisplay();
	}
	private function destroyDisplay():Void {
		display.destroy();
		setDisplay(null);
	}
	private function buildDisplay():Void {
		setDisplay(createDisplay() );
	}
	private function createDisplay():Window {
		return Window.create(_parent.display);
	}
	
	private function setDisplay(value:Window):Void {
		trace("setDisplay: "+value+" "+(display != value));
		if (this.display != value) return;
		
		this.display = value;
		LazyInst.exec(displayChanged.dispatch(this));
		
		if (_displayAware != null) {
			if (display != null) {
				for (displayAware in _displayAware) displayAware.displaySet(this);
			}else {
				for (displayAware in _displayAware) displayAware.displayClear(this);
			}
		}
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
		/*if (!Math.isNaN(y) && !Math.isNaN(x)) {
			trace("pos: "+x+" "+y+" "+domElement+" "+Type.getClassName(Type.getClass(this)));
			domElement.style.position = "absolute";
			domElement.style.top = Std.int(y) + "px";
			domElement.style.left = Std.int(x) + "px";
		}else {
			domElement.style.position = "static";
			domElement.style.top = null;
			domElement.style.left = null;
		}*/
	}
	private function _setSize(w:Float, h:Float):Void {
		/*if (!_allowSizing) return;
		
		if (!Math.isNaN(w) && !Math.isNaN(h)) {
			domElement.style.width = Std.int(w) + "px";
			domElement.style.height = Std.int(h) + "px";
		}else {
			domElement.style.width = null;
			domElement.style.height = null;
		}*/
	}
	
}

// Should be Window->Window
typedef DisplayFactory = Dynamic;