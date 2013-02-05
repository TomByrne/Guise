package guise.controls.data;

import msignal.Signal;

interface ISelected 
{
	public var selectedChanged(default, null):Signal1<ISelected>;
	
	public var selected(default, null):Bool;
	
	public function set(selected:Bool):Void;
}

