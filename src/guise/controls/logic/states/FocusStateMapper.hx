package guise.controls.logic.states;
import composure.traits.AbstractTrait;
import guise.states.ControlStates;
import guise.states.State;
import guise.platform.IPlatformAccess;
import guise.platform.PlatformAccessor;

/**
 * ...
 * @author Tom Byrne
 */

class FocusStateMapper extends AbstractTrait
{
	
	private var focusedState:State<FocusState>;
	
	private var _focusable:IFocusableAccess;

	public function new(layerName:String) 
	{
		super();
		
		focusedState = new State();
		focusedState.set(FocusState.UNFOCUSED);
		addSiblingTrait(focusedState);
		
		addSiblingTrait(new PlatformAccessor(IFocusableAccess, layerName, onFocusAdd, onFocusRemove));
	}
	private function onFocusAdd(access:IFocusableAccess):Void {
		_focusable = access;
		access.focusedChanged.add(onFocusedChanged);
		onFocusedChanged(access);
	}
	private function onFocusRemove(access:IFocusableAccess):Void {
		access.focusedChanged.remove(onFocusedChanged);
		_focusable = null;
	}
	private function onFocusedChanged(from:IFocusableAccess):Void {
		focusedState.set(from.focused?FocusState.FOCUSED:FocusState.UNFOCUSED);
	}
}