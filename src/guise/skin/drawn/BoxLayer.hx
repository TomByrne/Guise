package guise.skin.drawn;
import guise.platform.cross.IAccessRequest;
import guise.skin.drawn.utils.DrawnStyles;
import guise.skin.drawn.utils.DrawnStyleUtils;
import guise.accessTypes.IGraphicsAccess;
import guise.geom.Matrix;
import guise.skin.values.IValue;
import guise.accessTypes.IPositionAccess;
import guise.skin.common.PositionedLayer;

class BoxLayer extends PositionedLayer<BoxStyle> implements IAccessRequest
{
	private static var ACCESS_TYPES:Array<Class<Dynamic>> = [IGraphicsAccess, IPositionAccess];
	
	
	@injectAdd
	private function onGraphicsAdd(access:IGraphicsAccess):Void {
		if (layerName != null && access.layerName != layerName) return;
		
		_graphicsAccess = access;
		invalidate();
	}
	@injectRemove
	private function onGraphicsRemove(access:IGraphicsAccess):Void {
		if (access != _graphicsAccess) return;
		
		_graphicsAccess = null;
	}
	
	@injectAdd
	private function onPosAdd(access:IPositionAccess):Void {
		if (layerName != null && access.layerName != layerName) return;
		
		_pos = access;
		invalidate();
	}
	@injectRemove
	private function onPosRemove(access:IPositionAccess):Void {
		if (access != _pos) return;
		
		_pos = null;
	}
	
	private var _graphicsAccess:IGraphicsAccess;
	private var _pos:IPositionAccess;

	public function new(?layerName:String, ?normalStyle:BoxStyle) 
	{
		super(layerName, normalStyle);
	}
	public function getAccessTypes():Array<Class<Dynamic>> {
		return ACCESS_TYPES;
	}
	override private function _isReadyToDraw():Bool {
		return _graphicsAccess != null && super._isReadyToDraw();
	}
	override private function _drawStyle():Void {
		
		_graphicsAccess.clear();
		
		var style:BoxStyle = currentStyle;
		var fill:FillStyle;
		var stroke:StrokeStyle;
		var tl:CornerStyle;
		var tr:CornerStyle;
		var bl:CornerStyle;
		var br:CornerStyle;
		
		switch(style) {
			case BsRectComplex(f, s, c):
				
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
			case BsCapsule(f, s):
				
				fill = f;
				stroke = s;
				if (CAPSULE_CORNER == null) {
					CAPSULE_CORNER = CsCirc(Math.POSITIVE_INFINITY);
				}
				tl = CAPSULE_CORNER;
				tr = CAPSULE_CORNER;
				bl = CAPSULE_CORNER;
				br = CAPSULE_CORNER;
			case BsRect(f, s):
				
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
		
		var centerX:Float = x + w / 2;
		var centerY:Float = y + h / 2;
		DrawnStyleUtils.beginFillStrokes(_graphicsAccess, fill, stroke, true, w, h, function(index:Int):Void {
			drawCorner(tl, false, false, -Math.PI/2, true, w, h, centerX, centerY);
			drawCorner(tr, true, false, 0, false, w, h, centerX, centerY);
			drawCorner(br, true, true, Math.PI/2, false, w, h, centerX, centerY);
			drawCorner(bl, false, true, Math.PI, false, w, h, centerX, centerY);
		});
		_graphicsAccess.endFill();
	}
	static var SQUARE_CORNER:CornerStyle;
	static var CAPSULE_CORNER:CornerStyle;
	
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
					_graphicsAccess.moveTo(x+cX, y+cY);
				}else {
					_graphicsAccess.lineTo(x+cX, y+cY);
				}
			case CsCirc(r):
				if (r > hW) r = hW;
				if (r > hH) r = hH;
				
				var x:Float = r-hW;
				var y:Float = r-hH;
				if (flipH) x *= -1;
				if (flipV) y *= -1;
				
				drawArc(_graphicsAccess, x+cX, y+cY, r, Math.PI / 2, angle, isInitial);
		}
	}
	private function drawArc(graphics:IGraphicsAccess, x:Float, y:Float, radius:Float, angle:Float, startAngle:Float, isInitial:Bool, accuracy:Int=8){
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
	BsRect(f:FillStyle, s:StrokeStyle);
	BsRectComplex(f:FillStyle, s:StrokeStyle, c:Corners);
	BsCapsule(f:FillStyle, s:StrokeStyle);
}
enum Corners{
	CSame(cs:CornerStyle);
	CDiff(tl:CornerStyle, tr:CornerStyle, br:CornerStyle, bl:CornerStyle);
}
enum CornerStyle{
	CsSquare;
	CsCirc(r:Float);
}