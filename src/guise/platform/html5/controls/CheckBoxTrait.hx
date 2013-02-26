package guise.platform.html5.controls;

import guise.controls.data.INumRange;
import guise.controls.data.ISelected;
import guise.controls.data.ITextLabel;
import guise.platform.html5.display.DisplayTrait;
import js.Dom;
import js.Browser;

class CheckBoxTrait extends DisplayTrait
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
	@inject
	@:isVar public var selected(default, set):ISelected;
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
		_checkbox = cast Browser.document.createElement("input");
		_checkbox.setAttribute("type", "checkbox");
		_checkbox.onchange = onCheckBoxChange;
		
		_label = cast Browser.document.createElement("label");
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
		_label.innerHTML = "";
		_label.appendChild(_checkbox);
		_label.appendChild(Browser.document.createTextNode(from.text));
		checkMeas();
	}
}