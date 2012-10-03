package guise.platform.html.display;

import js.Lib;

/**
 * ...
 * @author Tom Byrne
 */

class DomDocumentTrait extends DomContainerTrait
{

	public function new() 
	{
		super(Lib.document.body);
	}
	
}