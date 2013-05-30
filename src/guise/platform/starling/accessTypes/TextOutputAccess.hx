package guise.platform.starling.accessTypes;
import guise.accessTypes.IBoxPosAccess;
import guise.accessTypes.ITextOutputAccess;
import guise.platform.cross.accessTypes.AbsVisualAccessType;
import guise.platform.cross.FontRegistry;
import guise.platform.starling.addTypes.IDisplayObjectType;
import guise.platform.starling.TextFieldGutter;
import starling.display.Quad;
import starling.events.Event;
import starling.events.TouchEvent;
import starling.text.TextField;
import starling.display.DisplayObject;
import msignal.Signal;
import starling.utils.HAlign;
import starling.utils.VAlign;


@:build(LazyInst.check())
class TextOutputAccess extends AbsVisualAccessType, implements ITextOutputAccess, implements IDisplayObjectType, implements IBoxPosAccess
{
	private static var MIN_SIZE:Float = 9;
	
	
	@lazyInst
	public var textMeasChanged:Signal1<ITextOutputAccess>;
	
	@lazyInst
	public var textRunChanged:Signal1 < ITextOutputAccess > ;
	
	public var textField(get_textField, null):TextField;
	private function get_textField():TextField {
		return _textField;
	}
	
	private var _textField:TextField;
	private var _ignoreChanges:Bool;
	private var _textRun:TextRun;
	private var _textWidth:Float;
	private var _textHeight:Float;
	private var _wGutter:Float;
	private var _hGutter:Float;
	
	override private function set_layerName(value:String):String {
		_textField.name = value == null?"":value;
		return super.set_layerName(value);
	}

	public function new(?layerName:String, ?textField:TextField) 
	{
		_wGutter = TextFieldGutter.W_GUTTER;
		_hGutter = TextFieldGutter.H_GUTTER;
		_textField = (textField == null?new TextField(100, 30, "", "", 12, 0, false):textField);
		_textField.hAlign = HAlign.LEFT;
		_textField.vAlign = VAlign.TOP;
		FontRegistry.getChanged().add(onFontsChanged);
		super(layerName);
	}
	public function setPos(x:Float, y:Float):Void {
		_textField.x = x-_wGutter;
		_textField.y = y-_hGutter;
	}
	public function setSize(w:Float, h:Float):Void {
		if (h < MIN_SIZE) h = MIN_SIZE;
		if (w < MIN_SIZE) w = MIN_SIZE;
		
		_textField.width = w+_wGutter*2;
		_textField.height = h+_hGutter*2;
	}
	public function set(x:Float, y:Float, w:Float, h:Float):Void {
		if (h < MIN_SIZE) h = MIN_SIZE;
		if (w < MIN_SIZE) w = MIN_SIZE;
		
		_textField.x = x-_wGutter;
		_textField.y = y-_hGutter;
		_textField.width = w+_wGutter*2;
		_textField.height = h+_hGutter*2;
	}
	private function onFontsChanged():Void{
		if(_textRun!=null)setText(_textRun, false);
	}
	public function getDisplayObject():DisplayObject {
		return _textField;
	}
	public var textWidth(get_textWidth, null):Float;
	private function get_textWidth():Float {
		return _textWidth;
	}
	public var textHeight(get_textHeight, null):Float;
	private function get_textHeight():Float{
		return _textHeight;
	}
	public function setAntiAliasing(type:AntiAliasType):Void {
		switch(type) {
			case AaPixel:
				//_textField.antiAliasType = StarlingAA.ADVANCED;
				//_textField.sharpness = 400;
				//_textField.thickness = 0;
			case AaSmooth:
				//_textField.antiAliasType = StarlingAA.NORMAL;
			case Aa(sharpness, thickness):
				//_textField.antiAliasType = StarlingAA.ADVANCED;
				//_textField.sharpness = sharpness;
				//_textField.thickness = thickness;
		}
	}
	
	public var selectable(default, set_selectable):Bool;
	private function set_selectable(value:Bool):Bool{
		selectable = value;
		return value;
	}
	
	
	public function getText():String {
		return _textField.text;
	}
	public function setText(run:TextRun, isHtml:Bool):Void {
		_textRun = run;
		
		if (_textField.stage == null ) return;
		
		if (run != null) {
				
			switch(run.style) {
				case Trs(tf, size, color, mods, align):
					switch(tf) {
						case TfSans:
							_textField.fontName = "_sans";
						case TfSerif:
							_textField.fontName = "_serif";
						case TfTypewriter:
							_textField.fontName = "_typewriter";
						case Tf(fontName):
							_textField.fontName = fontName;
					}
					
					if(align!=null){
						switch(align) {
							case Left:
								_textField.hAlign = HAlign.LEFT;
							case Right:
								_textField.hAlign = HAlign.RIGHT;
							case Justify, Center:
								_textField.hAlign = HAlign.CENTER;
						}
					}else {
						_textField.hAlign = HAlign.LEFT;
					}
					
					_textField.fontSize = size;
					_textField.color = color;
					var boldFound:Bool = false;
					var italicFound:Bool = false;
					var underlineFound:Bool = false;
					for (mod in mods) {
						switch(mod){
							case TmBold(bold):
								if (bold==null || bold) {
									boldFound = true;
								}
							case TmItalic(italic):
								if (italic==null || italic) {
									italicFound = true;
								}
							case TmUnderline(underline):
								if (underline==null || underline) {
									underlineFound = true;
								}
							default:
								//ignore
						}
					}
					_textField.bold = boldFound;
					_textField.italic = italicFound;
					_textField.underline = underlineFound;
			}
			_textField.text = getTextStr(run.runs);
		}else {
			_textField.text = "";
		}
		_ignoreChanges = true;
		//_textField.dispatchEvent(new Event(Event.CHANGE));
		
		var newTextWidth:Float;
		var newTextHeight:Float;
		var widthWas:Float = _textField.width;
		var heightWas:Float = _textField.height;
		if (_textField.width <= 0 || _textField.height <= 0 || !Math.isFinite(_textField.textBounds.width) || !Math.isFinite(_textField.textBounds.height)) {
			// gives bad readouts of textBounds if dimensions are set improperly
			_textField.width = 500;
			_textField.height = 100;
		}
		newTextWidth = _textField.textBounds.width;
		newTextHeight = _textField.textBounds.height+1;
		_textField.width = widthWas;
		_textField.height = heightWas;
		
		if (newTextWidth < 1) newTextWidth = 1;
		if (newTextHeight < 1) newTextHeight = 1;
		
		if (_textWidth != newTextWidth || _textHeight != newTextHeight) {
			_textWidth = newTextWidth;
			_textHeight = newTextHeight;
			LazyInst.exec(textMeasChanged.dispatch(this));
		}
		LazyInst.exec(textRunChanged.dispatch(this));
		_ignoreChanges = false;
		
	}
	private function getTextStr(runs:Array<TextRunData>):String {
		var ret:String = "";
		for (run in runs) {
			if (ret.length > 0) ret += " ";
			switch(run) {
				case Text(text):
					ret += text;
				case Run(textRun):
					ret += getTextStr(textRun.runs);
			}
		}
		return ret;
	}
	public function setAlpha(alpha:Float):Void {
		_textField.alpha = alpha;
	}
}