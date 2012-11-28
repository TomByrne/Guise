package guiseSkins.styled;
import guise.geom.Matrix;
import guise.platform.types.DrawingAccessTypes;

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
enum Pos {
	Fixed(value:Float);
	FromWidth(?multi:Float, ?offset:Float);
	FromHeight(?multi:Float, ?offset:Float);
	MinDimension(?multi:Float, ?offset:Float);
	MaxDimension(?multi:Float, ?offset:Float);
}