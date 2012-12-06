package guise.styledLayers;

import guise.platform.types.DrawingAccessTypes;
import guise.platform.types.DisplayAccessTypes;

/**
 * ...
 * @author Tom Byrne
 */

interface IGraphicsLayer implements IDisplayLayer
{
	public var filterAccess(default, set_filterAccess):IFilterableAccess;
	public var graphicsAccess(default, set_graphicsAccess):IGraphics;
	public var positionAccess(default, set_positionAccess):IPositionAccess;
	
}