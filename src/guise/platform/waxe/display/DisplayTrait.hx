package guise.platform.waxe.display;

import composure.traits.AbstractTrait;
import guise.layout.IBoxPos;
import composure.injectors.Injector;
import composure.traitCheckers.TraitTypeChecker;
import guise.meas.IMeasurement;
import wx.EventID;
import wx.Window;
import cmtc.ds.hash.ObjectHash;
import msignal.Signal;

class DisplayTrait<T:Window> extends ContainerTrait, implements IMeasurement{

	@lazyInst
	public var measChanged:Signal1<IMeasurement>;
	
	private var _measWidth:Float;
	public var measWidth(get_measWidth, null):Float;
	private function get_measWidth():Float {
		return _measWidth;
	}
	
	private var _measHeight:Float;
	public var measHeight(get_measHeight, null):Float;
	private function get_measHeight():Float {
		return _measHeight;
	}
	
	
	public var window(default, null):T;
	
	private var _parent:DisplayTrait<Window>;
	private var _allowSizing:Bool;
	private var _creator:Window->T;
	private var _size:Size;
	private var _position:Position;
	private var _executeBundles:ObjectHash<Dynamic, Array<ExecuteBundle>>;

	public function new(creator:Window->T) 
	{
		super();
		_sizeListen = true;
		_posListen = true;
		_creator = creator;
		
		_position = {x:0,y:0};
		
		var injector = new Injector(DisplayTrait, onParentAdded, onParentRemoved, true, false, true);
		injector.stopAscendingAt = TraitTypeChecker.create(DisplayTrait);
		injector.matchTrait = TraitTypeChecker.create(ContainerTrait,true,this);
		addInjector(injector);
	}
	private function onParentAdded(parent:DisplayTrait<Window>):Void {
		if (_parent != null) {
			// parent container has been added between here and existing parent
			onParentRemoved(_parent);
		}
		
		_parent = parent;
		window = _creator(_parent.window);
		if (_executeBundles != null) {
			for (owner in _executeBundles.keys()) {
				var bundles = _executeBundles.get(owner);
				for (bundle in bundles) {
					bundle.add();
				}
			}
		}
		checkMeas();
	}
	private function onParentRemoved(parent:DisplayTrait<Window>):Void {
		if (_parent != parent) return;
		
		if (_executeBundles != null) {
			for (owner in _executeBundles.keys()) {
				var bundles = _executeBundles.get(owner);
				for (bundle in bundles) {
					bundle.remove();
				}
			}
		}
		_parent = null;
		window = null;
	}
	
	override private function setPos(x:Float, y:Float):Void {
		_position.x = Std.int(x);
		_position.y = Std.int(y);
		window.setPosition(_position);
	}
	override private function onSizeValid(w:Float, h:Float):Void {
		if (!_allowSizing) return;
		if (_size == null) {
			_size = {width:0,height:0};
		}
		if (w <= 0 || h <= 0) return; // setting invalid size can irrepairably damage wxWidgets
		
		_size.width = Std.int(w);
		_size.height = Std.int(h);
		window.setSize(_size);
	}
	public function setAllowSizing(value:Bool):Void {
		_allowSizing = value;
		if(position!=null)onSizeChanged(position);
	}
	public function clear(owner:Dynamic):Void {
		if (_executeBundles != null && _executeBundles.exists(owner)) {
			var bundles:Array<ExecuteBundle> = _executeBundles.get(owner);
			if(window!=null){
				for (bundle in bundles) {
					bundle.remove();
				}
			}
			_executeBundles.delete(owner);
		}
	}
	public function on(owner:Dynamic, add:Void->Void, remove:Void->Void):Void {
		var bundle:ExecuteBundle = { owner:owner, add:add, remove:remove };
		if (_executeBundles == null) {
			_executeBundles = new ObjectHash();
		}
		var bundles:Array<ExecuteBundle> = _executeBundles.get(owner);
		if (bundles == null) {
			bundles = [bundle];
			_executeBundles.set(owner, bundles);
		}
		if (window != null) {
			add();
		}
	}
	public function addHandler(owner:Dynamic, event:EventID, handler:Dynamic->Void):Void {
		this.on(owner, function() { this.window.setHandler(event, handler); }, function() { this.window.setHandler(event, null); } );
	}
	
	
	private function checkMeas():Void {
		if (window == null) return;
		var minSize:Size = window.getEffectiveMinSize();
		if (_measWidth != minSize.width || _measHeight != minSize.height) {
			_measWidth = minSize.width;
			_measHeight = minSize.height;
			LazyInst.exec(measChanged.dispatch(this));
		}
	}
	
}
typedef ExecuteBundle = {
	var owner:Dynamic;
	var add:Void->Void;
	var remove:Void->Void;
}