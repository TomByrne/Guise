package guise.skin.values;
import guise.accessTypes.ITextOutputAccess;

class TextWidth extends Bind
{

	public function new(?modifier:Float->Float) 
	{
		super(ITextOutputAccess, "textWidth", "textMeasChanged", modifier);
	}
	
}