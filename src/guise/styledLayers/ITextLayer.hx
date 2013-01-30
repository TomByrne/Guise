package guise.styledLayers;

import guise.accessTypes.IFilterableAccess;
import guise.accessTypes.ITextOutputAccess;
import guise.accessTypes.IFocusableAccess;


interface ITextLayer implements IDisplayLayer
{

	public var filterAccess(default, set_filterAccess):IFilterableAccess;
	public var textAccess(default, set_textAccess):ITextOutputAccess;
	public var focusableAccess(default, set_focusableAccess):IFocusableAccess;
	
}