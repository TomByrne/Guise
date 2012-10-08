package guise.platform.html.display;
import composure.traits.AbstractTrait;
import guise.controls.data.ITextLabel;
import guise.controls.data.ISelected;
import js.Lib;
import js.Dom;

/**
 * ...
 * @author Tom Byrne
 */

class ButtonElementTrait extends AbstractTrait
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
			_checkbox.onclick = onCheckboxClick;
			_button.appendChild(_checkbox);
			
			//_innerElement = _checkbox;
			selected.selectedChanged.add(onSelectedChanged);
			onSelectedChanged(selected);
		}else if (_checkbox != null) {
			_button.removeChild(_checkbox);
			_checkbox = null;
			//_innerElement = _button;
		}
		if (textLabel != null) onTextChanged(textLabel);
		return value;
	}
	
	private var _button:HtmlDom;
	private var _checkbox:HtmlDom;
	//private var _innerElement:HtmlDom;
	private var _labelElement:HtmlDom;

	public function new(domElement:HtmlDom) 
	{
		super();
		_button = domElement;
		_labelElement = Lib.document.createElement("label");
		_button.appendChild(_labelElement);
	}
	
	private function onTextChanged(from:ITextLabel):Void {
		_labelElement.innerHTML = from.text;
	}
	
	private function onSelectedChanged(from:ISelected):Void {
		//_checkbox.setAttribute("checked", selected.selected?"true":"false");
		trace("onSelectedChanged: "+_checkbox.getAttribute("checked"));
	}
	private function onCheckboxClick(e:Event):Void {
		onSelectedChanged(selected);
	}
}