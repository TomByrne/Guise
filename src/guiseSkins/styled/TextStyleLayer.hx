package guiseSkins.styled;
import guise.controls.ControlLayers;
import guise.styledLayers.ITextLayer;
import guise.traits.core.IPosition;
import guise.traits.core.ISize;
import guise.controls.data.ITextLabel;
import guise.utils.TitleCase;
import guiseSkins.styled.Styles;
import guise.accessTypes.IFilterableAccess;
import guise.accessTypes.ITextOutputAccess;
import guise.accessTypes.IBoxPosAccess;
import guiseSkins.styled.values.IValue;
import guise.accessTypes.IMouseInteractionsAccess;

/**
 * @author Tom Byrne
 */

class TextStyleLayer extends AbsStyledLayer<TextLabelStyle>//, implements ITextLayer
{
	@injectAdd
	private function onFilterAdd(access:IFilterableAccess):Void {
		if (_layerName != null && access.layerName != _layerName) return;
		
		_filterLayer = access;
		if (filterLayer!=null) {
			filterLayer.filterAccess = access;
		}
	}
	@injectRemove
	private function onFilterRemove(access:IFilterableAccess):Void {
		if (access != _filterLayer) return;
		
		_filterLayer = null;
		if (filterLayer!=null) {
			filterLayer.filterAccess = null;
		}
	}
	
	@injectAdd
	private function onTextAdd(access:ITextOutputAccess):Void {
		if (_layerName != null && access.layerName != _layerName) return;
		
		_textDisplay = access;
		invalidate();
	}
	@injectRemove
	private function onTextRemove(access:ITextOutputAccess):Void {
		if (access != _textDisplay) return;
		
		_textDisplay = null;
	}
	
	@injectAdd
	private function onPosAdd(access:IBoxPosAccess):Void {
		if (_layerName != null && access.layerName != _layerName) return;
		
		_pos = access;
		invalidate();
	}
	@injectRemove
	private function onPosRemove(access:IBoxPosAccess):Void {
		if (access != _pos) return;
		
		_pos = null;
	}
	
	public var filterLayer(default, set_filterLayer):FilterLayer;
	private function set_filterLayer(value:FilterLayer):FilterLayer {
		if (filterLayer != null) {
			filterLayer.filterAccess = null;
			removeSiblingTrait(filterLayer);
		}
		filterLayer = value;
		if (filterLayer != null) {
			filterLayer.filterAccess = _filterLayer;
			addSiblingTrait(filterLayer);
		}
		return value;
	}
	
	
	
	@inject
	public var textLabel(default, set_textLabel):ITextLabel;
	private function set_textLabel(value:ITextLabel):ITextLabel {
		if (textLabel != null) {
			textLabel.textChanged.remove(onTextChanged);
		}
		textLabel = value;
		if (textLabel != null) {
			textLabel.textChanged.add(onTextChanged);
		}
		invalidate();
		return value;
	}
	
	private var _textDisplay:ITextOutputAccess;
	private var _pos:IBoxPosAccess;
	private var _filterLayer:IFilterableAccess;
	private var _layerName:String;

	public function new(layerName:String, ?normalStyle:TextLabelStyle) 
	{
		super(normalStyle);
		_layerName = layerName;
		
		_requireSize = true;
	}
	override private function _isReadyToDraw():Bool {
		if (textLabel == null || _textDisplay==null) return false;
		return super._isReadyToDraw();
	}
	override private function _drawStyle():Void {
		var text = textLabel.text;
		if (text == null) text = "";
		switch(currentStyle) {
			case Tls(ts, selectable, tc, aa, hAlign, vAlign, padT, padB, padL, padR):
				_textDisplay.selectable = selectable;
				_textDisplay.setAntiAliasing(aa);
				_textDisplay.setText(new TextRun(ts, [Text(toCase(text, tc))]), true);
				
				if(_pos!=null)layoutText(_textDisplay, w, h, hAlign, vAlign, padT, padB, padL, padR);
		}
	}
	private function layoutText(textDisplay:ITextOutputAccess, w:Float, h:Float, hAlign:HAlign, vAlign:VAlign, padT:IValue, padB:IValue, padL:IValue, padR:IValue):Void {
		var tW:Float = textDisplay.getTextWidth();
		var tH:Float = textDisplay.getTextHeight();
		
		var pT:Float = getValue(padT, 0);
		var pB:Float = getValue(padB, 0);
		var pL:Float = getValue(padL, 0);
		var pR:Float = getValue(padR, 0);
		
		w -= pT + pB;
		h -= pL + pR;
		
		var tX:Float;
		var tY:Float;
		
		if (tW > w || hAlign==null) {
			tX = pL;
			tW = w;
		}else{
			switch(hAlign) {
				case Left:
					tX = pL;
				case Right:
					tX = pL + w - tW;
				default:
					tX = pL + (w - tW) / 2;
			}
		}
		
		if (tH > h || vAlign == null) {
			tY = pT;
			tH = h;
		}else {
			switch(vAlign) {
				case Top:
					tY = pT;
				case Bottom:
					tY = pT + h - tH;
				default:
					tY = pT + (h - tH) / 2;
			}
		}
		_pos.set(tX, tY, tW, tH);
	}
	private function toCase(str:String, textCase:TextCase):String{
			if (textCase != null) {
				switch(textCase) {
					case TcLower: return str.toLowerCase();
					case TcUpper: return str.toUpperCase();
					case TcTitle: return TitleCase.toTitleCase(str);
					case TcNormal: return str;
				}
			}else {
				return str;
			}
	}
	private function onTextChanged(from:ITextLabel):Void {
		invalidate();
	}
	
}
enum TextLabelStyle {
	Tls(ts:TextStyle, selectable:Bool, ?tc:TextCase, ?antiAliasing:AntiAliasType, ?hAlign:HAlign, ?vAlign:VAlign, ?padT:IValue, ?padB:IValue, ?padL:IValue, ?padR:IValue);
}
enum TextCase {
	TcNormal;
	TcUpper;
	TcLower;
	TcTitle;
}