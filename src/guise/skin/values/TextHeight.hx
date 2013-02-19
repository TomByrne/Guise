package guise.skin.values;
import guise.accessTypes.ITextOutputAccess;

class TextHeight extends Bind
{

	public function new(?modifier:Float->Float) 
	{
		super(ITextOutputAccess, "textHeight", "textMeasChanged", modifier );
	}
	
}