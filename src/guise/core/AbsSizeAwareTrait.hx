package guise.core;
import composure.traits.AbstractTrait;
import guise.traits.core.ISize;
/**
 * ...
 * @author Tom Byrne
 */

class AbsSizeAwareTrait extends AbstractTrait
{
	
	public var size(default, null):ISize;
	public var sizeExplicit(default, set_sizeExplicit):ISize;
	private function set_sizeExplicit(value:ISize):ISize {
		this.sizeExplicit = value;
		assessSize();
		return value;
	}
	/**
	 * @private
	 */
	@inject
	public var sizeInjected(default, set_sizeInjected):ISize;
	private function set_sizeInjected(value:ISize):ISize {
		this.sizeInjected = value;
		assessSize();
		return value;
	}
	private function assessSize():Void {
		var newSize:ISize = (sizeExplicit != null?sizeExplicit:sizeInjected);
		if (newSize != size) {
			if (size!=null) {
				size.sizeChanged.remove(onSizeChanged);
			}
			size = newSize;
			if (size!=null) {
				size.sizeChanged.add(onSizeChanged);
				onSizeChanged(size);
			}
		}
	}

	public function new(?sizeChanged:Void->Void, ?sizeChangedValid:Float->Float->Void, ?sizeChangedInvalid:Void->Void) 
	{
		super();
		
		if (sizeChanged != null) this.sizeChanged = sizeChanged;
		if (sizeChangedValid != null) this.sizeChangedValid = sizeChangedValid;
		if (sizeChangedInvalid != null) this.sizeChangedInvalid = sizeChangedInvalid;
	}
	private function onSizeChanged(size:ISize):Void {
		sizeChanged();
	}
	
	private dynamic function sizeChanged():Void {
		// override me
		var width:Float = size.width;
		var height:Float = size.height;
		if (!Math.isNaN(width) && width > 0 && !Math.isNaN(height) && height > 0) {
			sizeChangedValid(width, height);
		}else {
			sizeChangedInvalid();
		}
	}
	private dynamic function sizeChangedValid(width:Float, height:Float):Void {
		// override me
	}
	private dynamic function sizeChangedInvalid():Void {
		// override me
	}
}