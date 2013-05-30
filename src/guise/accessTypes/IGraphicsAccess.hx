package guise.accessTypes;
import guise.platform.GraphicsApi;


interface IGraphicsAccess implements IVisualAccessType
{
	function drawGraphicsData(graphicsData:GraphArray<IGraphicsData>):Void;
	function clear():Void;
	
}
