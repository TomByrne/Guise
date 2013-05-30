package guise.core;

import msignal.Signal;

interface IWindowInfo
{
	public var availSizeChanged(get_availSizeChanged, null):Signal1<IWindowInfo>;
	
	public var availWidth(default, null):Int;
	public var availHeight(default, null):Int;
	
}