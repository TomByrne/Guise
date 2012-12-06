package guise.platform.html5.display;

import js.Lib;

/**
 * ...
 * @author Tom Byrne
 */

class StageTrait extends ContainerTrait
{

	public function new() 
	{
		super(Lib.document.body);
	}
	
}