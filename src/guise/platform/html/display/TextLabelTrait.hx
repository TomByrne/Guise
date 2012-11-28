package guise.platform.html.display;
import composure.traits.AbstractTrait;
import guise.controls.data.ITextLabel;
import js.Lib;
import js.Dom;

/**
 * ...
 * @author Tom Byrne
 */

class TextLabelTrait extends AbstractTrait
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
	public var domElement(get_domElement, null):HtmlDom;
	private function get_domElement():HtmlDom {
		return _domElement;
	}
	
	
	private var _domElement:HtmlDom;

	public function new(domElement:HtmlDom){
		super();
		_domElement = domElement;
	}
	
	private function onTextChanged(from:ITextLabel):Void {
		_domElement.innerHTML = from.text;
	}
}