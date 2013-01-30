package guise.controls.logic.input;
import guise.controls.data.IClick;
import guise.traits.core.IActive;
import composure.traits.AbstractTrait;
import msignal.Signal;
import guise.accessTypes.IMouseClickableAccess;


class ButtonClickTrait extends AbstractTrait, implements IClick 
{
	@inject
	public var active(default, set_active):IActive;
	public function set_active(value:IActive):IActive {
		this.active = value;
		return value;
	}
	
	@lazyInst
	public var clicked(default, null):Signal1<IClick>;
	
	private var _mouseClickable:IMouseClickableAccess;
	private var _clickTypeBundles:Array<ClickTypeBundle>;
	private var _layerName:String;

	public function new(?layerName:String) 
	{
		super();
		_layerName = layerName;
		_clickTypeBundles = new Array<ClickTypeBundle>();
		//addSiblingTrait(new PlatformAccessor(IMouseClickableAccess, layerName, onMouseClickAdd, onMouseClickRemove));
	}
	@injectAdd
	private function onMouseClickAdd(access:IMouseClickableAccess):Void {
		if (_layerName != null && access.layerName != _layerName) return;
		
		_mouseClickable = access;
		_mouseClickable.clicked.add(onClicked);
		_mouseClickable.doubleClicked.add(onDoubleClicked);
	}
	@injectRemove
	private function onMouseClickRemove(access:IMouseClickableAccess):Void {
		if (access != _mouseClickable) return;
		
		_mouseClickable.clicked.remove(onClicked);
		_mouseClickable.doubleClicked.remove(onDoubleClicked);
		_mouseClickable = null;
	}
	
	public function bindToClick(handler:ButtonClickTrait->Void, clickType:ClickType):Void {
		var bundle:ClickTypeBundle = findBundle(clickType);
		if (bundle == null) {
			bundle = new ClickTypeBundle(this, clickType);
			_clickTypeBundles.push(bundle);
		}
		bundle.signaler.add(handler);
	}
	public function unbindFromClick(handler:ButtonClickTrait->Void, clickType:ClickType):Void {
		var bundle:ClickTypeBundle = findBundle(clickType);
		if (bundle != null) {
			bundle.signaler.remove(handler);
		}
	}
	private function findBundle(clickType:ClickType):ClickTypeBundle {
		for (bundle in _clickTypeBundles) {
			if (bundle.clickType == clickType) {
				return bundle;
			}
		}
		return null;
	}
	
	private function onClicked(info:ClickInfo):Void {
		if (active != null && !active.active) return;
		
		for (bundle in _clickTypeBundles) {
			switch(bundle.clickType) {
				case LeftClick:
					LazyInst.exec(clicked.dispatch(this));
					if(info.left)dispatchBundle(bundle);
				case RightClick:
					if(!info.left)dispatchBundle(bundle);
				case Advanced(left, double, alt, ctrl, shift):
					if (!double && info.left == left && (alt==null || alt==info.altHeld) && (ctrl==null || ctrl==info.ctrlHeld) && (shift==null || shift==info.shiftHeld)) {
						dispatchBundle(bundle);
					}
				default:
					// ignore	
			}
		}
	}
	private function onDoubleClicked(info:ClickInfo):Void {
		if (active != null && !active.active) return;
		
		for (bundle in _clickTypeBundles) {
			switch(bundle.clickType) {
				case DoubleLeftClick:
					if(info.left)dispatchBundle(bundle);
				case Advanced(left, double, alt, ctrl, shift):
					if (double && info.left == left && (alt==null || alt==info.altHeld) && (ctrl==null || ctrl==info.ctrlHeld) && (shift==null || shift==info.shiftHeld)) {
						dispatchBundle(bundle);
					}
				default:
					// ignore	
			}
		}
	}
	private function dispatchBundle(bundle:ClickTypeBundle):Void {
		bundle.signaler.dispatch(this);
	}
}
enum ClickType {
	LeftClick;
	RightClick;
	DoubleLeftClick;
	Advanced(left:Bool, double:Bool, alt:Null<Bool>, ctrl:Null<Bool>, shift:Null<Bool>);
}
class ClickTypeBundle {
	public var clickType:ClickType;
	public var signaler:Signal1<ButtonClickTrait>;
	
	public function new(owner:ButtonClickTrait, clickType:ClickType) {
		this.clickType = clickType;
		this.signaler = new Signal1();
	}
}