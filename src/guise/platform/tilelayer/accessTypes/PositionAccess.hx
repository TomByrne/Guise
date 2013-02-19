package guise.platform.tilelayer.accessTypes;

import composure.traits.AbstractTrait;
import guise.accessTypes.IBoxPosAccess;
import guise.platform.nme.TextFieldGutter;
import guise.platform.tilelayer.addTypes.ITileBaseType;
import aze.display.TileLayer;


class PositionAccess extends AbstractTrait, implements IBoxPosAccess
{
	@inject
	public var displayType(default, set_displayType):ITileBaseType;
	private function set_displayType(value:ITileBaseType):ITileBaseType{
		if (value!=null) {
			display = value.getTileBase();
			if (_posSet) {
				display.x = _x+display.getView().width/2;
				display.y = _y+display.getView().height/2;
			}
			/*if (_sizeSet) {
				display.width = _w;
				display.height = _h;
			}*/
		}else {
			display = null;
		}
		this.displayType = value;
		return value;
	}
	
	private var display:TileBase;
	private var _posSet:Bool;
	private var _sizeSet:Bool;
	private var _x:Float;
	private var _y:Float;
	private var _w:Float;
	private var _h:Float;
	
	public var layerName(default, set_layerName):String;
	private function set_layerName(value:String):String {
		this.layerName = value;
		return value;
	}

	public function new(?display:TileBase, ?layerName:String) 
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
			display.x = _x+display.getView().width/2;
			display.y = _y+display.getView().height/2;
			/*display.width = _w;
			display.height = _h;*/
		}
	}
	
	public function setPos(x:Float, y:Float):Void {
		_x = x;
		_y = y;
		_posSet = true;
		
		if (display != null) {
			display.x = _x+display.getView().width/2;
			display.y = _y+display.getView().height/2;
		}
	}
	
	public function setSize(w:Float, h:Float):Void {
		_w = w;
		_h = h;
		_sizeSet = true;
		
		/*if (display != null) {
			display.width = w;
			display.height = h;
		}*/
	}
}