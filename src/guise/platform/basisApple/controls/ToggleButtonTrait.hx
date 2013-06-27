package guise.platform.basisApple.controls;

import guise.controls.data.INumRange;
import guise.controls.data.ISelected;
import guise.controls.data.ITextLabel;
import guise.platform.basisApple.display.DisplayTrait;
import apple.ui.*;
import basis.object.IObject;

class ToggleButtonTrait extends DisplayTrait<UISwitch>
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
			if(view!=null)onTextChanged(textLabel);
		}
		return value;
	}
	@inject
	@:isVar public var selected(default, set):ISelected;
	private function set_selected(value:ISelected):ISelected {
		if (selected!=null) {
			selected.selectedChanged.remove(onSelectedChanged);
		}
		selected = value;
		if (selected != null) {
			selected.selectedChanged.add(onSelectedChanged);
			if(view!=null)onSelectedChanged(selected);
		}
		return value;
	}

	public function new() 
	{
		_allowSizing = true;
		
		super(new UISwitch());
		view.addEventListener(UIControl.UIControlValueChanged, onToggleButtonChange);
	}
	private function onToggleButtonChange(object:IObject, type:String):Void {
		if(selected!=null){
			selected.setSelected(view.on);
		}
	}
	
	private function onSelectedChanged(from:ISelected=null):Void {
		view.on = selected.selected;
	}
	
	private function onTextChanged(from:ITextLabel=null):Void {
		// view.label = (textLabel.text);
		// checkMeas();
	}
	
}