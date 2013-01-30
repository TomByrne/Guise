package guiseSkins.styled;
import guise.controls.ControlLayers;
import guise.traits.core.IPosition;
import guise.traits.core.ISize;
import guiseSkins.styled.Styles;
import guise.accessTypes.DisplayAccessTypes;
import guise.platform.PlatformAccessor;

/**
 * @author Tom Byrne
 */

class FramingLayer extends AbsStyledLayer<FramingStyle> 
{
	private var _sizableDisplay:ISizableDisplayAccess;
	private var _expPos:Position;
	private var _expSize:Size;

	public function new(layerName:String, ?normalStyle:FramingStyle) 
	{
		super(normalStyle);
		_expPos = new Position(0, 0);
		_expSize = new Size();
		
		_requireSize = true;
		
		addSiblingTrait(new PlatformAccessor(ISizableDisplayAccess, layerName, onSizableAdd, onSizableRemove));
	}
	private function onSizableAdd(access:ISizableDisplayAccess):Void {
		_sizableDisplay = access;
		_sizableDisplay.setPos(_expPos);
		_sizableDisplay.setSize(_expSize);
		_sizableDisplay.measChanged.add(onMeasChanged);
		invalidate();
	}
	private function onSizableRemove(access:ISizableDisplayAccess):Void {
		_sizableDisplay.measChanged.remove(onMeasChanged);
		_sizableDisplay.setPos(null);
		_sizableDisplay.setSize(null);
	}
	private function onMeasChanged(from:ISizableDisplayAccess):Void {
		invalidate();
	}
	override private function _isReadyToDraw():Bool {
		if (_sizableDisplay == null) return false;
		return super._isReadyToDraw();
	}
	override private function _drawStyle():Void {
		switch(currentStyle) {
			case Frame(fitMode, hScaleMode, vScaleMode, marginTop, marginLeft, marginBottom, marginRight):
				
				if (marginTop == null || Math.isNaN(marginTop)) marginTop = 0;
				if (marginLeft == null || Math.isNaN(marginLeft)) marginLeft = 0;
				if (marginBottom == null || Math.isNaN(marginBottom)) marginBottom = 0;
				if (marginRight == null || Math.isNaN(marginRight)) marginRight = 0;
				
				var usableWidth:Float = w - marginLeft - marginRight;
				var usableHeight:Float = h - marginTop - marginBottom;
				
				var width:Float = _sizableDisplay.getMeasWidth();
				var height:Float = _sizableDisplay.getMeasHeight();
				
				var x:Float;
				var y:Float;
				var hScale:Float;
				var vScale:Float;
				
				if (width == 0) {
					width = usableWidth;
					hScale = 1;
				}else {
					hScale = usableWidth/width;
				}
				if (height == 0) {
					height = usableHeight;
					vScale = 1;
				}else {
					vScale = usableHeight / height;
				}
				switch(fitMode) {
					case Fill:
						// ignore
					case ConstrainMin:
						hScale = vScale = Math.min(hScale, vScale);
					case ConstrainMax:
						hScale = vScale = Math.max(hScale, vScale);
				}
				
				var hAlign:Align = null;
				if(hScaleMode!=null){
					switch(hScaleMode) {
						case ScaleAlways:
							// ignore
						case ScaleNever(align):
							hAlign = align;
							hScale = 1;
						case ScaleUpOnly(align):
							hAlign = align;
							if (hScale < 1) hScale = 1;
						case ScaleDownOnly(align):
							hAlign = align;
							if (hScale > 1) hScale = 1;
					}
				}
				if (hAlign == null) {
					hAlign = AlignMid;
				}
				
				var vAlign:Align = null;
				if(vScaleMode!=null){
					switch(vScaleMode) {
						case ScaleAlways:
							// ignore
						case ScaleNever(align):
							vAlign = align;
							vScale = 1;
						case ScaleUpOnly(align):
							vAlign = align;
							if (vScale < 1) vScale = 1;
						case ScaleDownOnly(align):
							vAlign = align;
							if (vScale > 1) vScale = 1;
					}
				}
				if (vAlign == null) {
					vAlign = AlignMid;
				}
				
				width *= hScale;
				height *= vScale;
				
				if (width < 0) width = 0;
				if (height < 0) height = 0;
				
				switch(hAlign) {
					case AlignFore:
						x = 0;
					case AlignMid:
						x = marginLeft+(usableWidth-width)/2;
					case AlignAft:
						x = marginLeft+usableWidth-width;
				}
				switch(vAlign) {
					case AlignFore:
						y = 0;
					case AlignMid:
						y = marginTop+(usableHeight-height)/2;
					case AlignAft:
						y = marginTop+usableHeight-height;
				}
				_expPos.set(x, y);
				_expSize.set(width, height);
		}
	}
	
}
enum FramingStyle {
	Frame(fitMode:FrameMode, ?hScale:ScaleMode, ?vScale:ScaleMode, ?marginTop:Float, ?marginLeft:Float, ?marginBottom:Float, ?marginRight:Float);
}
enum FrameMode {
	Fill;
	ConstrainMin;
	ConstrainMax;
}
enum ScaleMode {
	ScaleAlways;
	ScaleNever(?align:Align);
	ScaleUpOnly(?align:Align);
	ScaleDownOnly(?align:Align);
}
enum Align {
	AlignFore;
	AlignMid;
	AlignAft;
}