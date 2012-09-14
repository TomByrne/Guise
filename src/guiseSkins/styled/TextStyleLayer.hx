package guiseSkins.styled;
import guise.controls.ControlLayers;
import guise.traits.core.IPosition;
import guise.traits.core.Position;
import guise.traits.core.Size;
import guise.controls.data.ITextLabel;
import guise.utils.TitleCase;
import guiseSkins.styled.Styles;
import guise.platform.types.TextAccessTypes;
import guise.platform.types.DisplayAccessTypes;
import guise.platform.PlatformAccessor;

/**
 * @author Tom Byrne
 */

class TextStyleLayer extends AbsStyledLayer<TextLabelStyle> 
{
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
	private var _textPos:Position;
	private var _textSize:Size;

	public function new(layerName:String, ?normalStyle:TextLabelStyle) 
	{
		super(normalStyle);
		_textPos = new Position(0, 0);
		_textSize = new Size();
		
		_requireSize = true;
		
		addSiblingTrait(new PlatformAccessor(ITextOutputAccess, layerName, onTextAdd, onTextRemove));
	}
	private function onTextAdd(access:ITextOutputAccess):Void {
		_textDisplay = access;
		invalidate();
	}
	private function onTextRemove(access:ITextOutputAccess):Void {
		_textDisplay = null;
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