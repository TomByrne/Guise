package guise.controls.data;

import msignal.Signal;

interface INumRange 
{

	@:isVar public var rangeChanged(default, null):Signal1<INumRange>;
	
	@:isVar public var max(default, null):Float;
	@:isVar public var min(default, null):Float;
	@:isVar public var value(default, set):Float;
	public var valueNorm(get, set):Float;
}

