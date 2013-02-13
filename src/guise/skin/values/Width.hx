package guise.skin.values;
import guise.layout.IBoxPos;

class Width extends Bind
{

	public function new(?modifier:Float->Float) 
	{
		super(IBoxPos, "w", "sizeChanged", modifier);
	}
	
}