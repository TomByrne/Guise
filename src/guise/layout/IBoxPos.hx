package guise.layout;


import msignal.Signal;

interface IBoxPos 
{

	public var changed(get_changed, null):Signal1<IBoxPos>;
	public var posChanged(get_posChanged, null):Signal1<IBoxPos>;
	public var sizeChanged(get_sizeChanged, null):Signal1<IBoxPos>;
	
	public var x(default, null):Float;
	public var y(default, null):Float;
	public var w(default, null):Float;
	public var h(default, null):Float;
	
}