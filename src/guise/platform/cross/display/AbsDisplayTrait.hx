package guise.platform.cross.display;
import composure.traits.AbstractTrait;
import guise.layout.IDisplayPosition;

/**
 * ...
 * @author Tom Byrne
 */

class AbsDisplayTrait extends AbstractTrait
{
	
	@inject
	public var position(default, set_position):IDisplayPosition;
	private function set_position(value:IDisplayPosition):IDisplayPosition {
		if (position != null) {
			if (_posListen) {
				if (_sizeListen) {
					position.changed.remove(onPosSizeChanged);
				}else {
					position.posChanged.remove(onPosChanged2);
				}
			}else if (_sizeListen) {
				position.sizeChanged.remove(onSizeChanged2);
			}
		}
		
		this.position = value;
		
		if (position != null) {
			if (_posListen) {
				if (_sizeListen) {
					position.changed.add(onPosSizeChanged);
				}else {
					position.posChanged.add(onPosChanged2);
				}
			}else if (_sizeListen) {
				position.sizeChanged.add(onSizeChanged2);
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
	
	private function onPosSizeChanged(from:IDisplayPosition):Void {
		doPosChanged();
		doSizeChanged();
		onPosOrSizeChanged();
	}
	private function onPosOrSizeChanged():Void {
		// override me if drawing requires both pos and size
	}
	private function onPosChanged2(from:IDisplayPosition):Void {
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
	
	
	private function onSizeChanged2(from:IDisplayPosition):Void {
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