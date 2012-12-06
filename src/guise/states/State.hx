package guise.states;

import msignal.Signal;

/**
 * @author Tom Byrne
 */

class State<StateEnum:EnumValue> implements IState<StateEnum>
{
	public var stateChanged(default, null):Signal1<IState<StateEnum>>;
	
	public var current(default, null):StateEnum;
	public var options(default, null):Array<StateEnum>;

	public function new(current:StateEnum=null) 
	{
		stateChanged = new Signal1();
		set(current);
	}
	
	public function set(current:StateEnum):Void {
		if (this.current != current) {
			this.current = current;
			options = Type.allEnums(Type.getEnum(current));
			stateChanged.dispatch(this);
		}
	}
	
}