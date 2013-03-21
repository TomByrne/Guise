package guise.platform.waxe.controls;

import guise.data.INumRange;
import guise.data.ISelected;
import guise.data.ITextLabel;
import guise.platform.waxe.display.DisplayTrait;
import wx.Window;
import wx.CheckBox;

class CheckBoxTrait extends DisplayTrait<CheckBox>
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
			if(window!=null)onSelectedChanged(selected);
		}
		return value;
	}

	public function new() 
	{
		_allowSizing = true;
		
		super(function(parent:Window):CheckBox return CheckBox.create(parent) );
	}
	private function onCheckBoxChange(e:Dynamic):Void {
		if(selected!=null){
			selected.setSelected(window.checked);
		}
	}
	
	private function onSelectedChanged(from:ISelected=null):Void {
		window.setChecked(selected.selected);
	}
	
	private function onTextChanged(from:ITextLabel=null):Void {
		window.label = (textLabel.text);
		checkMeas();
	}
	override private function onParentAdded(parent:DisplayTrait<Window>):Void {
		super.onParentAdded(parent);
		window.setHandler(wx.EventID.COMMAND_CHECKBOX_CLICKED,onCheckBoxChange);
		if (textLabel != null) onTextChanged();
		if (selected != null) onSelectedChanged();
	}
	override private function onParentRemoved(parent:DisplayTrait<Window>):Void {
		window.setHandler(wx.EventID.COMMAND_CHECKBOX_CLICKED, null);
		super.onParentRemoved(parent);
	}
}