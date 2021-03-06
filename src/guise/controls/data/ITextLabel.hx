package guise.controls.data;

import msignal.Signal;

interface ITextLabel 
{
	public var textChanged(get_textChanged, null):Signal1<ITextLabel>;
	
	public var text(default, null):String;
	
	public function setText(text:String):Void;
}


// Default implementation
@:build(LazyInst.check())
class TextLabel implements ITextLabel
{
	@lazyInst public var textChanged(default, null):Signal1<ITextLabel>;
	
	@change("textChanged")
	public var text(default, null):String;

	public function new(?text:String) 
	{
		setText(text);
	}
	
	public function setText(text:String):Void {
		if (this.text == text) return;
		
		this.text = text;
		textChanged.dispatch(this);
		
	}
	
}