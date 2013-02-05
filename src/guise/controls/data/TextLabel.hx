package guise.controls.data;

import msignal.Signal;

// Default implementation
class TextLabel implements ITextLabel
{
	public var textChanged(default, null):Signal1<ITextLabel>;
	
	public var text(default, null):String;

	public function new(text:Null<String>=null) 
	{
		textChanged = new Signal1();
		set(text);
	}
	
	public function set(text:String):Void {
		if (this.text != text) {
			this.text = text;
			textChanged.dispatch(this);
		}
	}
	
}