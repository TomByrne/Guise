package guiseSkins.styled;
import guise.geom.Matrix;
import guise.accessTypes.IGraphicsAccess;

/**
 * ...
 * @author Tom Byrne
 */

class Styles 
{
	
}
typedef GradPoint = { fract:Float, c:Int, a:Float };
enum FillStyle {
	FsNone;
	FsMulti(fs:Array<FillStyle>);
	FsTransparent; // blocks clicks
	FsSolid(c:Int, ?a:Float);
	FsLinearGradient(gp:Array<GradPoint>, ?mat:Matrix);
	FsRadialGradient(gp:Array<GradPoint>, ?mat:Matrix, ?focalPointRatio:Float);
	FsHLinearGradient(gp:Array<GradPoint>);
	FsVLinearGradient(gp:Array<GradPoint>);
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