package guise.skin.drawn;
import guise.controls.data.ITextLabel;
import guise.utils.TitleCase;
import guise.skin.drawn.utils.DrawnStyles;
import guise.accessTypes.ITextOutputAccess;
import guise.accessTypes.IBoxPosAccess;
import guise.skin.values.IValue;
import guise.accessTypes.IMouseInteractionsAccess;
import guise.skin.common.PositionedLayer;


class TextStyleLayer extends PositionedLayer<TextLabelStyle>
{


	@injectAdd
	private function onTextAdd(access:ITextOutputAccess):Void {
		if (layerName != null && access.layerName != layerName) return;
		
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
		if (layerName != null && access.layerName != layerName) return;
		
		_pos = access;
		invalidate();
	}
	@injectRemove
	private function onPosRemove(access:IBoxPosAccess):Void {
		if (access != _pos) return;
		
		_pos = null;
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
	

	public function new(?layerName:String, ?normalStyle:TextLabelStyle) 
	{
		super(layerName,normalStyle);
	}
	override private function _isReadyToDraw():Bool {
		if (textLabel == null || _textDisplay==null) return false;
		return super._isReadyToDraw();
	}
	override private function _drawStyle():Void {
		var text = textLabel.text;
		if (text == null) text = "";
		switch(currentStyle) {
			case Tls(ts, selectable, tc, aa):
				_textDisplay.selectable = selectable;
				_textDisplay.setAntiAliasing(aa);
				_textDisplay.setText(new TextRun(ts, [Text(toCase(text, tc))]), true);
				
				if(_pos!=null)_pos.set(x, y, w, h);
		}
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
	Tls(ts:TextStyle, selectable:Bool, ?tc:TextCase, ?antiAliasing:AntiAliasType);
}
enum TextCase {
	TcNormal;
	TcUpper;
	TcLower;
	TcTitle;
}