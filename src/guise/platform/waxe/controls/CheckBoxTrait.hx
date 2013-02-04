package guise.platform.waxe.controls;

import guise.controls.data.INumRange;
import guise.controls.data.ISelected;
import guise.controls.data.ITextLabel;
import guise.platform.waxe.display.DisplayTrait;

class CheckBoxTrait extends DisplayTrait
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
			onTextChanged(textLabel);
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
	
	private var _label:HtmlDom;
	private var _checkbox:Checkbox;

	public function new() 
	{
		_allowSizing = true;
		_checkbox = cast Lib.document.createElement("input");
		_checkbox.setAttribute("type", "checkbox");
		_checkbox.onchange = onCheckBoxChange;
		
		_label = cast Lib.document.createElement("label");
		_label.appendChild(_checkbox);
		
		super(_label);
	}
	private function onCheckBoxChange(e:Event):Void {
		if(selected!=null){
			selected.set(_checkbox.checked);
		}
	}
	
	private function onSelectedChanged(from:ISelected):Void {
		_checkbox.checked = from.selected;
	}
	
	private function onTextChanged(from:ITextLabel):Void {
		_label.innerHTML = from.text;
		_label.appendChild(_checkbox);
	}
}