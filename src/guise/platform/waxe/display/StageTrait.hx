package guise.platform.waxe.display;

/**
 * ...
 * @author Tom Byrne
 */

class StageTrait extends ContainerTrait
{
	

	public function new() 
	{
		super();
		setDisplay(ApplicationMain.frame);
	}
	
}