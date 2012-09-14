package guise.platform.native;

import composure.core.ComposeItem;


/**
 * ...
 * @author Tom Byrne
 */

 
class NativePlatformAccess
{
	public static function install(within:ComposeItem){
		
		#if (html5 || html)
			guise.platform.html.HtmlPlatformAccess.install(within);
		#elseif nme
			// NME fallback
			guise.platform.nme.NmePlatformAccess.install(within);
			guiseSkins.styled.styles.ChutzpahStyle.install(within);
		#end
	}
}