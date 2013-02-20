package guise.controls.logic.input;
import composure.traits.AbstractTrait;
import guise.controls.data.ITextLabel;
import guise.accessTypes.ITextInputAccess;
import guise.accessTypes.IFocusableAccess;
import guise.controls.data.IInputPrompt;
import guise.accessTypes.IMouseInteractionsAccess;
import guise.platform.cross.IAccessRequest;


class TextInputPrompt extends AbstractTrait, implements IAccessRequest
{
	private static var ACCESS_TYPES:Array<Class<Dynamic>> = [ITextInputAccess,IFocusableAccess];
	
	@inject
	public var textLabel(default, set_textLabel):ITextLabel;
	private function set_textLabel(value:ITextLabel):ITextLabel {
		this.textLabel = value;
		if (_showingPrompt && textLabel!=null) {
			if(inputPrompt!=null)textLabel.set(inputPrompt.prompt);
		}
		return value;
	}
	
	@inject
	public var inputPrompt(default, set_inputPrompt):IInputPrompt;
	private function set_inputPrompt(inputPrompt:IInputPrompt):IInputPrompt {
		if (inputPrompt != null) {
			inputPrompt.promptChanged.remove(onPromptChanged);
		}
		this.inputPrompt = inputPrompt;
		if (inputPrompt != null) {
			inputPrompt.promptChanged.add(onPromptChanged);
			onPromptChanged(inputPrompt);
		}
		return inputPrompt;
	}
	
	private var _input:ITextInputAccess;
	private var _focus:IFocusableAccess;
	private var _showingPrompt:Bool;
	private var _ignoreChanges:Bool;
	private var _focused:Bool;
	
	@:isVar public var layerName(default, set_layerName):String;
	private function set_layerName(value:String):String {
		this.layerName = value;
		return value;
	}

	public function new(?layerName:String){
		super();
		
		this.layerName = layerName;
	}
	public function getAccessTypes():Array<Class<Dynamic>> {
		return ACCESS_TYPES;
	}
	
	@injectAdd
	private function onInputAdd(access:ITextInputAccess):Void {
		if (layerName != null && access.layerName != layerName) return;
		
		_input = access;
		access.inputEnabled = true;
		access.textChanged.add(onTextChanged);
		onTextChanged(access);
	}
	@injectRemove
	private function onInputRemove(access:ITextInputAccess):Void {
		if (access != _input) return;
		
		access.textChanged.remove(onTextChanged);
		_input = null;
	}
	@injectAdd
	private function onFocusAdd(access:IFocusableAccess):Void {
		if (layerName != null && access.layerName != layerName) return;
		
		_focus = access;
		access.focusedChanged.add(onFocusedChanged);
		onFocusedChanged(access);
	}
	@injectRemove
	private function onFocusRemove(access:IFocusableAccess):Void {
		if (access != _focus) return;
		
		access.focusedChanged.remove(onFocusedChanged);
		_focus = null;
	}
	private function onTextChanged(from:ITextInputAccess):Void {
		var text:String = from.getText();
		if(textLabel!=null)textLabel.set(text);
		if (!_focused && (text == null || text.length == 0)) {
			if(inputPrompt!=null)textLabel.set(inputPrompt.prompt);
			_showingPrompt = true;
		}
	}
	
	private function onPromptChanged(from:IInputPrompt):Void {
		var prompt:String = from.prompt;
		if (_showingPrompt && textLabel!=null) {
			textLabel.set(prompt);
		}
	}
	private function onFocusedChanged(from:IFocusableAccess):Void {
		_focused = from.focused;
		if(_focused){
			if (_showingPrompt) {
				textLabel.set("");
				_showingPrompt = false;
			}
		}else {
			if (!_showingPrompt && (textLabel==null || textLabel.text=="")) {
				if(inputPrompt!=null)textLabel.set(inputPrompt.prompt);
				_showingPrompt = true;
			}
		}
	}
}