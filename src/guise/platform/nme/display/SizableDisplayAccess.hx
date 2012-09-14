package guise.platform.nme.display;
import guise.traits.core.IPosition;
import guise.traits.core.ISize;
import guise.platform.types.DisplayAccessTypes;
import nme.display.DisplayObject;
import nme.events.Event;
import nme.text.TextField;
import msignal.Signal;
/**
 * ...
 * @author Tom Byrne
 */

class SizableDisplayAccess implements ISizableDisplayAccess
{
	private static var TEXT_FIELD_GUTTER:Float = 2;
	
	public var measChanged(get_measChanged, null):Signal1<ISizableDisplayAccess>;
	private function get_measChanged():Signal1<ISizableDisplayAccess> {
		if (measChanged == null) measChanged = new Signal1();
		return measChanged;
	}
	
	private var _position:IPosition;
	private var _size:ISize;
	private var _displays:Array<DisplayObject>;
	private var _textFields:Array<TextField>;
	private var _measWidth:Float;
	private var _measHeight:Float;
	private var _measInvalid:Bool = false;
	

	public function new() 
	{
		_displays = [];
		_textFields = [];
	}
	
	public function addDisplay(display:DisplayObject):Void {
		if (Std.is(display, TextField)) {
			var field:TextField = cast display;
			
			field.addEventListener(Event.CHANGE, onTextChanged);
			_textFields.push(field);
			if (_position != null) positionTextField(field);
			if (_size != null) sizeTextField(field);
		}else {
			_displays.push(display);
			if (_position != null) positionDisplay(display);
			if (_size != null) sizeDisplay(display);
		}
		invalidateMeas();
	}
	public function removeDisplay(display:DisplayObject):Void {
		if (Std.is(display, TextField)) {
			var field:TextField = cast display;
			field.removeEventListener(Event.CHANGE, onTextChanged);
			_textFields.remove(field);
		}else{
			_displays.remove(display);
		}
		invalidateMeas();
	}
	private function onTextChanged(e:Event):Void {
		invalidateMeas();
	}
	
	public function getMeasWidth():Float {
		validateMeas();
		return _measWidth;
	}
	public function getMeasHeight():Float {
		validateMeas();
		return _measHeight;
	}
	
	public function setPos(value:IPosition):Void {
		if (_position != null) {
			_position.posChanged.remove(onPosChanged);
		}
		_position = value;
		if (_position != null) {
			_position.posChanged.add(onPosChanged);
			onPosChanged(value);
		}
	}
	private function onPosChanged(from:IPosition):Void {
		for (field in _textFields) {
			positionTextField(field);
		}
		for (display in _displays) {
			positionDisplay(display);
		}
	}
	private function positionTextField(textField:TextField):Void {
		textField.x = _position.x-TEXT_FIELD_GUTTER;
		textField.y = _position.y-TEXT_FIELD_GUTTER;
	}
	private function positionDisplay(display:DisplayObject):Void {
		display.x = _position.x;
		display.y = _position.y;
	}
	
	
	public function setSize(value:ISize):Void {
		if (_size != null) {
			_size.sizeChanged.remove(onSizeChanged);
		}
		_size = value;
		if (_size != null) {
			_size.sizeChanged.add(onSizeChanged);
			onSizeChanged(value);
		}
	}
	private function onSizeChanged(from:ISize):Void {
		for (field in _textFields) {
			sizeTextField(field);
		}
		for (display in _displays) {
			sizeDisplay(display);
		}
	}
	private function sizeTextField(textField:TextField):Void {
		textField.width = _size.width+TEXT_FIELD_GUTTER*2;
		textField.height = _size.height+TEXT_FIELD_GUTTER*2;
	}
	private function sizeDisplay(display:DisplayObject):Void {
		display.width = _size.width;
		display.height = _size.height;
	}
	private function invalidateMeas():Void {
		_measInvalid = true;
		if (measChanged != null) measChanged.dispatch(this);
	}
	
	private function validateMeas():Void {
		if (!_measInvalid) return;
		
		_measInvalid = false;
		_measWidth = 0;
		_measHeight = 0;
		
		for (field in _textFields) {
			var tWidth:Float = field.textWidth;
			var tHeight:Float = field.textHeight;
			
			if (_measWidth < tWidth)_measWidth = tWidth;
			if (_measHeight < tHeight)_measHeight = tHeight;
		}
		for (display in _displays) {
			var dWidth:Float = display.width/display.scaleX;
			var dHeight:Float = display.height/display.scaleY;
			
			if (_measWidth < dWidth)_measWidth = dWidth;
			if (_measHeight < dHeight)_measHeight = dHeight;
		}
	}
}