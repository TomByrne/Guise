package guise.core;
import msignal.Signal;


interface IActive 
{
	@:isVar public var activeChanged(default, null):Signal1<IActive>;
	
	@:isVar public var active(default, null):Bool;
	@:isVar public var explicit(default, null):Bool;
	
	public function set(active:Bool, explicit:Bool):Void;
}