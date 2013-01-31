package guise.platform.nme.accessTypes;

import nme.display.Graphics;
import nme.display.BitmapData;
import guise.accessTypes.IGraphicsAccess;
import guise.geom.Matrix;
import nme.display.Sprite;
import nme.display.DisplayObject;
import nme.display.InteractiveObject;
import guise.platform.nme.accessTypes.AdditionalTypes;

/**
 * @author Tom Byrne
 */

class GraphicsAccess implements IGraphicsAccess, implements IDisplayObjectType, implements IInteractiveObjectType
{
	
	public var layerName(default, set_layerName):String;
	private function set_layerName(value:String):String {
		this.layerName = value;
		_sprite.name = value==null?"":value;
		return value;
	}
	
	private var _sprite:Sprite;
	private var _graphics:Graphics;

	public function new(?layerName:String) {
		_sprite = new Sprite();
		_graphics = _sprite.graphics;
		this.layerName = layerName;
	}
	
	public function getDisplayObject():DisplayObject {
		return _sprite;
	}
	public function getInteractiveObject():InteractiveObject {
		return _sprite;
	}
	
	public function beginFill(color:Int, alpha:Float = 1.0)
	{	
		_graphics.beginFill(color, alpha);
	}

	public function beginBitmapFill(bitmap:BitmapData, matrix:Matrix = null, repeat:Bool = true, smooth:Bool = false) {
		_graphics.beginBitmapFill(bitmap, matrix, repeat, smooth);
	}

	public function beginGradientFill(type:GradientType, gp:Array<{fract:Float, c:Int, a:Null<Float>}>, ?matrix:Matrix, ?spreadMethod:Null<SpreadMethod>, ?interpolationMethod:Null<InterpolationMethod>):Void
	{	
		// flash has a problem with the ratios being out of order
		gp.sort(sortGradPoints);
		
		var colors:Array<Int> = [];
		var alphas:Array<Float> = [];
		var ratios:Array<Float> = [];
		for (point in gp) {
			var a:Float;
			if (point.a == null || Math.isNaN(point.a)) a = 1.0;
			else a = point.a;
			alphas.push(a);
			colors.push(point.c);
			ratios.push(Std.int(point.fract * 0xff));
		}
		if (spreadMethod == null) spreadMethod = SpreadMethod.Pad;
		if (interpolationMethod == null) interpolationMethod = InterpolationMethod.Rgb;
		
		var spread:nme.display.SpreadMethod;
		switch(spreadMethod) {
			case SpreadMethod.Pad: spread = nme.display.SpreadMethod.PAD;
			case SpreadMethod.Reflect: spread = nme.display.SpreadMethod.REFLECT;
			case SpreadMethod.Repeat: spread = nme.display.SpreadMethod.REPEAT;
		}
		
		var interp:nme.display.InterpolationMethod;
		switch(interpolationMethod) {
			case InterpolationMethod.LinearRgb: interp = nme.display.InterpolationMethod.LINEAR_RGB;
			case InterpolationMethod.Rgb: interp = nme.display.InterpolationMethod.RGB;
		}
		
		var nmeMat:nme.geom.Matrix;
		if (matrix != null) {
			nmeMat = new nme.geom.Matrix(matrix.a, matrix.b, matrix.c, matrix.d, matrix.tx, matrix.ty);
		}else {
			nmeMat = null;
		}
		var nmeType:nme.display.GradientType;
		var focalPointRatio:Float;
		switch(type) {
			case Linear:
				nmeType = nme.display.GradientType.LINEAR;
				focalPointRatio = 0.0;
			case Radial(fpr):
				nmeType = nme.display.GradientType.RADIAL;
				focalPointRatio = fpr;
		}
		_graphics.beginGradientFill(nmeType, colors, alphas, ratios, nmeMat, spread, interp, focalPointRatio);
	}
	
	
	public function clear()
	{	
		_graphics.clear();	
	}
	
	
	public function curveTo(inCX:Float, inCY:Float, inX:Float, inY:Float)
	{	
		_graphics.curveTo(inCX, inCY, inX, inY);	
	}

	
	public function drawEllipse(inX:Float, inY:Float, inWidth:Float, inHeight:Float)
	{	
		_graphics.drawEllipse(inX, inY, inWidth, inHeight); 
	}
	
	
	public function drawRect(inX:Float, inY:Float, inWidth:Float, inHeight:Float)
	{
		_graphics.drawRect(inX, inY, inWidth, inHeight);
	}
	
	
	public function drawRoundRect(x:Float, y:Float, w:Float, h:Float, r:Float)
	{
		_graphics.drawRoundRect(x, y, w, h, r, r);
	}
	
	public function endFill()
	{
		_graphics.endFill();	
	}
	
	public function beginBitmapStroke(bitmap:BitmapData, matrix:Matrix = null, repeat:Bool = true, smooth:Bool = false) {
		#if flash
		_graphics.lineBitmapStyle(bitmap, matrix, repeat, smooth);
		#else
		throw "beginBitmapStroke not yet supported on this target"; 
		#end
	}
	
	public function beginGradientStroke(type:GradientType, gp:Array<{fract:Float, c:Int, a:Null<Float>}>, ?matrix:Matrix, ?spreadMethod:Null<SpreadMethod>, ?interpolationMethod:Null<InterpolationMethod>):Void
	{	
		// flash has a problem with the ratios being out of order
		gp.sort(sortGradPoints);
		
		
		var colors:Array<Int> = [];
		var alphas:Array<Float> = [];
		var ratios:Array<Float> = [];
		for (point in gp) {
			var a:Float;
			if (point.a == null || Math.isNaN(point.a)) a = 1.0;
			else a = point.a;
			alphas.push(a);
			colors.push(point.c);
			ratios.push(point.fract*0xff);
		}
		if (spreadMethod == null) spreadMethod = SpreadMethod.Pad;
		if (interpolationMethod == null) interpolationMethod = InterpolationMethod.Rgb;
		
		var spread:nme.display.SpreadMethod;
		switch(spreadMethod) {
			case SpreadMethod.Pad: spread = nme.display.SpreadMethod.PAD;
			case SpreadMethod.Reflect: spread = nme.display.SpreadMethod.REFLECT;
			case SpreadMethod.Repeat: spread = nme.display.SpreadMethod.REPEAT;
		}
		
		var interp:nme.display.InterpolationMethod;
		switch(interpolationMethod) {
			case InterpolationMethod.LinearRgb: interp = nme.display.InterpolationMethod.LINEAR_RGB;
			case InterpolationMethod.Rgb: interp = nme.display.InterpolationMethod.RGB;
		}
		
		var nmeMat:nme.geom.Matrix;
		if (matrix != null) {
			nmeMat = new nme.geom.Matrix(matrix.a, matrix.b, matrix.c, matrix.d, matrix.tx, matrix.ty);
		}else {
			nmeMat = null;
		}
		var nmeType:nme.display.GradientType;
		var focalPointRatio:Float;
		switch(type) {
			case Linear:
				nmeType = nme.display.GradientType.LINEAR;
				focalPointRatio = Math.NaN;
			case Radial(fpr):
				nmeType = nme.display.GradientType.RADIAL;
				focalPointRatio = fpr;
		}
		_graphics.lineGradientStyle(nmeType, colors, alphas, ratios, nmeMat, spread, interp, focalPointRatio);
	}
	
	private var _color:Int;
	private var _alpha:Float;
	private var _thickness:Float;
	private var _pixelHinting:Bool;
	private var _caps:nme.display.CapsStyle;
	private var _joints:nme.display.JointStyle;
	private var _miterLimit:Float;
	
	public function beginStroke(color:Int = 0, alpha:Float = 1.0):Void
	{	
		_color = color;
		_alpha = alpha;
		_graphics.lineStyle(_thickness, _color, _alpha, _pixelHinting, null, _caps, _joints, _miterLimit);
	}
	
	public function lineStyle(?thickness:Null<Float>, pixelHinting:Bool = false, ?caps:CapsStyle, ?joints:JointStyle):Void
	{	
		if(caps==null)caps = CsNone;
		if(joints==null)joints = JoRound;
		
		switch(joints) {
			case JoRound: _joints = nme.display.JointStyle.ROUND;
			case JoBevel: _joints = nme.display.JointStyle.BEVEL;
			case JoMiter(l):
				_joints = nme.display.JointStyle.MITER;
				_miterLimit = l;
		}
		switch(caps) {
			case CsNone: _caps = nme.display.CapsStyle.NONE;
			case CsRound: _caps = nme.display.CapsStyle.ROUND;
			case CsSquare: _caps = nme.display.CapsStyle.SQUARE;
		}
		_thickness = thickness;
		_pixelHinting = pixelHinting;
		
		_graphics.lineStyle(_thickness, _color, _alpha, _pixelHinting, null, _caps, _joints, _miterLimit);
	}
	
	
	public function lineTo(inX:Float, inY:Float)
	{	
		_graphics.lineTo(inX, inY);
	}
	
	
	public function moveTo(inX:Float, inY:Float)
	{	
		_graphics.moveTo(inX, inY);	
	}
	
	private function sortGradPoints(gp1: { fract:Float, c:Int, a:Float }, gp2: { fract:Float, c:Int, a:Float } ):Int {
		if (gp1.fract < gp2.fract) return -1;
		else if (gp2.fract < gp1.fract) return 1;
		else return 0;
	}
}