package guise.platform.native;

import composure.core.ComposeItem;
import xmlTools.XmlToCode;


 
class NativePlatformAccess
{
	public static inline function install(within:ComposeItem){
		#if js
			XmlToCode.path("/../../../../Platforms/HTML5.xml").install(within);
		#elseif basisApple
			//XmlToCode.path("/../../../../Platforms/BasisApple.xml").install(within);
			XmlToCode.path("/../../../../Files/assets/BasisApple.xml").install(within);
		#elseif waxe
			// Waxe fallback
			XmlToCode.path("/../../../../Platforms/Waxe.xml").install(within);
		#elseif starling
			// Starling fallback
			XmlToCode.path("/../../../../Platforms/Starling.xml").install(within);
			XmlToCode.path("/../../../../Styles/Mani.xml").install(within);
		#elseif nme
			// NME fallback
			XmlToCode.path("/../../../../Styles/Chutzpah.xml").install(within);
			XmlToCode.path("/../../../../Platforms/NME.xml").install(within);
		#end
	}
}