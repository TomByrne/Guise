package guise.skin.drawn.utils;
import guise.platform.GeomApi;
import guise.accessTypes.IGraphicsAccess;
import guise.platform.GraphicsApi;


class DrawnStyles 
{
	
}
enum FillStyle {
	FsNone;
	FsMulti(fs:Array<FillStyle>);
	FsTransparent; // blocks clicks
	FsSolid(c:Int, ?a:Float);
	FsLinearGradient(colors : Array<UInt>, alphas : Array<Float>, ratios : Array<Float>, ?mat:Matrix);
	FsRadialGradient(colors : Array<UInt>, alphas : Array<Float>, ratios : Array<Float>, ?mat:Matrix, ?focalPointRatio:Float);
	FsHLinearGradient(colors : Array<UInt>, alphas : Array<Float>, ratios : Array<Float>);
	FsVLinearGradient(colors : Array<UInt>, alphas : Array<Float>, ratios : Array<Float>);
}
enum StrokeStyle {
	SsNone;
	SsSolid(th:Float, fill:FillStyle , ?joints:JointStyle);
}
enum HAlign {
	Left;
	Center;
	Right;
}
enum VAlign {
	Top;
	Middle;
	Bottom;
}