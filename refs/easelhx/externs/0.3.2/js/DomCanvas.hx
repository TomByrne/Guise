// from http://code.google.com/p/udraw/
/**
 * ...
 * @author Franco Ponticelli
 */

package js;

import js.Dom;

typedef DomCanvas = {> HtmlDom,
	width : Int,
	height : Int,
	getContext : String -> Dynamic
}