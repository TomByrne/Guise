package guise.styledLayers;

import guise.platform.types.TextAccessTypes;
import guise.platform.types.DisplayAccessTypes;

/**
 * ...
 * @author Tom Byrne
 */

interface ITextLayer implements IDisplayLayer
{

	public var filterAccess(default, set_filterAccess):IFilterableAccess;
	public var textAccess(default, set_textAccess):ITextOutputAccess;
	
}