package guise.accessTypes;

import guise.geom.Matrix;
#if nme
import nme.display.BitmapData;
#end
interface IBitmapGraphicsAccess implements IGraphicsAccess
{

	function beginBitmapFill(bitmap:BitmapData, matrix:Matrix = null, repeat:Bool = true, smooth:Bool = false):Void;
	function beginBitmapStroke(bitmap:BitmapData, matrix:Matrix = null, repeat:Bool = true, smooth:Bool = false):Void;
	
}