package guise.platform.html5.controls;

import composure.core.ComposeItem;
import guise.controls.data.IInputPrompt;
import guise.controls.data.IListCollection;
import guise.controls.data.ITextLabel;
import guise.platform.html5.display.ContainerTrait;
import guise.platform.html5.display.DisplayTrait;
import js.Dom;
import js.Lib;

using Lambda;

class ComboBoxTrait extends DropDownTrait
{
	@inject
	@:isVar public var textPrompt(default, set_textPrompt):IInputPrompt;
	private function set_textPrompt(value:IInputPrompt):IInputPrompt {
		if (textPrompt != null) {
			textPrompt.promptChanged.remove(onPromptChanged);
		}
		this.textPrompt = value;
		if (textPrompt != null) {
			textPrompt.promptChanged.add(onPromptChanged);
			onPromptChanged(textPrompt);
		}else {
			untyped _textInput.placeholder = "";
		}
		return value;
	}
	
	private function onPromptChanged(from:IInputPrompt):Void {
		untyped _textInput.placeholder = from.prompt;
	}
	
	
	private var _textInput:Text;
	
	private var _padTop:Int;
	private var _padLeft:Int;
	private var _padRight:Int;
	private var _padBottom:Int;

	public function new() 
	{
		
		// add in browser specific paddings here (if needed)
		_padTop = 1;
		_padLeft = 2;
		_padRight = 19;
		_padBottom = 3;
		
		super();
	}
	
	
	override private function createSelectElement():HtmlDom {
		var container:HtmlDom = Lib.document.createElement("div");
		_select = cast Lib.document.createElement("select");
		_select.onchange = onSelect;
		container.appendChild(_select);
		
		_textInput = cast Lib.document.createElement("input");
		_textInput.style.position = "absolute";
		_textInput.style.top = _padTop+"px";
		_textInput.style.left = _padLeft+"px";
		_textInput.style.backgroundColor = "transparent";
		_textInput.style.borderColor = "transparent";
		_textInput.style.borderWidth = "0px";
		container.appendChild(_textInput);
		
		return container;
	}
	
	private function onSelect(e:Event):Void {
		if(_select.selectedIndex>=0){
			_textInput.value = _textLabels[_select.selectedIndex].text;
		}else {
			_textInput.value = "";
		}
		_select.selectedIndex = -1;
	}
	override private function compileItems():Void {
		super.compileItems();
		_select.selectedIndex = -1;
	}
	override private function onParentAdded(parent:ContainerTrait):Void {
		super.onParentAdded(parent);
		// On most browsers setting selectedIndex before adding to DOM doesn't do anything
		_select.selectedIndex = -1;
	}
	
	override private function _setSize(w:Float, h:Float):Void {
		if (!_allowSizing) return;
		
		if (!Math.isNaN(w) && !Math.isNaN(h)) {
			_select.style.width = Std.int(w) + "px";
			_select.style.height = Std.int(h) + "px";
			_textInput.style.width = Std.int(w-_padLeft-_padRight) + "px";
			_textInput.style.height = Std.int(h-_padBottom-_padTop) + "px";
		}else {
			_select.style.width = null;
			_select.style.height = null;
			_textInput.style.width = null;
			_textInput.style.height = null;
		}
	}
	
	override private function checkMeas():Void{
		var wWas = _textInput.style.width;
		var hWas = _textInput.style.height;
		var pWas = _textInput.style.position;
		_textInput.style.width = null;
		_textInput.style.height = null;
		_textInput.style.position = "fixed";
		var measWidth:Float = _textInput.offsetWidth+_padLeft+_padRight;
		var measHeight:Float = _textInput.offsetHeight+_padTop+_padBottom;
		_textInput.style.width = wWas;
		_textInput.style.height = hWas;
		_textInput.style.position = pWas;
		
		wWas = _select.style.width;
		hWas = _select.style.height;
		pWas = _select.style.position;
		_select.style.width = null;
		_select.style.height = null;
		_select.style.position = "fixed";
		if(measWidth<_select.offsetWidth)measWidth = _select.offsetWidth;
		if(measHeight<_select.offsetHeight)measHeight = _select.offsetHeight;
		_select.style.width = wWas;
		_select.style.height = hWas;
		_select.style.position = pWas;
		
		setMeas(measWidth, measHeight);
	}
}