package guise.platform.html5.logic;
import composure.traits.AbstractTrait;
import guise.platform.html5.display.DisplayTrait;
import guise.states.IState;


class StateToCssClass extends AbstractTrait
{
	
	@inject
	@:isVar private var displayTrait(default, set_displayTrait):DisplayTrait;
	private function set_displayTrait(value:DisplayTrait):DisplayTrait {
		if (displayTrait != null) {
			displayTrait.domElement.className = "";
		}
		this.displayTrait = value;
		if (displayTrait != null) {
			displayTrait.domElement.className = _classes.join(" ");
		}
		return value;
	}
	
	private var _stateToClass:Map<String, IState<Dynamic>, String>;
	private var _classes:Array<String>;

	public function new() 
	{
		super();
		_stateToClass = new Map();
		_classes = [];
	}
	
	@injectAdd
	private function addState(state:IState<Dynamic>):Void {
		state.stateChanged.add(onStateChanged);
		addClassByState(state);
		
	}
	@injectRemove
	private function removeState(state:IState<Dynamic>):Void {
		removeClassByState(state);
		state.stateChanged.remove(onStateChanged);
	}
	
	private function onStateChanged(state:IState<Dynamic>):Void {
		if (displayTrait == null) return;
		
		removeClassByState(state);
		addClassByState(state);
	}
	private function addClassByState(state:IState<Dynamic>):Void {
		if (state.current == null) return;
		
		var cssClass = Type.enumConstructor(state.current);
		_stateToClass.set(state, cssClass);
		_classes.push(cssClass);
		if(displayTrait!=null)displayTrait.domElement.className = _classes.join(" ");
	}
	private function removeClassByState(state:IState<Dynamic>):Void {
		
		var cssClass = _stateToClass.get(state);
		if (cssClass != null) {
			_stateToClass.delete(state);
			_classes.remove(cssClass);
			if(displayTrait!=null)displayTrait.domElement.className = _classes.join(" ");
		}
	}
}