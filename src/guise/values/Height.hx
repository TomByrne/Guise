package guise.values;
import guise.layout.IBoxPos;

class Height extends Bind
{

	public function new(?modifier:Float->Float) 
	{
		super(IBoxPos, "h", "sizeChanged", modifier);
	}
	
}