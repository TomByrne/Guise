package guise.controls.logic.states;

import composure.traits.AbstractTrait;
import guise.controls.ControlLayers;
import guise.states.State;
import guise.states.ControlStates;
import haxe.Log;
import guise.accessTypes.IMouseInteractionsAccess;
/**
 * @author Tom Byrne
 */

class ButtonStateMapper extends AbstractTrait
{
	
	private var downState:State<ButtonDownState>;
	private var overState:State<ButtonOverState>;
	private var _mouseInteractions:IMouseInteractionsAccess;

	public function new(?layerName:String) 
	{
		super();
		
		overState = new State();
		overState.set(ButtonOverState.OUT);
		addSiblingTrait(overState);
		
		downState = new State();
		downState.set(ButtonDownState.UP);
		addSiblingTrait(downState);
		
		//addSiblingTrait(new PlatformAccessor(IMouseInteractionsAccess, layerName, onMouseIntAdd, onMouseIntRemove));
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