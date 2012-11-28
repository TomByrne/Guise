package guiseSkins.styled;
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

	public function new(?layerName:String, ?normalStyle:ShapeStyle) 
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
		
		var style:ShapeStyle = currentStyle;
		
		var posX:Float;
		var posY:Float;
		var posW:Float;
		var posH:Float;
		
		switch(style) {
			case SsEllipse(f, s, w, h, x, y):
				//posX = StyledLayerUtils.getPos(x, this.w, this.h, 0);
				//posY = StyledLayerUtils.getPos(y, this.w, this.h, 0);
				//posW = StyledLayerUtils.getPos(w, this.w, this.h, this.w);
				//posH = StyledLayerUtils.getPos(h, this.w, this.h, this.h);
				posX = x.currentValue;
				posY = y.currentValue;
				posW = w.currentValue;
				posH = h.currentValue;
				StyledLayerUtils.beginFillStrokes(_graphics, f, s, posW, posH, function(index:Int):Void{_graphics.drawEllipse(posX, posY, posW, posH);});
		}
		
		_graphics.endFill();
	}
}
enum ShapeStyle {
	SsEllipse(f:FillStyle, s:StrokeStyle, ?w:IValue, ?h:IValue, ?x:IValue, ?y:IValue);
}