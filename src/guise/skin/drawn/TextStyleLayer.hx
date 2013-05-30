package guise.skin.drawn;
import guise.accessTypes.IBoxPosAccess;
import guise.accessTypes.ITextOutputAccess;
import guise.data.ITextLabel;
import guise.platform.cross.IAccessRequest;
import guise.skin.common.PositionedLayer;
import guise.utils.TitleCase;


class TextStyleLayer extends PositionedLayer<TextLabelStyle>, implements IAccessRequest
{
	private static var ACCESS_TYPES:Array<Class<Dynamic>> = [ITextOutputAccess,IBoxPosAccess];


	@injectAdd
	private function onTextAdd(access:ITextOutputAccess):Void {
		if (layerName != null && access.layerName != layerName) return;
		
		_textDisplay = access;
		if (_textDisplay != null) {
			_textDisplay.idealDepth = idealDepth;
		}
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
		_layoutStyler.invalidate();
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
	
	
	@:isVar public var idealDepth(default, set_idealDepth):Int;
	private function set_idealDepth(value:Int):Int {
		this.idealDepth = value;
		if (_textDisplay != null) {
			_textDisplay.idealDepth = idealDepth;
		}
		return value;
	}
	
	private var _textDisplay:ITextOutputAccess;
	private var _pos:IBoxPosAccess;
	

	public function new(?layerName:String, ?normalStyle:TextLabelStyle) 
	{
		super(layerName,normalStyle);
	}
	public function getAccessTypes():Array<Class<Dynamic>> {
		return ACCESS_TYPES;
	}
	override private function _isReadyToDraw():Bool {
		return (textLabel != null && _textDisplay!=null);
	}
	override private function isPosReadyToDraw():Bool {
		return super.isPosReadyToDraw() && _pos!=null;
	}
	override private function layoutChanged():Void {
		if (!Math.isNaN(x) && !Math.isNaN(y)) {
			if (!Math.isNaN(w) && !Math.isNaN(h)) {
				_pos.set(x, y, w, h);
			}else {
				_pos.setPos(x, y);
			}
		}else if (!Math.isNaN(w) && !Math.isNaN(h)) {
			_pos.setSize(w, h);
		}
	}
	override private function _drawStyle():Void {
		var text = textLabel.text;
		if (text == null) text = "";
		switch(currentStyle) {
			case Tls(ts, selectable, tc, aa, alpha):
				_textDisplay.selectable = selectable;
				_textDisplay.setAntiAliasing(aa);
				_textDisplay.setText(new TextRun(ts, [Text(toCase(text, tc))]), true);
				_textDisplay.setAlpha(alpha==null?1:alpha);
		}
	}
	override private function _clearStyle():Void {
		_textDisplay.setText(null, true);
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
	Tls(ts:TextStyle, selectable:Bool, ?tc:TextCase, ?antiAliasing:AntiAliasType, ?alpha:Null<Float>);
}
enum TextCase {
	TcNormal;
	TcUpper;
	TcLower;
	TcTitle;
}