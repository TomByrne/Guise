package guise.platform.html5.logic;
import composure.traits.AbstractTrait;
import guise.accessTypes.IMouseInteractionsAccess;

import msignal.Signal;
import guise.platform.html5.display.DisplayTrait;
import js.html.MouseEvent;


class MouseInteractions extends AbstractTrait implements IMouseInteractionsAccess
{
	@inject
	public var displayTrait(default, set_displayTrait):DisplayTrait;
	private function set_displayTrait(value:DisplayTrait):DisplayTrait {
		if (displayTrait!=null) {
			displayTrait.domElement.onmouseover = null;
			displayTrait.domElement.onmousedown = null;
			if (_down) onMouseUp();
			if (_over) onMouseOut();
		}
		displayTrait = value;
		if (displayTrait != null) {
			untyped displayTrait.domElement.onmouseover = onMouseOver;
			untyped displayTrait.domElement.onmousedown = onMouseDown;
		}
		return value;
	}
	
	
	private var _down:Bool;
	private var _over:Bool;
	
	private var mouseInfo:MouseInfo;
	
	public var layerName(default, set_layerName):String;
	private function set_layerName(value:String):String {
		this.layerName = value;
		return value;
	}

	public function new() 
	{
		super();
	}
	
	private function setMouseInfo(x:Float, y:Float):Void {
		if (mouseInfo == null) {
			mouseInfo = new MouseInfo();
		}
		mouseInfo.mouseX = x;
		mouseInfo.mouseY = y;
	}
	
	@lazyInst public var pressed:Signal1<MouseInfo>;
	@lazyInst public var released:Signal1<MouseInfo>;
	@lazyInst public var rolledOver:Signal1<MouseInfo>;
	@lazyInst public var rolledOut:Signal1<MouseInfo>;
	@lazyInst public var moved:Signal1<MouseInfo>;
	
	
	private function onMouseDown(?e:MouseEvent):Void {
		_down = true;
		untyped displayTrait.domElement.onmouseup = onMouseUp;
		untyped displayTrait.domElement.onmousemove = onMouseMove;
		if (e != null) setMouseInfo(e.clientX, e.clientY);
		LazyInst.exec(pressed.dispatch(mouseInfo));
	}
	private function onMouseUp(?e:MouseEvent):Void {
		_down = false;
		displayTrait.domElement.onmouseup = null;
		if(!_over)displayTrait.domElement.onmousemove = null;
		if (e != null) setMouseInfo(e.clientX, e.clientY);
		LazyInst.exec(released.dispatch(mouseInfo));
	}
	private function onMouseOver(?e:MouseEvent):Void {
		_over = true;
		untyped displayTrait.domElement.onmouseout = onMouseOut;
		untyped displayTrait.domElement.onmousemove = onMouseMove;
		if (e != null) setMouseInfo(e.clientX, e.clientY);
		LazyInst.exec(rolledOver.dispatch(mouseInfo));
	}
	private function onMouseOut(?e:MouseEvent):Void {
		_over = false;
		displayTrait.domElement.onmouseout = null;
		if(!_down)displayTrait.domElement.onmousemove = null;
		if (e != null) setMouseInfo(e.clientX, e.clientY);
		LazyInst.exec(rolledOut.dispatch(mouseInfo));
	}
	private function onMouseMove(?e:MouseEvent):Void {
		if (e != null) setMouseInfo(e.clientX, e.clientY);
		LazyInst.exec(moved.dispatch(mouseInfo));
	}
}