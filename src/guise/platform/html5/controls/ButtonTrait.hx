package guise.platform.html5.controls;
import guise.controls.data.ISelected;
import guise.controls.data.ITextLabel;
import guise.layout.IDisplayPosition;
import guise.platform.html5.display.DisplayTrait;
import guise.traits.core.ISize;
import js.Dom;
import js.Lib;

/**
 * ...
 * @author Tom Byrne
 */

class ButtonTrait extends DisplayTrait
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
			_checkbox = cast Lib.document.createElement("input");
			_checkbox.setAttribute("type", "checkbox");
			_checkbox.onclick = onCheckboxClick;
			_button.appendChild(_checkbox);
			
			selected.selectedChanged.add(onSelectedChanged);
			onSelectedChanged(selected);
		}else if (_checkbox != null) {
			_button.removeChild(_checkbox);
			_checkbox = null;
		}
		return value;
	}
	
	private var _button:HtmlDom;
	private var _checkbox:Checkbox;
	private var _innerElement:HtmlDom;
	private var _labelElement:HtmlDom;

	public function new() 
	{
		_allowSizing = true;
		_button = Lib.document.createElement("button");
		super(_button);
		_labelElement = Lib.document.createElement("label");
		_button.appendChild(_labelElement);
	}
	
	override private function onSizeChanged(from:IDisplayPosition):Void {
		trace("sizeChanged");
		super.onSizeChanged(from);
	}
	
	private function onTextChanged(from:ITextLabel):Void {
		_labelElement.innerHTML = from.text;
	}
	
	private function onSelectedChanged(from:ISelected):Void {
		_checkbox.checked = selected.selected;
	}
	private function onCheckboxClick(e:Event):Void {
		onSelectedChanged(selected);
	}
}