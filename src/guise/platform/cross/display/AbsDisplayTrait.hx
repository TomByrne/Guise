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
	
	private function onPosSizeChanged(from:IDisplayPosition):Void {
		// override me if drawing requires both pos and size
		onPosChanged(from);
		onSizeChanged(from);
	}
	private function onPosChanged(from:IDisplayPosition):Void {
		// override me
	}
	private function onSizeChanged(from:IDisplayPosition):Void {
		// override me
	}
}