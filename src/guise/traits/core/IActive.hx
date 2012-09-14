package guise.traits.core;
import msignal.Signal;

/**
 * ...
 * @author Tom Byrne
 */

interface IActive 
{
	public var activeChanged(default, null):Signal1<IActive>;
	
	public var active(default, null):Bool;
	public var explicit(default, null):Bool;
	
	public function set(active:Bool, explicit:Bool):Void;
}