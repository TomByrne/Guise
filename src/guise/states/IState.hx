package guise.states;

import msignal.Signal;

/**
 * @author Tom Byrne
 */

interface IState<StateEnum:EnumValue> 
{

	@:isVar public var stateChanged(default, null):Signal1<IState<StateEnum>>;
	
	@:isVar public var current(default, null):StateEnum;
	
	@:isVar public var options(default, null):Array<StateEnum>;

	public function set(current:StateEnum):Void;
	
}