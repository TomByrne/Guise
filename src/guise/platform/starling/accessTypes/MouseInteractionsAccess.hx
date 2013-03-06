package guise.platform.starling.accessTypes;
import composure.traits.AbstractTrait;
import guise.accessTypes.IAccessType;
import guise.accessTypes.IMouseInteractionsAccess;
import guise.platform.starling.addTypes.IDisplayObjectType;
import guise.platform.starling.display.DisplayTrait;
import starling.display.DisplayObject;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import msignal.Signal;
import flash.geom.Point;

class MouseInteractionsAccess extends AbstractTrait, implements IMouseInteractionsAccess
{
	private static var DUMMY_POINT:Point;
	
	@inject
	public var displayTrait(default, set_displayTrait):DisplayTrait;
	private function set_displayTrait(value:DisplayTrait):DisplayTrait {
		if (layerName != null) return displayTrait;
		
		if (displayTrait!=null) {
			if (displayTrait.displayObject == displayObject) {
				displayObject = null;
			}
		}
		displayTrait = value;
		if (displayTrait != null) {
			if (displayObject==null) {
				displayObject = displayTrait.displayObject;
			}
		}
		return value;
	}
	
	public var displayObject(default, set_displayObject):DisplayObject;
	private function set_displayObject(value:DisplayObject):DisplayObject {
		if (displayObject!=null) {
			displayObject.removeEventListener(TouchEvent.TOUCH, onTouch);
		}
		displayObject = value;
		if (displayObject!=null) {
			displayObject.addEventListener(TouchEvent.TOUCH, onTouch);
		}
		return value;
	}
	
	public var coordinateSpace:DisplayObject;
	
	private var mouseInfo:MouseInfo;
	private var _isOver:Bool;
	
	public var layerName(default, set_layerName):String;
	private function set_layerName(value:String):String {
		this.layerName = value;
		return value;
	}

	public function new(?layerName:String, ?displayObject:DisplayObject, ?coordinateSpace:DisplayObject) 
	{
		super();
		this.layerName = layerName;
		
		this.displayObject = displayObject;
		this.coordinateSpace = coordinateSpace;
	}
	
	@injectAdd
	private function addInteractiveType(value:IDisplayObjectType):Void {
		if (displayObject != null) return;
		
		if (layerName!=null && Std.is(value, IAccessType)) {
			var access:IAccessType = cast value;
			if (layerName != access.layerName) {
				return;
			}
		}else {
			return;
		}
		displayObject = value.getDisplayObject();
		
	}
	@injectRemove
	private function removeInteractiveType(value:IDisplayObjectType):Void {
		if (value.getDisplayObject() == displayObject) {
			displayObject = null;
		}
	}
	
	
	private var _over:Bool;
	private var _down:Bool;
	private var _downCount:Int = 0;
	private function onTouch(event:TouchEvent):Void {
		
		var touches = event.getTouches(displayObject);
		
		var space:DisplayObject;
		if (coordinateSpace != null) {
			space = coordinateSpace;
		}else {
			space = displayObject;
		}
		var mouseX:Float = 0;
		var mouseY:Float = 0;
		var overFound:Bool = false;
		var moveFound:Bool = false;
		if (DUMMY_POINT == null) {
			DUMMY_POINT = new Point();
		}
		for (touch in touches) {
			var location = touch.getLocation(space, DUMMY_POINT);
			mouseX += DUMMY_POINT.x;
			mouseY += DUMMY_POINT.y;
			switch(touch.phase) {
				case TouchPhase.STATIONARY:
					overFound = true;
				case TouchPhase.HOVER, TouchPhase.MOVED:
					overFound = true;
					moveFound = true;
				case TouchPhase.BEGAN:
					overFound = true;
					++_downCount;
				case TouchPhase.ENDED:
					overFound = true;
					--_downCount;
					
			}
		}
		if (mouseInfo == null) {
			mouseInfo = new MouseInfo();
		}
		if(touches.length>0){
			mouseInfo.mouseX = mouseX / touches.length;
			mouseInfo.mouseY = mouseY / touches.length;
		}
		if (overFound) {
			if(!_over){
				_over = true;
				LazyInst.exec(rolledOver.dispatch(mouseInfo));
			}
		}else if (_over) {
			_over = false;
			LazyInst.exec(rolledOut.dispatch(mouseInfo));
		}
		
		if (_downCount > 0) {
			if (!_down) {
				_down = true;
				LazyInst.exec(pressed.dispatch(mouseInfo));
			}
		}else if (_down) {
			_down = false;
			LazyInst.exec(released.dispatch(mouseInfo));
		}
		
		if(moveFound){
			LazyInst.exec(moved.dispatch(mouseInfo));
		}
	}
	
	@lazyInst public var pressed:Signal1<MouseInfo>;
	@lazyInst public var released:Signal1<MouseInfo>;
	@lazyInst public var rolledOver:Signal1<MouseInfo>;
	@lazyInst public var rolledOut:Signal1<MouseInfo>;
	@lazyInst public var moved:Signal1<MouseInfo>;
}