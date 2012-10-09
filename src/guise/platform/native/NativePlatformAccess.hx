package guise.platform.native;

import composure.core.ComposeItem;


/**
 * ...
 * @author Tom Byrne
 */

 
class NativePlatformAccess
{
	public static function install(within:ComposeItem){
		
		#if js
			guise.platform.html.HtmlPlatformAccess.install(within);
		#elseif waxe
			// Waxe fallback
			//guise.platform.waxe.WaxePlatformAccess.install(within);
		#elseif nme
			// NME fallback
			guise.platform.nme.NmePlatformAccess.install(within);
			guiseSkins.styled.styles.ChutzpahStyle.install(within);
		#end
	}
}