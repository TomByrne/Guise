package guise.controls.logic.states;

import composure.traits.AbstractTrait;
import guise.platform.cross.IAccessRequest;
import guise.states.State;
import guise.states.ControlStates;
import haxe.Log;
import guise.accessTypes.IMouseInteractionsAccess;


class ButtonStateMapper extends AbstractTrait, implements IAccessRequest
{
	private static var ACCESS_TYPES:Array<Class<Dynamic>> = [IMouseInteractionsAccess];
	
	private var downState:State<ButtonDownState>;
	private var overState:State<ButtonOverState>;
	private var _mouseInteractions:IMouseInteractionsAccess;
	
	@:isVar public var layerName(default, set_layerName):String;
	private function set_layerName(value:String):String {
		this.layerName = value;
		return value;
	}

	public function new(?layerName:String) 
	{
		super();
		this.layerName = layerName;
		
		overState = new State();
		overState.set(ButtonOverState.OUT);
		addSiblingTrait(overState);
		
		downState = new State();
		downState.set(ButtonDownState.UP);
		addSiblingTrait(downState);
		
		//addSiblingTrait(new PlatformAccessor(IMouseInteractionsAccess, layerName, onMouseIntAdd, onMouseIntRemove));
	}
	public function getAccessTypes():Array<Class<Dynamic>> {
		return ACCESS_TYPES;
	}
	@injectAdd
	private function onMouseIntAdd(access:IMouseInteractionsAccess):Void {
		_mouseInteractions = access;
		_mouseInteractions.pressed.add(onPressed);
		_mouseInteractions.released.add(onReleased);
		_mouseInteractions.rolledOver.add(onRolledOver);
		_mouseInteractions.rolledOut.add(onRolledOut);
	}
	@injectRemove
	private function onMouseIntRemove(access:IMouseInteractionsAccess):Void {
		_mouseInteractions.pressed.remove(onPressed);
		_mouseInteractions.released.remove(onReleased);
		_mouseInteractions.rolledOver.remove(onRolledOver);
		_mouseInteractions.rolledOut.remove(onRolledOut);
		_mouseInteractions = null;
	}
	
	
	private function onPressed(info:MouseInfo):Void {
		//trace("onPressed");
		downState.set(ButtonDownState.DOWN);
	}
	private function onReleased(info:MouseInfo):Void {
		//trace("onReleased");
		downState.set(ButtonDownState.UP);
	}
	private function onRolledOver(info:MouseInfo):Void {
		//Log.trace("onRolledOver");
		overState.set(ButtonOverState.OVER);
	}
	private function onRolledOut(info:MouseInfo):Void {
		//trace("onRolledOut");
		overState.set(ButtonOverState.OUT);
	}
}