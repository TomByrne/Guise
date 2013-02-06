package guise.platform.native;

import composure.core.ComposeItem;
import xmlTools.CodeGenMacro;


 
class NativePlatformAccess
{
	public static function install(within:ComposeItem){
		
		#if js
			CodeGenMacro.path("/../../../../Platforms/HTML5.xml").install(within);
		#elseif waxe
			// Waxe fallback
			CodeGenMacro.path("/../../../../Platforms/Waxe.xml").install(within);
		#elseif nme
			// NME fallback
			CodeGenMacro.path("/../../../../Platforms/NME.xml").install(within);
			guise.skin.drawn.utils.ChutzpahStyle.install(within);
		#end
	}
}