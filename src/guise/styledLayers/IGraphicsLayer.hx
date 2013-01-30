package guise.styledLayers;

import guise.accessTypes.IFilterableAccess;
import guise.accessTypes.IGraphicsAccess;
import guise.accessTypes.IPositionAccess;

interface IGraphicsLayer implements IDisplayLayer
{
	public var filterAccess(default, set_filterAccess):IFilterableAccess;
	public var graphicsAccess(default, set_graphicsAccess):IGraphicsAccess;
	public var positionAccess(default, set_positionAccess):IPositionAccess;
	
}