package guise.traits.states;

import msignal.Signal;

/**
 * @author Tom Byrne
 */

interface IState<StateEnum:EnumValue> 
{

	public var stateChanged(default, null):Signal1<IState<StateEnum>>;
	
	public var current(default, null):StateEnum;
	
	public var options(default, null):Array<StateEnum>;

	public function set(current:StateEnum):Void;
	
}