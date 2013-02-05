package guise.platform.waxe.controls;
import guise.controls.data.ITextLabel;
import guise.platform.waxe.display.ContainerTrait;
import guise.platform.waxe.display.DisplayTrait;
import wx.StaticText;
import wx.Window;


class TextLabelTrait extends DisplayTrait<StaticText>
{
	@inject
	public var textLabel(default, set_textLabel):ITextLabel;
	private function set_textLabel(value:ITextLabel):ITextLabel {
		if (textLabel!=null) {
			textLabel.textChanged.remove(onTextChanged);
		}
		textLabel = value;
		if (textLabel!=null) {
			textLabel.textChanged.add(onTextChanged);
			if(window!=null)onTextChanged(textLabel);
		}
		return value;
	}

	public function new() 
	{
		_allowSizing = true;
		super(function(parent:Window):StaticText return StaticText.create(parent) );
	}
	
	private function onTextChanged(from:ITextLabel = null):Void {
		var text:String = textLabel.text;
		window.setLabel(text==null?"":text);
	}
	override private function onParentAdded(parent:DisplayTrait<Window>):Void {
		super.onParentAdded(parent);
		if (textLabel != null) onTextChanged();
	}
}