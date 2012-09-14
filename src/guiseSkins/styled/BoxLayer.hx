package guiseSkins.styled;
import guise.traits.core.IPosition;
import guise.traits.core.ISize;
import guiseSkins.styled.Styles;
import guise.platform.types.DrawingAccessTypes;
import guise.platform.PlatformAccessor;
import guise.geom.Matrix;

/**
 * ...
 * @author Tom Byrne
 */

class BoxLayer extends AbsStyledLayer<BoxStyle>
{
	private var _graphics:IGraphics;

	public function new(?layerName:String, ?normalStyle:BoxStyle) 
	{
		super(normalStyle);
		_requireSize = true;
		
		addSiblingTrait(new PlatformAccessor(IGraphics, layerName, onGraphicsAdd, onGraphicsRemove));
	}
	private function onGraphicsAdd(access:IGraphics):Void {
		_graphics = access;
		invalidate();
	}
	private function onGraphicsRemove(access:IGraphics):Void {
		_graphics.clear();
		_graphics = null;
	}
	override private function _isReadyToDraw():Bool {
		return _graphics != null && super._isReadyToDraw();
	}
	override private function _drawStyle():Void {
		_graphics.clear();
		
		var style:BoxStyle = currentStyle;
		var fill:FillStyle;
		var stroke:StrokeStyle;
		var tl:CornerStyle;
		var tr:CornerStyle;
		var bl:CornerStyle;
		var br:CornerStyle;
		var extW:Float;
		var extH:Float;
		switch(style) {
			case BsRectComplex(f, s, c, exW, exH):
				extW = exW;
				extH = exH;
				fill = f;
				stroke = s;
				switch(c) {
					case CSame(cs):
						tl = cs;
						tr = cs;
						bl = cs;
						br = cs;
					case CDiff(c1, c2, c3, c4):
						tl = c1;
						tr = c2;
						br = c3;
						bl = c4;
						
				}
			case BsCapsule(f, s, exW, exH):
				extW = exW;
				extH = exH;
				fill = f;
				stroke = s;
				if (CAPSULE_CORNER == null) {
					CAPSULE_CORNER = CsCirc(Math.POSITIVE_INFINITY);
				}
				tl = CAPSULE_CORNER;
				tr = CAPSULE_CORNER;
				bl = CAPSULE_CORNER;
				br = CAPSULE_CORNER;
			case BsRect(f, s, exW, exH):
				extW = exW;
				extH = exH;
				fill = f;
				stroke = s;
				if (SQUARE_CORNER == null) {
					SQUARE_CORNER = CsSquare;
				}
				tl = SQUARE_CORNER;
				tr = SQUARE_CORNER;
				bl = SQUARE_CORNER;
				br = SQUARE_CORNER;
		}
		var width:Float = w;
		var height:Float = h;
		if (!Math.isNaN(extW)) width += extW;
		if (!Math.isNaN(extH)) height += extH;
		
		var fills = [];
		collectFills(fill, fills);
		var strokeFills;
		switch(stroke) {
			case SsSolid(th, sFill, joints):
				if (joints == null) joints = JointStyle.JoRound;
				_graphics.lineStyle(th, true, null, joints);
				strokeFills = [];
				collectFills(sFill, strokeFills);
			case SsNone:
				strokeFills = null;
				//ignore
		}
		var drawRuns:Int = (strokeFills == null || fills.length > strokeFills.length?fills.length:strokeFills.length);
		var centerX:Float = w / 2;
		var centerY:Float = h / 2;
		for (i in 0 ... drawRuns) {
			if (i < fills.length) {
				switch(fills[i]) {
					case FsSolid(c, a):
						if (Math.isNaN(a) || a==null) a = 1.0;
						_graphics.beginFill(c, a);
					case FsLinearGradient(gp, mat):
						_graphics.beginGradientFill(Linear, gp, mat);
					case FsHLinearGradient(gp):
						_graphics.beginGradientFill(Linear, gp, createBoxMatrix(Math.PI/2, width, height));
					case FsVLinearGradient(gp):
						_graphics.beginGradientFill(Linear, gp, createBoxMatrix(0, width, height));
					case FsRadialGradient(gp, mat, fp):
						_graphics.beginGradientFill(Radial(fp), gp, mat);
					case FsTransparent:
						_graphics.beginFill(0, 0);
					default:
						// ignore
				}
			}
			if(strokeFills!=null && i<strokeFills.length){
				switch(strokeFills[i]) {
					case FsSolid(c, a):
						if (Math.isNaN(a) || a==null) a = 1.0;
						_graphics.beginStroke(c, a);
					case FsLinearGradient(gp, mat):
						_graphics.beginGradientStroke(Linear, gp, mat);
					case FsHLinearGradient(gp):
						_graphics.beginGradientStroke(Linear, gp, createBoxMatrix(Math.PI/2, width, height));
					case FsVLinearGradient(gp):
						_graphics.beginGradientStroke(Linear, gp, createBoxMatrix(0, width, height));
					case FsRadialGradient(gp, mat, focal):
						_graphics.beginGradientStroke(Radial(focal), gp, mat);
					default:
						// ignore
				}
			}
			
			drawCorner(tl, false, false, -Math.PI/2, true, width, height, centerX, centerY);
			drawCorner(tr, true, false, 0, false, width, height, centerX, centerY);
			drawCorner(br, true, true, Math.PI/2, false, width, height, centerX, centerY);
			drawCorner(bl, false, true, Math.PI, false, width, height, centerX, centerY);
		}
		_graphics.endFill();
	}
	private function collectFills(fill:FillStyle, fills:Array<FillStyle>):Void {
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
	static var SQUARE_CORNER:CornerStyle;
	static var CAPSULE_CORNER:CornerStyle;
	
	private function createBoxMatrix(rotation:Float, width:Float, height:Float):Matrix {
		var ret:Matrix = new Matrix();
		ret.createGradientBox(width, height, rotation, 0, 0);
		return ret;
	}
	
	private function drawCorner(cs:CornerStyle, flipH:Bool, flipV:Bool, angle:Float, isInitial:Bool, width:Float, height:Float, cX:Float, cY:Float):Void {
		var hW:Float = width / 2;
		var hH:Float = height / 2;
		switch(cs) {
			case CsSquare:
				var x:Float = -hW;
				var y:Float = -hH;
				if (flipH) x *= -1;
				if (flipV) y *= -1;
				if (isInitial) {
					_graphics.moveTo(x+cX, y+cY);
				}else {
					_graphics.lineTo(x+cX, y+cY);
				}
			case CsCirc(r):
				if (r > hW) r = hW;
				if (r > hH) r = hH;
				
				var x:Float = r-hW;
				var y:Float = r-hH;
				if (flipH) x *= -1;
				if (flipV) y *= -1;
				
				drawArc(_graphics, x+cX, y+cY, r, Math.PI / 2, angle, isInitial);
		}
	}
	private function drawArc(graphics:IGraphics, x:Float, y:Float, radius:Float, angle:Float, startAngle:Float, isInitial:Bool, accuracy:Int=8){
		var span:Float = Math.PI / accuracy;
		var controlRadius:Float = radius/Math.cos(span);
		var anchorAngle:Float = (startAngle-Math.PI/2);
		var control:Float = 0;
		
		var startX:Float = x + Math.cos(anchorAngle) * radius;
		var startY:Float = y + Math.sin(anchorAngle) * radius;
		if(isInitial){
			graphics.moveTo(startX, startY);
		}else{
			graphics.lineTo(startX, startY);
		}
		
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
			graphics.curveTo(x + Math.cos(control)*controlRadius, y+Math.sin(control)*controlRadius, x+Math.cos(anchorAngle) * radius, y+Math.sin(anchorAngle)*radius);
		}
	}
}
enum BoxStyle{
	BsRect(f:FillStyle, s:StrokeStyle, ?extraW:Float, ?extraH:Float);
	BsRectComplex(f:FillStyle, s:StrokeStyle, c:Corners, ?extraW:Float, ?extraH:Float);
	BsCapsule(f:FillStyle, s:StrokeStyle, ?extraW:Float, ?extraH:Float);
}
enum Corners{
	CSame(cs:CornerStyle);
	CDiff(tl:CornerStyle, tr:CornerStyle, br:CornerStyle, bl:CornerStyle);
}
enum CornerStyle{
	CsSquare;
	CsCirc(r:Float);
}