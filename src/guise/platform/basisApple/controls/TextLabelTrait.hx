package guise.platform.basisApple.controls;
import guise.controls.data.ITextLabel;
import guise.layout.IBoxPos;
import guise.platform.basisApple.display.DisplayTrait;
import apple.ui.*;


class TextLabelTrait extends DisplayTrait<UILabel>
{
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
		super(new UILabel());
	}
	
	private function onTextChanged(from:ITextLabel):Void {
		view.text = from.text;
	}
}