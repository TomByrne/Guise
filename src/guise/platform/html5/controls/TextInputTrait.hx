package guise.platform.html5.controls;
import guise.controls.data.IInputPrompt;
import guise.controls.data.ISelected;
import guise.controls.data.ITextLabel;
import guise.layout.IBoxPos;
import guise.platform.html5.display.DisplayTrait;
import js.Dom;
import js.Lib;

/**
 * ...
 * @author Tom Byrne
 */

class TextInputTrait extends TextLabelTrait
{
	@inject
	@:isVar public var textPrompt(default, set_textPrompt):IInputPrompt;
	private function set_textPrompt(value:IInputPrompt):IInputPrompt {
		if (textPrompt != null) {
			textPrompt.promptChanged.remove(onPromptChanged);
		}
		this.textPrompt = value;
		if (textPrompt != null) {
			textPrompt.promptChanged.add(onPromptChanged);
			onPromptChanged(textPrompt);
		}else {
			untyped domElement.placeholder = "";
		}
		return value;
	}

	public function new() 
	{
		super("input");
	}
	
	private function onPromptChanged(from:IInputPrompt):Void {
		untyped domElement.placeholder = from.prompt;
	}
}