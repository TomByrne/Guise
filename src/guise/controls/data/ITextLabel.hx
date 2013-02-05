package guise.controls.data;

import msignal.Signal;

interface ITextLabel 
{
	public var textChanged(default, null):Signal1<ITextLabel>;
	
	public var text(default, null):String;
	
	public function set(text:String):Void;
}
