package guise.platform.starling.accessTypes;
import guise.accessTypes.ITextOutputAccess;
import guise.platform.cross.FontRegistry;
import guise.platform.starling.addTypes.IDisplayObjectType;
import starling.display.Quad;
import starling.events.Event;
import starling.events.TouchEvent;
import starling.text.TextField;
import starling.display.DisplayObject;
import msignal.Signal;
import starling.utils.HAlign;
import starling.utils.VAlign;


@:build(LazyInst.check())
class TextAccess /*implements ITextInputAccess,*/ implements ITextOutputAccess, implements IDisplayObjectType
{
	@lazyInst
	public var textMeasChanged:Signal1<ITextOutputAccess>;
	
	private var _textField:TextField;
	private var _ignoreChanges:Bool;
	private var _textRun:TextRun;
	private var _textWidth:Float;
	private var _textHeight:Float;
	//private var _gutter:Float;
	
	public var layerName(default, set_layerName):String;
	private function set_layerName(value:String):String {
		this.layerName = value;
		_textField.name = value == null?"":value;
		return value;
	}

	public function new(?layerName:String, ?textField:TextField) 
	{
		//_gutter = TextFieldGutter.GUTTER;
		_textField = (textField == null?new TextField(500, 30, "", "", 12, 0, false):textField);
		_textField.hAlign = HAlign.LEFT;
		_textField.vAlign = VAlign.TOP;
		FontRegistry.getChanged().add(onFontsChanged);
		this.layerName = layerName;
		/*_textField.addEventListener(Event.CHANGE, onChange);
		_textField.addEventListener(FocusEvent.FOCUS_IN, onFocusIn);
		_textField.addEventListener(FocusEvent.FOCUS_OUT, onFocusOut);*/
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
	/*public var inputEnabled(default, set_inputEnabled):Bool;
	private function set_inputEnabled(value:Bool):Bool {
		_textField.type = value?TextFieldType.INPUT:TextFieldType.DYNAMIC;
		inputEnabled = value;
		return value;
	}*/
	
	public var selectable(default, set_selectable):Bool;
	private function set_selectable(value:Bool):Bool{
		//_textField.selectable = value;
		selectable = value;
		return value;
	}
	
	/*private function onChange(e:Event):Void {
		if (_ignoreChanges) return;
		if (textChanged != null) textChanged.dispatch(this);
	}*/
	/*private function onFocusIn(e:Event):Void {
		focused = true;
		if (focusedChanged != null) focusedChanged.dispatch(this);
	}
	private function onFocusOut(e:Event):Void {
		focused = false;
		if (focusedChanged != null) focusedChanged.dispatch(this);
	}*/
	
	/*public var textChanged(get_textChanged, null):Signal1 < ITextInputAccess > ;
	private function get_textChanged():Signal1 < ITextInputAccess >{
		if (textChanged == null) textChanged = new Signal1();
		return textChanged;
	}*/
	
	/*public var focused(default, null):Bool;
	
	public var focusedChanged(get_focusedChanged, null):Signal1 < ITextInputAccess >;
	private function get_focusedChanged():Signal1 < ITextInputAccess >{
		if (focusedChanged == null) focusedChanged = new Signal1();
		return focusedChanged;
	}*/
	
	
	public function setSize(w:Float, h:Float):Void {
		_textField.width = w;
		_textField.height = h;
	}
	public function getText():String {
		return _textField.text;
	}
	public function setText(run:TextRun, isHtml:Bool):Void {
		_textRun = run;
		
		if (_textField.stage == null ) return;
		
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
		_ignoreChanges = true;
		//_textField.dispatchEvent(new Event(Event.CHANGE));
		
		var widthWas:Float = _textField.width;
		var heightWas:Float = _textField.height;
		if (_textField.width <= 0 || _textField.height <= 0) {
			// gives bad readouts of textBounds if dimensions are set improperly
			_textField.width = 100;
			_textField.height = 100;
		}
		var newTextWidth:Float = _textField.textBounds.width;
		var newTextHeight:Float = _textField.textBounds.height;
		_textField.width = widthWas;
		_textField.height = heightWas;
		
		if (_textWidth != newTextWidth || _textHeight != newTextHeight) {
			_textWidth = newTextWidth;
			_textHeight = newTextHeight;
			LazyInst.exec(textMeasChanged.dispatch(this));
		}
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
	/*private function createHtml(runs:Array<TextRunData>, isHtml:Bool):String {
		var ret:String = "";
		for (run in runs) {
			if (ret.length > 0) ret += " ";
			switch(run) {
				case Text(text):
					ret += isHtml?StringTools.htmlEscape(text):text;
				case Run(textRun):
					var inner = createHtml(textRun.runs, isHtml);
					ret += wrapInFormat(textRun.style, inner);
			}
		}
		return ret;
	}
	private function wrapInFormat(style:TextStyle, inner:String):String {
		switch(style) {
			case Trs(tf,size,color,mods,align):
				var font:String = "";
				if(size!=null)font += "size='"+size+"' ";
				if(color!=null)font += "color='"+color+"' ";
				switch(tf) {
					case TfSans:		font += "face='_sans' ";
					case TfSerif:		font += "face='_serif' ";
					case TfTypewriter:	font += "face='_typewriter' ";
					case Tf(name):		font += "face='"+name+"' ";
				}
				if(mods!=null){
					for (mod in mods) {
						switch(mod) {
							case TmBold(bold):
								if (bold == null || bold) inner = "<b>" + inner + "</b>";
							case TmItalic(italic):
								if (italic == null || italic) inner = "<i>" + inner + "</i>";
							case TmUnderline(underline):
								if (underline == null || underline) inner = "<u>" + inner + "</u>";
							default:
								throw "Unsupported Text Mod: " + mod;
						}
					}
				}
				inner = wrapInAlign(align, inner);
				if (font.length > 0) {
					inner = "<font " + font + ">" + inner + "</font>";
				}
				return inner;
		}
	}
	private function wrapInAlign(align:Align, text:String):String {
		if (align != null) {
			var alignStr:String;
			switch(align) {
				case Left:alignStr = "left";
				case Right:alignStr = "right";
				case Center:alignStr = "center";
				case Justify:alignStr = "justify";
			}
			return "<p align='"+alignStr+"'>" + text + "</p>";
		}
		return text;
	}*/
}