package guise.platform.nme.accessTypes;

import composure.traits.AbstractTrait;
import guise.accessTypes.IBoxPosAccess;
import guise.platform.nme.TextFieldGutter;
import nme.display.DisplayObject;
import nme.text.TextField;
import guise.platform.nme.accessTypes.AdditionalTypes;


class PositionAccess extends AbstractTrait, implements IBoxPosAccess
{
	@inject
	public var displayType(default, set_displayType):IDisplayObjectType;
	private function set_displayType(value:IDisplayObjectType):IDisplayObjectType{
		if (value!=null) {
			display = value.getDisplayObject();
			textMode = Std.is(display, TextField);
			if(textMode){
				if (_posSet) {
					display.x = _x-_gutter;
					display.y = _y-_gutter;
				}
				if (_sizeSet) {
					display.width = _w+_gutter*2;
					display.height = _h+_gutter*2;
				}
			}else {
				if (_posSet) {
					display.x = _x;
					display.y = _y;
				}
				if (_sizeSet) {
					display.width = _w;
					display.height = _h;
				}
			}
		}else {
			display = null;
		}
		this.displayType = value;
		return value;
	}
	
	private var textMode:Bool;
	private var display:DisplayObject;
	private var _posSet:Bool;
	private var _sizeSet:Bool;
	private var _x:Float;
	private var _y:Float;
	private var _w:Float;
	private var _h:Float;
	private var _gutter:Float;
	
	public var layerName(default, set_layerName):String;
	private function set_layerName(value:String):String {
		this.layerName = value;
		return value;
	}

	public function new(?display:DisplayObject, ?layerName:String) 
	{
		super();
		_gutter = TextFieldGutter.GUTTER;
		this.display = display;
		this.layerName =  layerName;
	}
	
	public function set(x:Float, y:Float, w:Float, h:Float):Void {
		_x = x;
		_y = y;
		_w = w;
		_h = h;
		_posSet = true;
		_sizeSet = true;
		
		if (display != null) {
			if(textMode){
				display.x = x-_gutter;
				display.y = y-_gutter;
				display.width = w+_gutter*2;
				display.height = h+_gutter*2;
			}else {
				display.x = x;
				display.y = y;
				display.width = w;
				display.height = h;
			}
		}
	}
	
	public function setPos(x:Float, y:Float):Void {
		_x = x;
		_y = y;
		_posSet = true;
		
		if (display != null) {
			if(textMode){
				display.x = x-_gutter;
				display.y = y-_gutter;
			}else {
				display.x = x;
				display.y = y;
			}
		}
	}
	
	public function setSize(w:Float, h:Float):Void {
		_w = w;
		_h = h;
		_sizeSet = true;
		
		if (display != null) {
			if(textMode){
				display.width = w+_gutter*2;
				display.height = h+_gutter*2;
			}else {
				display.width = w;
				display.height = h;
			}
		}
	}
}