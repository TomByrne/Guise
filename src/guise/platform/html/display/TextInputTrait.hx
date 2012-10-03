package guise.platform.html.display;
import guise.controls.data.ITextLabel;
import guise.controls.data.ISelected;
import guise.platform.IPlatformAccess;
import msignal.Signal;
import js.Lib;
import js.Dom;

/**
 * ...
 * @author Tom Byrne
 */

class TextInputTrait extends DomElementTrait, implements IFocusableAccess
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
	
	private var _textInput:HtmlDom;
	private var _checkbox:HtmlDom;
	private var _innerElement:HtmlDom;

	public function new() 
	{
		_textInput = Lib.document.createElement("input");
		_textInput.setAttribute("type", "text");
		_innerElement = _textInput;
		super(_textInput);
		
		_textInput.onfocus = onFocusIn;
		_textInput.onblur = onFocusOut;
		
		_allowSizing = true;
	}
	
	private function onFocusIn(e:Event):Void {
		this.focused = true;
		LazyInst.exec(focusedChanged.dispatch(this));
	}
	private function onFocusOut(e:Event):Void {
		this.focused = false;
		LazyInst.exec(focusedChanged.dispatch(this));
	}
	
	private function onTextChanged(from:ITextLabel):Void {
		_innerElement.innerHTML = from.text;
	}
	public var focused(default, null):Bool;
	
	@lazyInst
	public var focusedChanged(default, null):Signal1 < IFocusableAccess > ;
}