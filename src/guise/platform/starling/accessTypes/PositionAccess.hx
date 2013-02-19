package guise.platform.starling.accessTypes;

import composure.traits.AbstractTrait;
import guise.accessTypes.IBoxPosAccess;
import guise.platform.nme.TextFieldGutter;
import guise.platform.starling.addTypes.IDisplayObjectType;
import guise.platform.starling.ext.Scale9Sprite;
import starling.display.DisplayObject;
import starling.text.TextField;


class PositionAccess extends AbstractTrait, implements IBoxPosAccess
{
	@inject
	public var displayType(default, set_displayType):IDisplayObjectType;
	private function set_displayType(value:IDisplayObjectType):IDisplayObjectType{
		this.displayType = value;
		if (value!=null) {
			display = value.getDisplayObject();
			_textMode = (Std.is(display, TextField));
			if (_posSet) doPos();
			if (_sizeSet) doSize();
		}else {
			display = null;
		}
		return value;
	}
	
	private var display:DisplayObject;
	private var _posSet:Bool;
	private var _sizeSet:Bool;
	private var _x:Float;
	private var _y:Float;
	private var _w:Float;
	private var _h:Float;
	private var _textFieldGutter:Float;
	private var _textMode:Bool;
	
	public var layerName(default, set_layerName):String;
	private function set_layerName(value:String):String {
		this.layerName = value;
		return value;
	}

	public function new(?display:DisplayObject, ?layerName:String) 
	{
		_textFieldGutter = TextFieldGutter.GUTTER;
		super();
		this.display = display;
		this.layerName =  layerName;
	}
	
	public function set(x:Float, y:Float, w:Float, h:Float):Void {
		_x = x;
		_y = y;
		_w = w;
		_h = h;
		_posSet = (!Math.isNaN(_x) && !Math.isNaN(_y));
		_sizeSet = (!Math.isNaN(_w) && !Math.isNaN(_h));
		
		if (display != null) {
			doPos();
			doSize();
		}
	}
	
	public function setPos(x:Float, y:Float):Void {
		_x = x;
		_y = y;
		_posSet = (!Math.isNaN(_x) && !Math.isNaN(_y));
		
		if (display != null) doPos();
	}
	
	public function setSize(w:Float, h:Float):Void {
		_w = w;
		_h = h;
		_sizeSet = (!Math.isNaN(_w) && !Math.isNaN(_h));
		
		if (display != null) doSize();
	}
	
	private function doPos():Void {
		if(_textMode){
			display.x = _x-_textFieldGutter;
			display.y = _y-_textFieldGutter;
		}else {
			display.x = _x;
			display.y = _y;
		}
	}
	private function doSize():Void {
		if (_textMode) {
			displayType.setSize(_w+_textFieldGutter*2, _h+_textFieldGutter*2);
		}else {
			displayType.setSize(_w, _h);
		}
	}
}