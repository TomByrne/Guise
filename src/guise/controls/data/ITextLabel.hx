package guise.controls.data;

import msignal.Signal;

interface ITextLabel 
{
	@:isVar public var textChanged(default, null):Signal1<ITextLabel>;
	
	@:isVar public var text(default, null):String;
	
	public function set(text:String):Void;
}
