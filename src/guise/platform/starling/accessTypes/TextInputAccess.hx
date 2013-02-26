package guise.platform.starling.accessTypes;
import composure.traits.AbstractTrait;
import guise.accessTypes.IFocusableAccess;
import guise.accessTypes.IMouseInteractionsAccess;
import guise.accessTypes.ITextInputAccess;
import guise.accessTypes.ITextOutputAccess;
import guise.platform.cross.IAccessRequest;
import guise.platform.starling.display.StageTrait;
import guise.platform.starling.TextFieldGutter;
import msignal.Signal;
import flash.text.TextField;
import flash.text.TextFieldType;
import flash.ui.Mouse;
import flash.ui.MouseCursor;
import flash.geom.Matrix;
import flash.events.Event;
import flash.events.FocusEvent;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import starling.utils.HAlign;


class TextInputAccess extends AbstractTrait implements ITextInputAccess implements IAccessRequest implements IFocusableAccess
{
	private static var ACCESS_TYPES:Array<Class<Dynamic>> = [ITextOutputAccess, IMouseInteractionsAccess];
	private static var DUMMY_MATRIX:Matrix;
	
	@lazyInst
	public var textChanged:Signal1 < ITextInputAccess >;
	
	@lazyInst
	public var focusedChanged:Signal1 < IFocusableAccess >;
	
	@:isVar public var layerName(default, set):String;
	private function set_layerName(value:String):String {
		this.layerName = value;
		return value;
	}
	
	@:isVar public var focused(default, null):Bool ;
	
	private var _textField:TextField;
	private var _textOutput:TextOutputAccess;
	private var _mouseInt:IMouseInteractionsAccess;

	public function new(?layerName:String){
		super();
		this.layerName = layerName;
		_textField = new TextField();
		_textField.type = TextFieldType.INPUT;
		//_textField.border = true;
		_textField.addEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
		_textField.addEventListener(Event.CHANGE, onInputChange);
	}
	@injectAdd
	private function onTextOutputAdd(access:TextOutputAccess):Void {
		if (layerName != null && access.layerName != layerName) return;
		
		_textOutput = access;
		_textOutput.textRunChanged.add(onTextRunChanged);
		
		LazyInst.exec(textChanged.dispatch(this));
	}
	@injectRemove
	private function onTextOutputRemove(access:TextOutputAccess):Void {
		if (access != _textOutput) return;
		
		_textOutput.textRunChanged.remove(onTextRunChanged);
		_textOutput = null;
		
		LazyInst.exec(textChanged.dispatch(this));
	}
	@injectAdd
	private function onMouseIntAdd(access:IMouseInteractionsAccess):Void {
		if (layerName != null && access.layerName != layerName) return;
		
		_mouseInt = access;
		
		_mouseInt.pressed.add(onPressed);
		_mouseInt.rolledOver.add(onRolledOver);
		_mouseInt.rolledOut.add(onRolledOut);
	}
	@injectRemove
	private function onMouseIntRemove(access:IMouseInteractionsAccess):Void {
		if (access != _mouseInt) return;
		
		_mouseInt.pressed.remove(onPressed);
		_mouseInt.rolledOver.remove(onRolledOver);
		_mouseInt.rolledOut.remove(onRolledOut);
		_mouseInt = null;
	}
	private function onTextRunChanged(from:ITextOutputAccess):Void {
		var starField = _textOutput.textField;
		_textField.text = starField.text;
		
		var align:TextFormatAlign;
		switch(starField.hAlign) {
			case HAlign.LEFT: align = TextFormatAlign.LEFT;
			case HAlign.CENTER: align = TextFormatAlign.CENTER;
			case HAlign.RIGHT: align = TextFormatAlign.RIGHT;
			default: align = null;
		}
		starField.getTransformationMatrix(starField.stage, DUMMY_MATRIX);
		_textField.transform.matrix = DUMMY_MATRIX;
		
		
		_textField.setTextFormat(new TextFormat(starField.fontName, starField.fontSize, starField.color, starField.bold, starField.italic, starField.underline, null, null, align));
		if (starField.text == "") {
			if (starField.height <= 1) {
				_textField.height = _textField.textHeight;
			}else {
				_textField.height = starField.height;
			}
		}else{
			var realFontSize:Float = starField.fontSize / _textField.textHeight * (_textOutput.textHeight+TextFieldGutter.H_GUTTER*2);
			_textField.setTextFormat(new TextFormat(null, realFontSize, null, null, null, null, null, null, null));
			_textField.height = starField.height * starField.fontSize / realFontSize;
		}
		
		_textField.width = starField.width;
		_textField.y -= _textField.height - starField.height;
		
		LazyInst.exec(textChanged.dispatch(this) );
	}
	private function onPressed(info:MouseInfo):Void {
		if (DUMMY_MATRIX == null) {
			DUMMY_MATRIX = new Matrix();
		}
		if (focused) return;
		
		focused = true;
		LazyInst.exec(focusedChanged.dispatch(this));
		
		var starField = _textOutput.textField;
		starField.visible = false;
		_textField.selectable = _textOutput.selectable;
		
		flash.Lib.current.stage.addChild(_textField);
		flash.Lib.current.stage.focus = _textField;
	}
	private function onRolledOver(info:MouseInfo):Void {
		Mouse.cursor = MouseCursor.IBEAM;
	}
	private function onRolledOut(info:MouseInfo):Void {
		Mouse.cursor = MouseCursor.AUTO;
	}
	
	private function onFocusOut(e:FocusEvent):Void {
		if (focused) {
			focused = false;
			LazyInst.exec(focusedChanged.dispatch(this));
			
			_textOutput.textField.visible = true;
			flash.Lib.current.stage.removeChild(_textField);
		}
	}
	
	private function onInputChange(e:Event):Void {
		LazyInst.exec(textChanged.dispatch(this));
	}
	
	public function getText():String {
		return _textField.text;
	}
	
	@:isVar public var inputEnabled(default, set):Bool;
	private function set_inputEnabled(value:Bool):Bool {
		this.inputEnabled = value;
		return value;
	}
	
	
	public function getAccessTypes():Array<Class<Dynamic>> {
		return ACCESS_TYPES;
	}
}