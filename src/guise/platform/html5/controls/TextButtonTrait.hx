package guise.platform.html5.controls;
import guise.controls.data.ISelected;
import guise.controls.data.ITextLabel;
import guise.layout.IBoxPos;
import guise.platform.html5.display.DisplayTrait;
import js.Browser;
import js.html.Element;
import js.html.InputElement;
import js.html.Event;

class TextButtonTrait extends DisplayTrait
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
			_checkbox = cast Browser.document.createElement("input");
			_checkbox.setAttribute("type", "checkbox");
			_checkbox.onclick = onCheckboxClick;
			_button.appendChild(_checkbox);
			
			selected.selectedChanged.add(onSelectedChanged);
			onSelectedChanged(selected);
		}else if (_checkbox != null) {
			_button.removeChild(_checkbox);
			_checkbox = null;
		}
		checkMeas();
		return value;
	}
	
	private var _button:Element;
	private var _checkbox:InputElement;
	private var _innerElement:Element;
	private var _labelElement:Element;

	public function new() 
	{
		_allowSizing = true;
		_button = Browser.document.createElement("button");
		super(_button);
		_labelElement = Browser.document.createElement("label");
		_button.appendChild(_labelElement);
	}
	
	private function onTextChanged(from:ITextLabel):Void {
		_labelElement.innerHTML = from.text;
		checkMeas();
	}
	
	private function onSelectedChanged(from:ISelected):Void {
		_checkbox.checked = selected.selected;
	}
	private function onCheckboxClick(e:Event):Void {
		onSelectedChanged(selected);
		checkMeas();
	}
}