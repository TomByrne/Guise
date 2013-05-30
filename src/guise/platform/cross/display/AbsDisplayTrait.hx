package guise.platform.cross.display;
import composure.traits.AbstractTrait;
import guise.layout.IBoxPos;


class AbsDisplayTrait extends AbstractTrait
{
	
	@inject
	public var position(default, set_position):IBoxPos;
	private function set_position(value:IBoxPos):IBoxPos {
		if (position != null) {
			if (_posListen) {
				if (_sizeListen) {
					position.changed.remove(onPosSizeChanged);
				}else {
					position.posChanged.remove(onPosChanged);
				}
			}else if (_sizeListen) {
				position.sizeChanged.remove(onSizeChanged);
			}
		}
		
		this.position = value;
		
		if (position != null) {
			if (_posListen) {
				if (_sizeListen) {
					position.changed.add(onPosSizeChanged);
				}else {
					position.posChanged.add(onPosChanged);
				}
			}else if (_sizeListen) {
				position.sizeChanged.add(onSizeChanged);
			}
			onPosSizeChanged(position);
		}
		
		return value;
	}
	
	
	private var _posListen:Bool;
	private var _sizeListen:Bool;

	public function new() 
	{
		super();
	}
	
	private function onPosSizeChanged(from:IBoxPos):Void {
		doPosChanged();
		doSizeChanged();
		onPosOrSizeChanged();
	}
	private function onPosOrSizeChanged():Void {
		// override me if drawing requires both pos and size
	}
	private function onPosChanged(from:IBoxPos):Void {
		onPosOrSizeChanged();
		doPosChanged();
	}
	inline private function doPosChanged():Void {
		if (Math.isNaN(position.x) || Math.isNaN(position.y)) {
			onPosInvalid();
		}else {
			onPosValid(position.x, position.y);
		}
	}
	private function onPosInvalid():Void {
		// override me
	}
	private function onPosValid(x:Float, y:Float):Void {
		// override me
	}
	
	
	private function onSizeChanged(from:IBoxPos):Void {
		onPosOrSizeChanged();
		doSizeChanged();
	}
	inline private function doSizeChanged():Void {
		if (Math.isNaN(position.w) || Math.isNaN(position.h)) {
			onSizeInvalid();
		}else {
			onSizeValid(position.w, position.h);
		}
	}
	private function onSizeInvalid():Void {
		// override me
	}
	private function onSizeValid(w:Float, h:Float):Void {
		// override me
	}
}