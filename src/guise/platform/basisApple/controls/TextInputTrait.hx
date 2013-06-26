package guise.platform.basisApple.controls;
import guise.controls.data.IInputPrompt;
import guise.controls.data.ITextLabel;
import guise.layout.IBoxPos;
import guise.platform.basisApple.display.DisplayTrait;
import apple.ui.*;

class TextInputTrait extends DisplayTrait<UITextField>
{
	@inject
	@:isVar public var textPrompt(default, set):IInputPrompt;
	private function set_textPrompt(value:IInputPrompt):IInputPrompt {
		if (textPrompt != null) {
			textPrompt.promptChanged.remove(onPromptChanged);
		}
		this.textPrompt = value;
		if (textPrompt != null) {
			textPrompt.promptChanged.add(onPromptChanged);
			onPromptChanged(textPrompt);
		}else {
			view.placeholder = "";
		}
		return value;
	}
	@inject
	@:isVar public var textLabel(default, set):ITextLabel;
	private function set_textLabel(value:ITextLabel):ITextLabel {
		if (textLabel!=null) {
			textLabel.textChanged.remove(onTextChanged);
		}
		textLabel = value;
		if (textLabel!=null) {
			textLabel.textChanged.add(onTextChanged);
			onTextChanged(textLabel);
		}
		return value;
	}

	public function new() 
	{
		_allowSizing = true;
		super(new UITextField());
	}
	
	private function onTextChanged(from:ITextLabel):Void {
		view.text = from.text==null?"":from.text;
	}
	private function onPromptChanged(from:IInputPrompt):Void {
		view.placeholder = from.prompt==null?"":from.prompt;
	}
}