package guise.platform.waxe.display;
import composure.traits.AbstractTrait;
import guise.controls.data.ITextLabel;
import guise.controls.data.ISelected;
import guise.platform.waxe.IDisplayAwareTrait;
import wx.Button;

/**
 * ...
 * @author Tom Byrne
 */

class TextButtonTrait extends AbstractTrait, implements IDisplayAwareTrait
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
		/*if (selected != null) {
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
		}*/
		return value;
	}
	
	private var _button:Button;
	//private var _checkbox:HtmlDom;
	//private var _innerElement:HtmlDom;
	//private var _labelElement:HtmlDom;

	public function new() 
	{
		super();
		//_labelElement = Lib.document.createElement("label");
		//_button.appendChild(_labelElement);
	}
	
	private function onTextChanged(from:ITextLabel):Void {
		//_labelElement.innerHTML = from.text;
	}
	
	private function onSelectedChanged(from:ISelected):Void {
		//_checkbox.setAttribute("checked", selected.selected?"true":"false");
		//trace("onSelectedChanged: "+_checkbox.getAttribute("checked"));
	}
	/*private function onCheckboxClick(e:Event):Void {
		onSelectedChanged(selected);
	}*/
	public function displaySet(display:DisplayTrait):Void {
		trace("displaySet");
		_button = cast display.display;
	}
	public function displayClear(display:DisplayTrait):Void {
		trace("displayClear");
		_button = null;
	}
}