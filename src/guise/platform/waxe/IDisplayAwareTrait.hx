package guise.platform.waxe;
import guise.platform.waxe.display.DisplayTrait;
/**
 * ...
 * @author Tom Byrne
 */

interface IDisplayAwareTrait 
{

	public function displaySet(display:DisplayTrait):Void ;
	public function displayClear(display:DisplayTrait):Void ;
	
}