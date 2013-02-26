package guise.platform.html5.controls;
import guise.controls.data.ISelected;
import guise.controls.data.ITextLabel;
import guise.layout.IBoxPos;
import guise.platform.html5.display.DisplayTrait;
import js.Dom;
import js.Browser;


class TextLabelTrait extends DisplayTrait
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
	
	private var _element:HtmlDom;
	private var _innerElement:HtmlDom;

	public function new(elementType:String="label") 
	{
		_allowSizing = true;
		_element = Browser.document.createElement(elementType);
		super(_element);
	}
	
	private function onTextChanged(from:ITextLabel):Void {
		_element.innerHTML = from.text;
	}
}