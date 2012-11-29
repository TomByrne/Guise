package guiseSkins.styled;
import guise.platform.types.DisplayAccessTypes;
import guise.traits.core.IPosition;
import guise.traits.core.ISize;
import guise.platform.types.DrawingAccessTypes;
import guise.platform.PlatformAccessor;
import guiseSkins.styled.Styles;
import guiseSkins.styled.values.IValue;
/**
 * ...
 * @author Tom Byrne
 */

class SimpleShapeLayer extends AbsStyledLayer<ShapeStyle>
{
	private var _graphics:IGraphics;
	private var _positionable:ISizableDisplayAccess;
	
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
		
		addSiblingTrait(new PlatformAccessor(IGraphics, layerName, onGraphicsAdd, onGraphicsRemove));
		addSiblingTrait(new PlatformAccessor(ISizableDisplayAccess, layerName, onPosAdd, onPosRemove));
	}
	private function onGraphicsAdd(access:IGraphics):Void {
		_graphics = access;
		invalidate();
	}
	private function onGraphicsRemove(access:IGraphics):Void {
		_graphics.clear();
		_graphics = null;
	}
	private function onPosAdd(access:ISizableDisplayAccess):Void {
		_positionable = access;
		invalidate();
	}
	private function onPosRemove(access:ISizableDisplayAccess):Void {
		_positionable = null;
	}
	override private function _isReadyToDraw():Bool {
		return _graphics != null && super._isReadyToDraw();
	}
	override private function _drawStyle():Void {
		if(xValue!=null && yValue != null){
			//xValue.update(item);
			//yValue.update(item);
			_positionable.setPos(new Position(getValue(xValue), getValue(yValue)));
		}
		
		
		_graphics.clear();
		
		var style:ShapeStyle = currentStyle;
		
		drawShape(currentStyle);
		
		_graphics.endFill();
	}
	private function drawShape(style:ShapeStyle):Void {
		switch(style) {
			case SsMulti(shapes):
				for (childShape in shapes) {
					drawShape(childShape);
				}
			case SsEllipse(f, s, w, h, x, y):
				var xVal:Float = getValue(x);
				var yVal:Float = getValue(y);
				var wVal:Float = getValue(w);
				var hVal:Float = getValue(h);
				StyledLayerUtils.beginFillStrokes(_graphics, f, s, false, wVal, hVal, function(index:Int):Void{_graphics.drawEllipse(xVal, yVal, wVal, hVal);});
		}
	}
}
enum ShapeStyle {
	SsMulti(ShapeStyle:Array<ShapeStyle>);
	SsEllipse(f:FillStyle, s:StrokeStyle, ?w:IValue, ?h:IValue, ?x:IValue, ?y:IValue);
}