package guise.controls.logic.states;
import composure.traits.AbstractTrait;
import guise.states.ControlStates;
import guise.states.State;
import guise.accessTypes.IFocusableAccess;


class FocusStateMapper extends AbstractTrait
{
	
	private var focusedState:State<FocusState>;
	
	private var _focusable:IFocusableAccess;
	
	private var layerName:String;

	public function new(layerName:String) 
	{
		super();
		
		this.layerName = layerName;
		
		focusedState = new State();
		focusedState.set(FocusState.UNFOCUSED);
		addSiblingTrait(focusedState);
		
		//addSiblingTrait(new PlatformAccessor(IFocusableAccess, layerName, onFocusAdd, onFocusRemove));
	}
	
	@injectAdd
	private function onFocusAdd(access:IFocusableAccess):Void {
		if (access.layerName != layerName) return;
		
		_focusable = access;
		access.focusedChanged.add(onFocusedChanged);
		onFocusedChanged(access);
	}
	@injectRemove
	private function onFocusRemove(access:IFocusableAccess):Void {
		if (access != _focusable) return;
		
		access.focusedChanged.remove(onFocusedChanged);
		_focusable = null;
	}
	private function onFocusedChanged(from:IFocusableAccess):Void {
		focusedState.set(from.focused?FocusState.FOCUSED:FocusState.UNFOCUSED);
	}
}