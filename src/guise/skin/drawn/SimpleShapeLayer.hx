package guise.skin.drawn;
import guise.accessTypes.IPositionAccess;
import guise.accessTypes.IGraphicsAccess;
import guise.skin.drawn.utils.DrawnStyles;
import guise.skin.drawn.utils.DrawnStyleUtils;
import guise.skin.values.IValue;
import guise.skin.common.AbsStyledLayer;

class SimpleShapeLayer extends AbsStyledLayer<ShapeStyle>
{
	
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
	
	public var layerName:String;
	
	private var _graphicsAccess:IGraphicsAccess;
	private var _pos:IPositionAccess;
	
	public var xValue(default, set_xValue):IValue;
	public function set_xValue(value:IValue):IValue {
		if (xValue != null) {
			removeValue(xValue);
		}
		xValue = value;
		/*if (xValue != null) {
			addValue(xValue);
		}*/
		return xValue;
	}
	public var yValue(default, set_yValue):IValue;
	public function set_yValue(value:IValue):IValue {
		if (yValue != null) {
			removeValue(yValue);
		}
		yValue = value;
		/*if (yValue != null) {
			addValue(yValue);
		}*/
		return yValue;
	}

	public function new(?layerName:String, ?normalStyle:ShapeStyle) 
	{
		super(normalStyle);
		_requireSize = true;
		this.layerName = layerName;
	}
	override private function _isReadyToDraw():Bool {
		return _graphicsAccess != null && _pos!=null && super._isReadyToDraw();
	}
	override private function _drawStyle():Void {
		_pos.setPos(getValue(xValue, 0), getValue(yValue, 0));
		
		
		_graphicsAccess.clear();
		
		var style:ShapeStyle = currentStyle;
		
		drawShape(currentStyle);
		
		_graphicsAccess.endFill();
	}
	private function drawShape(style:ShapeStyle):Void {
		switch(style) {
			case SsMulti(shapes):
				for (childShape in shapes) {
					drawShape(childShape);
				}
			case SsEllipse(f, s, w, h, x, y):
				var xVal:Float = getValue(x, 0);
				var yVal:Float = getValue(y, 0);
				var wVal:Float = getValue(w, this.w);
				var hVal:Float = getValue(h, this.h);
				DrawnStyleUtils.beginFillStrokes(_graphicsAccess, f, s, false, wVal, hVal, function(index:Int):Void{_graphicsAccess.drawEllipse(xVal, yVal, wVal, hVal);});
		}
	}
}
enum ShapeStyle {
	SsMulti(ShapeStyle:Array<ShapeStyle>);
	SsEllipse(f:FillStyle, s:StrokeStyle, ?w:IValue, ?h:IValue, ?x:IValue, ?y:IValue);
}