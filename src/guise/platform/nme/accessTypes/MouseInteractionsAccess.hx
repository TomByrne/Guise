package guise.platform.nme.accessTypes;
import composure.traits.AbstractTrait;
import nme.events.MouseEvent;
import guise.accessTypes.IMouseInteractionsAccess;
import nme.display.InteractiveObject;
import guise.platform.nme.display.DisplayTrait;

import msignal.Signal;

/**
 * ...
 * @author Tom Byrne
 */

class MouseInteractionsAccess extends AbstractTrait, implements IMouseInteractionsAccess
{
	@inject
	public var displayTrait(default, set_displayTrait):DisplayTrait;
	private function set_displayTrait(value:DisplayTrait):DisplayTrait {
		if (displayTrait!=null) {
			if (displayTrait.displayObject == interactiveObject) {
				interactiveObject = null;
			}
		}
		displayTrait = value;
		if (displayTrait != null) {
			if (interactiveObject==null && Std.is(displayTrait.displayObject, InteractiveObject)) {
				interactiveObject = cast displayTrait.displayObject;
			}
		}
		return value;
	}
	
	public var interactiveObject(default, set_interactiveObject):InteractiveObject;
	private function set_interactiveObject(value:InteractiveObject):InteractiveObject {
		if (interactiveObject!=null) {
			interactiveObject.removeEventListener(MouseEvent.MOUSE_DOWN, onPressed);
			interactiveObject.removeEventListener(MouseEvent.MOUSE_OVER, onRolledOver);
			interactiveObject.removeEventListener(MouseEvent.MOUSE_OUT, onRolledOut);
			interactiveObject.removeEventListener(MouseEvent.MOUSE_MOVE, onMoved);
		}
		interactiveObject = value;
		if (interactiveObject!=null) {
			if((_pressed!=null && _pressed.numListeners>0) && (_released!=null && _released.numListeners>0))interactiveObject.addEventListener(MouseEvent.MOUSE_DOWN, onPressed);
			if (_rolledOver != null && _rolledOver.numListeners>0) {
				//interactiveObject.mouseEnabled = true;
				interactiveObject.addEventListener(MouseEvent.MOUSE_OVER, onRolledOver);
			}
			if(_rolledOut!=null && _rolledOut.numListeners>0)interactiveObject.addEventListener(MouseEvent.MOUSE_OUT, onRolledOut);
			if(_moved!=null && _moved.numListeners>0)interactiveObject.addEventListener(MouseEvent.MOUSE_MOVE, onMoved);
		}
		return value;
	}
	
	public var coordinateSpace:InteractiveObject;
	
	private var mouseInfo:MouseInfo;
	private var _isOver:Bool;
	
	public var layerName(default, set_layerName):String;
	private function set_layerName(value:String):String {
		this.layerName = value;
		return value;
	}

	public function new(?layerName:String, ?interactiveObject:InteractiveObject, ?coordinateSpace:InteractiveObject) 
	{
		super();
		this.layerName = layerName;
		
		this.interactiveObject = interactiveObject;
		this.coordinateSpace = coordinateSpace;
	}
	
	private function onPressed(event:MouseEvent):Void {
		if (_pressed != null) {
			setMouseInfo();
			_pressed.dispatch(mouseInfo);
		}
		if (_released != null) {
			interactiveObject.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMoved);
			interactiveObject.stage.addEventListener(MouseEvent.MOUSE_UP, onReleased);
		}
	}
	private function onReleased(event:MouseEvent):Void {
		interactiveObject.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMoved);
		interactiveObject.stage.removeEventListener(MouseEvent.MOUSE_UP, onReleased);
		if (_released != null) {
			setMouseInfo();
			_released.dispatch(mouseInfo);
		}
	}
	private function onRolledOver(event:MouseEvent):Void {
		_isOver = true;
		if (_rolledOver != null) {
			setMouseInfo();
			_rolledOver.dispatch(mouseInfo);
		}
	}
	private function onRolledOut(event:MouseEvent):Void {
		_isOver = false;
		if (_rolledOut != null) {
			setMouseInfo();
			_rolledOut.dispatch(mouseInfo);
		}
	}
	private function onMoved(event:MouseEvent):Void {
		if (_moved != null) {
			setMouseInfo();
			_moved.dispatch(mouseInfo);
		}
	}
	private function setMouseInfo():Void {
		if (mouseInfo == null) {
			mouseInfo = new MouseInfo();
		}
		if(coordinateSpace!=null){
			mouseInfo.mouseX = coordinateSpace.mouseX;
			mouseInfo.mouseY = coordinateSpace.mouseY;
		}else {
			mouseInfo.mouseX = interactiveObject.mouseX;
			mouseInfo.mouseY = interactiveObject.mouseY;
		}
	}
	
	private var _pressed:Signal1<MouseInfo>;
	public var pressed(get_pressed, null):Signal1<MouseInfo>;
	private function get_pressed():Signal1<MouseInfo> {
		if (_pressed == null) {
			_pressed = new Signal1();
			if(interactiveObject!=null)interactiveObject.addEventListener(MouseEvent.MOUSE_DOWN, onPressed);
		}
		return _pressed;
	}
	
	private var _released:Signal1<MouseInfo>;
	public var released(get_released, null):Signal1<MouseInfo>;
	private function get_released():Signal1<MouseInfo> {
		if (_released == null) {
			_released = new Signal1();
			if (interactiveObject != null) interactiveObject.addEventListener(MouseEvent.MOUSE_DOWN, onPressed);
		}
		return _released;
	}
	
	private var _rolledOver:Signal1<MouseInfo>;
	public var rolledOver(get_rolledOver, null):Signal1<MouseInfo>;
	private function get_rolledOver():Signal1<MouseInfo> {
		if (_rolledOver == null) {
			_rolledOver = new Signal1();
			if (interactiveObject != null) {
				//interactiveObject.mouseEnabled = true;
				interactiveObject.addEventListener(MouseEvent.MOUSE_OVER, onRolledOver);
			}
		}
		return _rolledOver;
	}
	
	private var _rolledOut:Signal1<MouseInfo>;
	public var rolledOut(get_rolledOut, null):Signal1<MouseInfo>;
	private function get_rolledOut():Signal1<MouseInfo> {
		if (_rolledOut == null) {
			_rolledOut = new Signal1();
			if(interactiveObject!=null)interactiveObject.addEventListener(MouseEvent.MOUSE_OUT, onRolledOut);
		}
		return _rolledOut;
	}
	
	private var _moved:Signal1<MouseInfo>;
	public var moved(get_moved, null):Signal1<MouseInfo>;
	private function get_moved():Signal1<MouseInfo> {
		if (_moved == null) {
			_moved = new Signal1();
			if(interactiveObject!=null)interactiveObject.addEventListener(MouseEvent.MOUSE_MOVE, onMoved);
		}
		return _moved;
	}
}