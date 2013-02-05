package guise.controls.data;

import msignal.Signal;

interface INumRange 
{

	public var rangeChanged(default, null):Signal1<INumRange>;
	
	public var max(default, null):Float;
	public var min(default, null):Float;
	public var value(default, set_value):Float;
	public var valueNorm(get_valueNorm, set_valueNorm):Float;
}

