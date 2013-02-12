package guise.platform.native;

import composure.core.ComposeItem;
import xmlTools.XmlToCode;


 
class NativePlatformAccess
{
	public static function install(within:ComposeItem){
		
		#if js
			XmlToCode.path("/../../../../Platforms/HTML5.xml").install(within);
		#elseif waxe
			// Waxe fallback
			XmlToCode.path("/../../../../Platforms/Waxe.xml").install(within);
		#elseif nme
			// NME fallback
			XmlToCode.path("/../../../../Platforms/NME.xml").install(within);
			XmlToCode.path("/../../../../Styles/Chutzpah.xml").install(within);
		#end
	}
}