package guiseSkins.styled;
import guise.styledLayers.IGraphicsLayer;
import guise.traits.core.IPosition;
import guise.traits.core.ISize;
import guiseSkins.styled.Styles;
import guise.platform.types.DrawingAccessTypes;
import guise.platform.PlatformAccessor;
import guise.geom.Matrix;
import guiseSkins.styled.values.IValue;
import guise.platform.types.DisplayAccessTypes;

/**
 * ...
 * @author Tom Byrne
 */

class BoxLayer extends AbsStyledLayer<BoxStyle>, implements IGraphicsLayer
{
	public var layerName(default, null):String;
	
	public var filterAccess(default, set_filterAccess):IFilterableAccess;
	private function set_filterAccess(value:IFilterableAccess):IFilterableAccess {
		if (filterLayer!=null) {
			filterLayer.filterAccess = value;
		}
		filterAccess = value;
		return value;
	}
	public var graphicsAccess(default, set_graphicsAccess):IGraphics;
	private function set_graphicsAccess(value:IGraphics):IGraphics {
		if (graphicsAccess != null) {
			graphicsAccess.clear();
		}
		graphicsAccess = value;
		if (graphicsAccess != null) {
			invalidate();
		}
		return value;
	}
	public var positionAccess(default, set_positionAccess):IPositionAccess;
	private function set_positionAccess(value:IPositionAccess):IPositionAccess {
		positionAccess = value;
		if (positionAccess != null) {
			invalidate();
		}
		return value;
	}
	
	public var filterLayer(default, set_filterLayer):FilterLayer;
	private function set_filterLayer(value:FilterLayer):FilterLayer {
		if (filterLayer != null) {
			filterLayer.filterAccess = null;
			removeSiblingTrait(filterLayer);
		}
		filterLayer = value;
		if (filterLayer != null) {
			filterLayer.filterAccess = filterAccess;
			addSiblingTrait(filterLayer);
		}
		return value;
	}

	public function new(?layerName:String, ?normalStyle:BoxStyle) 
	{
		super(normalStyle);
		_requireSize = true;
		this.layerName = layerName;
		
		//addSiblingTrait(new PlatformAccessor(IGraphics, layerName, onGraphicsAdd, onGraphicsRemove));
	}
	/*private function onGraphicsAdd(access:IGraphics):Void {
		_graphics = access;
		invalidate();
	}
	private function onGraphicsRemove(access:IGraphics):Void {
		_graphics.clear();
		_graphics = null;
	}*/
	override private function _isReadyToDraw():Bool {
		return graphicsAccess != null && super._isReadyToDraw();
	}
	override private function _drawStyle():Void {
		/*if(xValue!=null && yValue != null){
			positionAccess.setPos(getValue(xValue), getValue(yValue));
		}*/
		
		graphicsAccess.clear();
		
		var style:BoxStyle = currentStyle;
		var fill:FillStyle;
		var stroke:StrokeStyle;
		var tl:CornerStyle;
		var tr:CornerStyle;
		var bl:CornerStyle;
		var br:CornerStyle;
		
		var boxX:Float;
		var boxY:Float;
		var boxW:Float;
		var boxH:Float;
		
		switch(style) {
			case BsRectComplex(f, s, c, w, h, x, y):
				boxX = x!=null?getValue(x):0;
				boxY = y!=null?getValue(y):0;
				boxW = w!=null?getValue(w):this.w;
				boxH = h!=null?getValue(h):this.h;
				
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
			case BsCapsule(f, s, w, h, x, y):
				boxX = x!=null?getValue(x):0;
				boxY = y!=null?getValue(y):0;
				boxW = w!=null?getValue(w):this.w;
				boxH = h!=null?getValue(h):this.h;
				
				fill = f;
				stroke = s;
				if (CAPSULE_CORNER == null) {
					CAPSULE_CORNER = CsCirc(Math.POSITIVE_INFINITY);
				}
				tl = CAPSULE_CORNER;
				tr = CAPSULE_CORNER;
				bl = CAPSULE_CORNER;
				br = CAPSULE_CORNER;
			case BsRect(f, s, w, h, x, y):
				boxX = x!=null?getValue(x):0;
				boxY = y!=null?getValue(y):0;
				boxW = w!=null?getValue(w):this.w;
				boxH = h!=null?getValue(h):this.h;
				
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
		
		var centerX:Float = boxX + boxW / 2;
		var centerY:Float = boxY + boxH / 2;
		StyledLayerUtils.beginFillStrokes(graphicsAccess, fill, stroke, true, boxW, boxH, function(index:Int):Void {
			drawCorner(tl, false, false, -Math.PI/2, true, boxW, boxH, centerX, centerY);
			drawCorner(tr, true, false, 0, false, boxW, boxH, centerX, centerY);
			drawCorner(br, true, true, Math.PI/2, false, boxW, boxH, centerX, centerY);
			drawCorner(bl, false, true, Math.PI, false, boxW, boxH, centerX, centerY);
		});
		graphicsAccess.endFill();
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
					graphicsAccess.moveTo(x+cX, y+cY);
				}else {
					graphicsAccess.lineTo(x+cX, y+cY);
				}
			case CsCirc(r):
				if (r > hW) r = hW;
				if (r > hH) r = hH;
				
				var x:Float = r-hW;
				var y:Float = r-hH;
				if (flipH) x *= -1;
				if (flipV) y *= -1;
				
				drawArc(graphicsAccess, x+cX, y+cY, r, Math.PI / 2, angle, isInitial);
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
	BsRect(f:FillStyle, s:StrokeStyle, ?w:IValue, ?h:IValue, ?x:IValue, ?y:IValue);
	BsRectComplex(f:FillStyle, s:StrokeStyle, c:Corners, ?w:IValue, ?h:IValue, ?x:IValue, ?y:IValue);
	BsCapsule(f:FillStyle, s:StrokeStyle, ?w:IValue, ?h:IValue, ?x:IValue, ?y:IValue);
}
enum Corners{
	CSame(cs:CornerStyle);
	CDiff(tl:CornerStyle, tr:CornerStyle, br:CornerStyle, bl:CornerStyle);
}
enum CornerStyle{
	CsSquare;
	CsCirc(r:Float);
}