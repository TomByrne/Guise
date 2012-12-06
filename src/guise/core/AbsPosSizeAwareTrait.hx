package guise.core;
import guise.traits.core.ISize;
import guise.core.AbsSizeAwareTrait;
/**
 * ...
 * @author Tom Byrne
 */

class AbsPosSizeAwareTrait extends AbsPosAwareTrait
{
	
	public var size(get_size, null):ISize;
	private function get_size():ISize {
		return _sizeAware.size;
	}
	
	public var sizeExplicit(get_sizeExplicit, set_sizeExplicit):ISize;
	private function get_sizeExplicit():ISize {
		return _sizeAware.sizeExplicit;
	}
	private function set_sizeExplicit(value:ISize):ISize {
		return _sizeAware.sizeExplicit = value;
	}
	
	private var _sizeAware:AbsSizeAwareTrait;

	public function new() 
	{
		super();
		addSiblingTrait(_sizeAware = new AbsSizeAwareTrait(sizeChanged));
	}
	
	private function sizeChanged():Void {
		// override me
		trace("sizeChanged");
		var width:Float = size.width;
		var height:Float = size.height;
		if (!Math.isNaN(width) && width > 0 && !Math.isNaN(height) && height > 0) {
			sizeChangedValid(width, height);
		}else {
			sizeChangedInvalid();
		}
	}
	private function sizeChangedValid(width:Float, height:Float):Void {
		// override me
	}
	private function sizeChangedInvalid():Void {
		// override me
	}
}