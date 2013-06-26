package guise.platform.basisApple.display;

import composure.traits.AbstractTrait;
import guise.platform.cross.display.ContainerTrait;
import guise.layout.IBoxPos;
import composure.injectors.Injector;
import composure.traitCheckers.TraitTypeChecker;
import guise.meas.IMeasurement;
import apple.ui.UIView;

import msignal.Signal;

class DisplayTrait<T:UIView> extends ContainerTrait implements IMeasurement{

	@lazyInst
	public var measChanged:Signal1<IMeasurement>;
	
	private var _measWidth:Float;
	public var measWidth(get, null):Float;
	private function get_measWidth():Float {
		return _measWidth;
	}
	
	private var _measHeight:Float;
	public var measHeight(get, null):Float;
	private function get_measHeight():Float {
		return _measHeight;
	}
	
	
	@:isVar public var view(default, null):T;
	
	private var _parent:DisplayTrait<UIView>;
	private var _allowSizing:Bool;
	private var _frame:Array<Float>;
	private var _executeBundles:Map<AbstractTrait, Array<ExecuteBundle>>;

	public function new(?view:T) 
	{
		super();
		_sizeListen = true;
		_posListen = true;
		_frame = new Array<Float>();

		this.view = view;
		
		var injector = new Injector(DisplayTrait, onParentAdded, onParentRemoved, true, false, true);
		injector.stopAscendingAt = TraitTypeChecker.create(DisplayTrait);
		injector.matchTrait = TraitTypeChecker.create(ContainerTrait,true,this);
		addInjector(injector);
	}
	private function onParentAdded(parent:DisplayTrait<UIView>):Void {
		if (_parent != null) {
			// parent container has been added between here and existing parent
			onParentRemoved(_parent);
		}
		_parent = parent;
		_parent.view.addSubview(view);
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
	private function onParentRemoved(parent:DisplayTrait<UIView>):Void {
		if (_parent != parent) return;
		
		if (_executeBundles != null) {
			for (owner in _executeBundles.keys()) {
				var bundles = _executeBundles.get(owner);
				for (bundle in bundles) {
					bundle.remove();
				}
			}
		}
		view.removeFromSuperview();
		_parent = null;
	}
	private function rebuildWindow():Void {
		if (_parent == null) return;
		var parent = _parent;
		onParentRemoved(parent);
		onParentAdded(parent);
	}

	override private function onPosOrSizeChanged(x:Float, y:Float, w:Float, h:Float):Void {
		_frame[0] = x;
		_frame[1] = y;
		_frame[2] = w;
		_frame[3] = h;
		view.frame = _frame;
	}
	
	public function setAllowSizing(value:Bool):Void {
		_allowSizing = value;
		if(position!=null)onSizeChanged(position);
	}
	public function clear(owner:Dynamic):Void {
		if (_executeBundles != null && _executeBundles.exists(owner)) {
			var bundles:Array<ExecuteBundle> = _executeBundles.get(owner);
			if(view!=null){
				for (bundle in bundles) {
					bundle.remove();
				}
			}
			_executeBundles.remove(owner);
		}
	}
	public function on(owner:AbstractTrait, add:Void->Void, remove:Void->Void):Void {
		var bundle:ExecuteBundle = { owner:owner, add:add, remove:remove };
		if (_executeBundles == null) {
			_executeBundles = new Map< AbstractTrait, Array<ExecuteBundle>>();
		}
		var bundles:Array<ExecuteBundle> = _executeBundles.get(owner);
		if (bundles == null) {
			bundles = [bundle];
			_executeBundles.set(owner, bundles);
		}
		if (view != null) {
			add();
		}
	}
	/*public function addHandler(owner:AbstractTrait, event:EventID, handler:Dynamic->Void):Void {
		this.on(owner, function() { this.view.setHandler(event, handler); }, function() { this.view.setHandler(event, null); } );
	}*/
	
	
	private function checkMeas():Void {
		if (view == null) return;
		var minSize:Array<Float> = view.intrinsicContentSize();
		if (_measWidth != minSize[0] || _measHeight != minSize[1]) {
			_measWidth = minSize[0];
			_measHeight = minSize[1];
			LazyInst.exec(measChanged.dispatch(this));
		}
	}
	
}
typedef ExecuteBundle = {
	var owner:Dynamic;
	var add:Void->Void;
	var remove:Void->Void;
}