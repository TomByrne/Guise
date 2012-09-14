package guise.core;
import composure.traits.AbstractTrait;
import guise.traits.core.IPosition;

/**
 * ...
 * @author Tom Byrne
 */

class AbsPosAwareTrait extends AbstractTrait
{
	public var position(default, null):IPosition;
	public var posExplicit(default, set_posExplicit):IPosition;
	private function set_posExplicit(value:IPosition):IPosition {
		this.posExplicit = value;
		assessPosition();
		return value;
	}
	/**
	 * @private
	 */
	@inject
	public var posInjected(default, set_posInjected):IPosition;
	private function set_posInjected(value:IPosition):IPosition {
		this.posInjected = value;
		assessPosition();
		return value;
	}
	private function assessPosition():Void {
		var newPos:IPosition = (posExplicit != null?posExplicit:posInjected);
		if (newPos != position) {
			if (position!=null) {
				position.posChanged.remove(onPosChanged);
			}
			position = newPos;
			if (position!=null) {
				position.posChanged.add(onPosChanged);
				onPosChanged(position);
			}
		}
	}

	public function new() 
	{
		super();
	}
	
	private function onPosChanged(position:IPosition):Void {
		posChanged();
	}
	private function posChanged():Void {
		// override me
	}
}