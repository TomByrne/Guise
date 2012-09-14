package guise.controls.data;

import msignal.Signal;

/**
 * ...
 * @author Tom Byrne
 */

interface IInputPrompt 
{
	public var promptChanged(default, null):Signal1<IInputPrompt>;
	
	public var prompt(default, null):String;
	
	public function setPrompt(text:String):Void;
}

// Default implementation
class InputPrompt implements IInputPrompt
{
	public var promptChanged(default, null):Signal1<IInputPrompt>;
	
	public var prompt(default, null):String;

	public function new(prompt:Null<String>=null) 
	{
		promptChanged = new Signal1();
		setPrompt(prompt);
	}
	
	public function setPrompt(prompt:String):Void {
		if (this.prompt != prompt) {
			this.prompt = prompt;
			promptChanged.dispatch(this);
		}
	}
	
}