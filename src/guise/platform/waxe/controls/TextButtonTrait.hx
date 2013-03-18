package guise.platform.waxe.controls;
import guise.controls.data.ISelected;
import guise.controls.data.ITextLabel;
import guise.layout.IBoxPos;
import guise.platform.waxe.display.DisplayTrait;
import guise.platform.waxe.display.ContainerTrait;
import wx.Button;
import wx.Window;


class TextButtonTrait extends DisplayTrait<Button>
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
	@inject
	public var selected(default, set_selected):ISelected;
	private function set_selected(value:ISelected):ISelected {
		if (selected!=null) {
			selected.selectedChanged.remove(onSelectedChanged);
		}
		selected = value;
		if (selected != null) {
			
			selected.selectedChanged.add(onSelectedChanged);
			onSelectedChanged(selected);
		}
		return value;
	}

	public function new() 
	{
		_allowSizing = true;
		super(function(parent:Window):Button return Button.create(parent));
	}
	override private function onParentAdded(parent:DisplayTrait<Window>):Void {
		super.onParentAdded(parent);
		if (textLabel != null) onTextChanged();
	}
	
	private function onTextChanged(from:ITextLabel=null):Void {
		var text:String = textLabel.text;
		window.setLabel(text==null?"":text);
		checkMeas();
	}
	
	private function onSelectedChanged(from:ISelected):Void {
		//_checkbox.checked = selected.selected;
	}
	/*private function onCheckboxClick(e:Event):Void {
		onSelectedChanged(selected);
	}*/
}