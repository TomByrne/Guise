package guise.accessTypes;

interface IBoxPosAccess extends IPositionAccess {
	public function set(x:Float, y:Float, w:Float, h:Float):Void;
	public function setSize(w:Float, h:Float):Void;
}