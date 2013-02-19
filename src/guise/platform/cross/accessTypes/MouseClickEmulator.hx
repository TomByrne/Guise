package guise.platform.cross.accessTypes;
import composure.traits.AbstractTrait;
import guise.accessTypes.IMouseClickableAccess;
import guise.platform.cross.IAccessRequest;
import guise.accessTypes.IMouseInteractionsAccess;
import haxe.Timer;
import msignal.Signal;

/**
 * Takes an IMouseInteractionAccess and translates it's events to click events.
 */

class MouseClickEmulator extends AbstractTrait, implements IMouseClickableAccess, implements IAccessRequest
{
	private static var ACCESS_TYPES:Array<Class<Dynamic>> = [IMouseInteractionsAccess];
	private static var DEF_MAX_CLICK_MOVEMENT:Float = 12;
	private static var DEF_MAX_DBL_CLICK_TIME:Float = 0.3;

	@:isVar public var layerName(default, set_layerName):String;
	private function set_layerName(value:String):String {
		this.layerName = value;
		return value;
	}
	
	@lazyInst
	public var clicked:Signal1<ClickInfo>;
	
	@lazyInst
	public var doubleClicked:Signal1<ClickInfo>;
	
	public var maxClickMovement:Float;
	public var maxDblClickTime:Float;
	public var waitForDoubleClick:Bool;
	
	public var _mouseInteractions:IMouseInteractionsAccess;
	public var _isDown:Bool;
	public var _clickInfo:ClickInfo;
	public var _doubleClickTimer:Timer;
	
	public function new(?layerName:String) {
		super();
		this.layerName = layerName;
		maxClickMovement = DEF_MAX_CLICK_MOVEMENT;
		maxDblClickTime = DEF_MAX_DBL_CLICK_TIME;
		_clickInfo = new ClickInfo();
		_clickInfo.left = true;
	}
	@injectAdd
	private function onMouseIntAdd(access:IMouseInteractionsAccess):Void {
		if (layerName != null && access.layerName != layerName) return;
		
		_mouseInteractions = access;
		_mouseInteractions.pressed.add(onPressed);
	}
	@injectRemove
	private function onMouseIntRemove(access:IMouseInteractionsAccess):Void {
		if (access != _mouseInteractions) return;
		
		if (_isDown) cancelClick();
		_mouseInteractions.pressed.remove(onPressed);
		_mouseInteractions = null;
	}
	
	private function onPressed(info:MouseInfo):Void {
		if(_doubleClickTimer==null){
			_isDown = true;
			
			_mouseInteractions.released.add(onReleased);
			_mouseInteractions.rolledOut.add(onRolledOut);
		}
	}
	private function onReleased(info:MouseInfo):Void {
		if(_doubleClickTimer==null){
			if(!waitForDoubleClick){
				LazyInst.exec(clicked.dispatch(_clickInfo));
			}
			_doubleClickTimer = new Timer(Std.int(maxDblClickTime * 1000));
			_doubleClickTimer.run = doubleClickTimeout;
		}else {
			LazyInst.exec(doubleClicked.dispatch(_clickInfo));
			cancelClick();
		}
	}
	private function doubleClickTimeout():Void {
		if(waitForDoubleClick){
			LazyInst.exec(clicked.dispatch(_clickInfo));
		}
		cancelClick();
	}
	private function onRolledOut(info:MouseInfo):Void {
		cancelClick();
	}
	
	private function cancelClick():Void {
		_isDown = false;
		
		if (_doubleClickTimer != null) {
			_doubleClickTimer.stop();
			_doubleClickTimer = null;
		}
		
		_mouseInteractions.released.remove(onReleased);
		_mouseInteractions.rolledOut.remove(onRolledOut);
	}
	
	public function getAccessTypes():Array<Class<Dynamic>> {
		return ACCESS_TYPES;
	}
}