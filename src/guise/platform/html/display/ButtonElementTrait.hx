package guise.platform.html.display;
import guise.controls.data.ITextLabel;
import guise.controls.data.ISelected;
import js.Lib;
import js.Dom;

/**
 * ...
 * @author Tom Byrne
 */

class ButtonElementTrait extends DomElementTrait
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
			_checkbox = Lib.document.createElement("input");
			_checkbox.setAttribute("type", "checkbox");
			_button.appendChild(_checkbox);
			
			_innerElement = _checkbox;
			selected.selectedChanged.add(onSelectedChanged);
			onSelectedChanged(selected);
		}else if (_checkbox != null) {
			_button.removeChild(_checkbox);
			_checkbox = null;
			_innerElement = _button;
		}
		if (textLabel != null) onTextChanged(textLabel);
		return value;
	}
	
	private var _button:HtmlDom;
	private var _checkbox:HtmlDom;
	private var _innerElement:HtmlDom;

	public function new() 
	{
		_button = Lib.document.createElement("button");
		_button.setAttribute("type", "button");
		_innerElement = _button;
		super(_button);
		
		_allowSizing = true;
	}
	
	private function onTextChanged(from:ITextLabel):Void {
		_innerElement.innerHTML = from.text;
	}
	
	private function onSelectedChanged(from:ISelected):Void {
		_checkbox.setAttribute("checked", selected.selected?"true":"false");
	}
}