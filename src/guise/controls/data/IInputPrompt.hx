package guise.controls.data;

import msignal.Signal;


interface IInputPrompt 
{
	public var promptChanged(get_promptChanged, null):Signal1<IInputPrompt>;
	
	public var prompt(default, null):String;
	
	public function setPrompt(text:String):Void;
}



// Default implementation
@:build(LazyInst.check())
class InputPrompt implements IInputPrompt
{
	@lazyInst public var promptChanged:Signal1<IInputPrompt>;
	
	public var prompt(default, null):String;

	public function new(prompt:Null<String>=null) 
	{
		promptChanged = new Signal1();
		setPrompt(prompt);
	}
	
	public function setPrompt(prompt:String):Void {
		if (this.prompt == prompt) return;
		
		this.prompt = prompt;
		LazyInst.exec(promptChanged.dispatch(this));
		
	}
	
}