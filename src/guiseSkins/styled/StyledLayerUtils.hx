package guiseSkins.styled;

import guise.platform.types.DrawingAccessTypes;
import guiseSkins.styled.Styles;
import guise.geom.Matrix;
/**
 * ...
 * @author Tom Byrne
 */

class StyledLayerUtils 
{

	public static function getPos(p:Pos, width:Float, height:Float, defaultValue:Float):Float 
	{
		if (p == null) return defaultValue;
		switch(p) {
			case Fixed(value):
				return value;
			case FromWidth(multi, offset):
				return transform(width, multi, offset);
			case FromHeight(multi, offset):
				return transform(height, multi, offset);
			case MinDimension(multi, offset):
				return transform(width<height?width:height, multi, offset);
			case MaxDimension(multi, offset):
				return transform(width>height?width:height, multi, offset);
		}
	}
	private inline static function transform(value:Float, multi:Float, offset:Float):Float 
	{
		if (!Math.isNaN(multi)) {
			value *= multi;
		}
		if (!Math.isNaN(offset)) {
			value += offset;
		}
		return value;
	}
	
	
	
	public static function beginFillStrokes(graphics:IGraphics, fill:FillStyle, stroke:StrokeStyle, width:Float, height:Float, iterationHandler:Int->Void):Void {
		var fills = [];
		collectFills(fill, fills);
		var strokeFills;
		switch(stroke) {
			case SsSolid(th, sFill, joints):
				if (joints == null) joints = JointStyle.JoRound;
				graphics.lineStyle(th, true, null, joints);
				strokeFills = [];
				collectFills(sFill, strokeFills);
			case SsNone:
				strokeFills = null;
				//ignore
		}
		var drawRuns:Int = (strokeFills == null || fills.length > strokeFills.length?fills.length:strokeFills.length);
		for (i in 0 ... drawRuns) {
			if (i < fills.length) {
				switch(fills[i]) {
					case FsSolid(c, a):
						if (Math.isNaN(a) || a==null) a = 1.0;
						graphics.beginFill(c, a);
					case FsLinearGradient(gp, mat):
						graphics.beginGradientFill(Linear, gp, mat);
					case FsHLinearGradient(gp):
						graphics.beginGradientFill(Linear, gp, createBoxMatrix(Math.PI/2, width, height));
					case FsVLinearGradient(gp):
						graphics.beginGradientFill(Linear, gp, createBoxMatrix(0, width, height));
					case FsRadialGradient(gp, mat, fp):
						graphics.beginGradientFill(Radial(fp), gp, mat);
					case FsTransparent:
						graphics.beginFill(0, 0);
					default:
						// ignore
				}
			}
			if(strokeFills!=null && i<strokeFills.length){
				switch(strokeFills[i]) {
					case FsSolid(c, a):
						if (Math.isNaN(a) || a==null) a = 1.0;
						graphics.beginStroke(c, a);
					case FsLinearGradient(gp, mat):
						graphics.beginGradientStroke(Linear, gp, mat);
					case FsHLinearGradient(gp):
						graphics.beginGradientStroke(Linear, gp, createBoxMatrix(Math.PI/2, width, height));
					case FsVLinearGradient(gp):
						graphics.beginGradientStroke(Linear, gp, createBoxMatrix(0, width, height));
					case FsRadialGradient(gp, mat, focal):
						graphics.beginGradientStroke(Radial(focal), gp, mat);
					default:
						// ignore
				}
			}
			iterationHandler(i);
		}
	}
	private static function collectFills(fill:FillStyle, fills:Array<FillStyle>):Void {
		switch(fill) {
			case FsMulti(fills2):
				for (fill2 in fills2) {
					collectFills(fill2,fills);
				}
			case FsNone:
			default:
				fills.push(fill);
		}
	}
	private static function createBoxMatrix(rotation:Float, width:Float, height:Float):Matrix {
		var ret:Matrix = new Matrix();
		ret.createGradientBox(width, height, rotation, 0, 0);
		return ret;
	}
}