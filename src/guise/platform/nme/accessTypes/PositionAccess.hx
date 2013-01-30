package guise.platform.nme.accessTypes;

import composure.traits.AbstractTrait;
import guise.accessTypes.IBoxPosAccess;
import nme.display.DisplayObject;
import guise.platform.nme.accessTypes.AdditionalTypes;


class PositionAccess extends AbstractTrait, implements IBoxPosAccess
{
	@inject
	public var displayType(default, set_displayType):IDisplayObjectType;
	private function set_displayType(value:IDisplayObjectType):IDisplayObjectType{
		if (value!=null) {
			display = value.getDisplayObject();
			if (_posSet) {
				display.x = _x;
				display.y = _y;
			}
			if (_sizeSet) {
				display.width = _w;
				display.height = _h;
			}
		}else {
			display = null;
		}
		this.displayType = value;
		return value;
	}
	
	private var display:DisplayObject;
	private var _posSet:Bool;
	private var _sizeSet:Bool;
	private var _x:Float;
	private var _y:Float;
	private var _w:Float;
	private var _h:Float;
	
	public var layerName:String;

	public function new(?display:DisplayObject, ?layerName:String) 
	{
		super();
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
			display.x = x;
			display.y = y;
			display.width = w;
			display.height = h;
		}
	}
	
	public function setPos(x:Float, y:Float):Void {
		_x = x;
		_y = y;
		_posSet = true;
		
		if (display != null) {
			display.x = x;
			display.y = y;
		}
	}
	
	public function setSize(w:Float, h:Float):Void {
		_w = w;
		_h = h;
		_sizeSet = true;
		
		if (display != null) {
			display.width = w;
			display.height = h;
		}
	}
}