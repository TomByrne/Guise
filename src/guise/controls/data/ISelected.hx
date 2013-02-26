package guise.controls.data;

import msignal.Signal;

interface ISelected 
{
	@:isVar public var selectedChanged(default, null):Signal1<ISelected>;
	
	@:isVar public var selected(default, null):Bool;
	
	public function set(selected:Bool):Void;
}

