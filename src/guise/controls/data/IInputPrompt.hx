package guise.controls.data;

import msignal.Signal;


interface IInputPrompt 
{
	@:isVar public var promptChanged(get, null):Signal1<IInputPrompt>;
	
	@:isVar public var prompt(default, null):String;
	
	public function setPrompt(text:String):Void;
}



// Default implementation
@:build(LazyInst.check())
class InputPrompt implements IInputPrompt
{
	@:isVar @lazyInst public var promptChanged:Signal1<IInputPrompt>;
	
	@:isVar public var prompt(default, null):String;

	public function new(prompt:Null<String>=null) 
	{
		setPrompt(prompt);
	}
	
	public function setPrompt(prompt:String):Void {
		if (this.prompt == prompt) return;
		
		this.prompt = prompt;
		LazyInst.exec(promptChanged.dispatch(this));
		
	}
	
}