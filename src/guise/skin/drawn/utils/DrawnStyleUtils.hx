package guise.skin.drawn.utils;

import guise.accessTypes.IGraphicsAccess;
import guise.skin.drawn.utils.DrawnStyles;
import guise.platform.GeomApi;
import guise.platform.GraphicsApi;
import guise.skin.drawn.BoxLayer;

class DrawnStyleUtils 
{

	public static function beginFillStrokes(fill:FillStyle, stroke:StrokeStyle, pixelHinting:Bool, width:Float, height:Float, addBetween:GraphArray<IGraphicsData>, ?addTo:GraphArray<IGraphicsData>):GraphArray<IGraphicsData> {
		
		if (addTo == null) addTo = new GraphArray<IGraphicsData>();
		
		var fills = [];
		collectFills(fill, fills);
		var strokeFills;
		var thickness;
		var joints;
		switch(stroke) {
			case SsSolid(th, sFill, j):
				if (j == null) joints = JointStyle.ROUND;
				else joints = j;
				
				strokeFills = [];
				collectFills(sFill, strokeFills);
				thickness = th;
			case SsNone:
				strokeFills = null;
				joints = null;
				thickness = 0;
				//ignore
		}
		var drawRuns:Int = (strokeFills == null || fills.length > strokeFills.length?fills.length:strokeFills.length);
		for (i in 0 ... drawRuns) {
			if (i < fills.length) {
				switch(fills[i]) {
					case FsSolid(c, a):
						if (Math.isNaN(a) || a==null) a = 1.0;
						addTo.push(new GraphicsSolidFill(c, a));
					case FsLinearGradient(c, a, r, mat):
						addTo.push(new GraphicsGradientFill(GradientType.LINEAR, c, a, r, mat));
					case FsHLinearGradient(c, a, r):
						addTo.push(new GraphicsGradientFill(GradientType.LINEAR, c, a, r, createBoxMatrix(Math.PI/2, width, height)));
					case FsVLinearGradient(c, a, r):
						addTo.push(new GraphicsGradientFill(GradientType.LINEAR, c, a, r, createBoxMatrix(0, width, height)));
					case FsRadialGradient(c, a, r, mat, fp):
						addTo.push(new GraphicsGradientFill(GradientType.RADIAL, c, a, r, mat, null, null, fp));
					case FsTransparent:
						addTo.push(new GraphicsSolidFill(0, 0));
					default:
						// ignore
				}
			}
			if (strokeFills != null && i < strokeFills.length) {
				var strokeFill:Dynamic;
				switch(strokeFills[i]) {
					case FsSolid(c, a):
						if (Math.isNaN(a) || a==null) a = 1.0;
						strokeFill = new GraphicsSolidFill(c, a);
					case FsLinearGradient(c, a, r, mat):
						strokeFill = new GraphicsGradientFill(GradientType.LINEAR, c, a, r, mat);
					case FsHLinearGradient(c, a, r):
						strokeFill = new GraphicsGradientFill(GradientType.LINEAR, c, a, r, createBoxMatrix(Math.PI/2, width, height));
					case FsVLinearGradient(c, a, r):
						strokeFill = new GraphicsGradientFill(GradientType.LINEAR, c, a, r, createBoxMatrix(0, width, height));
					case FsRadialGradient(c, a, r, mat, focal):
						strokeFill = new GraphicsGradientFill(GradientType.RADIAL, c, a, r, mat, null, null, focal);
					default:
						strokeFill = null;
						// ignore
				}
				addTo.push(new GraphicsStroke(thickness, pixelHinting, LineScaleMode.NORMAL, CapsStyle.NONE, joints, 3.0, cast strokeFill));
			}
			for (command in addBetween) addTo.push(command);
		}
		return addTo;
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
	
	public static function drawEllipse(addTo:GraphicsPath, x:Float, y:Float, w:Float, h:Float, accuracy:Int = 8):GraphicsPath {
		x += w / 2;
		y += h / 2;
		return drawArc(addTo, x, y, 0.5, Math.PI*2, 0, true, accuracy, w, h);
	}
	public static function drawArc(addTo:GraphicsPath, x:Float, y:Float, radius:Float, angle:Float, startAngle:Float, isInitial:Bool, accuracy:Int = 8, xScale:Float = 1, yScale:Float = 1):GraphicsPath {
		if (addTo == null) {
			addTo = new GraphicsPath();
			addTo.commands = new GraphArray<Int>();
			addTo.data = new GraphArray<Float>();
		}
		
		var span:Float = Math.PI / accuracy;
		var controlRadius:Float = radius/Math.cos(span);
		var anchorAngle:Float = (startAngle-Math.PI/2);
		var control:Float = 0;
		
		var startX:Float = x + Math.cos(anchorAngle) * radius * xScale;
		var startY:Float = y + Math.sin(anchorAngle) * radius * yScale;
		if(isInitial){
			addTo.commands.push(GraphicsPathCommand.MOVE_TO);
		}else{
			addTo.commands.push(GraphicsPathCommand.LINE_TO);
		}
		addTo.data.push(startX);
		addTo.data.push(startY);
		
		var curves = Math.ceil(accuracy/((Math.PI*2)/angle));
		var overhang = (accuracy/((Math.PI*2)/angle))%1;
		for (i in 0 ... curves) {
			if(i==curves-1 && overhang>0){
				control = anchorAngle + (span*overhang);
				anchorAngle = control + (span*overhang);
				controlRadius = radius / Math.cos(span * overhang);
			}else{
				control = anchorAngle + span;
				anchorAngle = control + span;
			}
			addTo.commands.push(GraphicsPathCommand.CURVE_TO);
			addTo.data.push(x + Math.cos(control) * controlRadius * xScale);
			addTo.data.push(y + Math.sin(control) * controlRadius * yScale);
			addTo.data.push(x + Math.cos(anchorAngle) * radius * xScale);
			addTo.data.push(y + Math.sin(anchorAngle) * radius * yScale);
		}
		return addTo;
	}
	public static inline function drawRoundedCorner(path:GraphicsPath, x1:Float, y1:Float, cX:Float, cY:Float, x2:Float, y2:Float, rad:Float, isInitial:Bool, accuracy:Int=8):Void {
		var angle1:Float = GeomUtils.getAngle2Points(x1, y1, cX, cY);
		var angle2:Float = GeomUtils.getAngle2Points(x2, y2, cX, cY);
		
		/*if (angle1 > 180) angle1 = 360 - angle1;
		if (angle2 > 180) angle2 = 360 - angle2;*/
		
		var halfAngle:Float = (angle1 + angle2) / 2;
		var radialDist:Float = rad / Math.tan(halfAngle);
		var point = GeomUtils.projectPoint(radialDist, 180 - angle1 + halfAngle, cX, cY);
		drawArc(path, point.x, point.y, rad, halfAngle * 2, angle1, isInitial, accuracy);
	}
	public static inline function closePath(path:GraphicsPath):Void {
		if(path.commands.length>0){
			path.commands.push(GraphicsPathCommand.LINE_TO);
			path.data.push(path.data[0]);
			path.data.push(path.data[1]);
		}
	}
}