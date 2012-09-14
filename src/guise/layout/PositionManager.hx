package guise.layout;
import guise.layout.AbstractLayout;
/**
 * ...
 * @author Tom Byrne
 */

class PositionManager extends AbstractLayout<Position>
{

	public function new() 
	{
		super(Position);
	}
	
	override private function layoutChild(trait:Position):Void {
		var positionables:Iterable<IPositionable> = getPositionables(getItem(trait));
		for (pos in positionables) {
			pos.setPosition(trait.x,trait.y,trait.w,trait.h);
		}
	}
}
