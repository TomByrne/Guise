package guise.controls.logic.states;
import composure.traits.AbstractTrait;
import guise.platform.cross.IAccessRequest;
import guise.states.ControlStates;
import guise.states.State;
import guise.accessTypes.IFocusableAccess;


class FocusStateMapper extends AbstractTrait implements IAccessRequest
{
	private static var ACCESS_TYPES:Array<Class<Dynamic>> = [IFocusableAccess];
	
	private var focusedState:State<FocusState>;
	
	private var _focusable:IFocusableAccess;
	
	@:isVar public var layerName(default, set_layerName):String;
	private function set_layerName(value:String):String {
		this.layerName = value;
		return value;
	}

	public function new(?layerName:String) 
	{
		super();
		
		this.layerName = layerName;
		
		focusedState = new State();
		focusedState.set(FocusState.UNFOCUSED);
		addSiblingTrait(focusedState);
	}
	public function getAccessTypes():Array<Class<Dynamic>> {
		return ACCESS_TYPES;
	}
	
	@injectAdd
	private function onFocusAdd(access:IFocusableAccess):Void {
		if (layerName!=null && access.layerName != layerName) return;
		
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