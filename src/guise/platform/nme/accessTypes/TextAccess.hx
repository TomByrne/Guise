package guise.platform.nme.accessTypes;
import guise.accessTypes.IBoxPosAccess;
import guise.accessTypes.ITextInputAccess;
import guise.accessTypes.ITextOutputAccess;
import guise.platform.nme.TextFieldGutter;
import nme.events.Event;
import nme.text.TextField;
import nme.text.TextFieldType;
import nme.text.TextFormat;
import msignal.Signal;


@:build(LazyInst.check())
class TextAccess extends AbsIntObjAccess, implements ITextInputAccess, implements ITextOutputAccess, implements IBoxPosAccess
{
	@lazyInst
	public var textMeasChanged:Signal1<ITextOutputAccess>;
	
	private var _textField:TextField;
	private var _ignoreChanges:Bool;
	private var _gutter:Float;
	
	override private function set_layerName(value:String):String {
		_textField.name = value == null?"":value;
		return super.set_layerName(value);
	}

	public function new(?layerName:String, ?textField:TextField) 
	{
		_gutter = TextFieldGutter.GUTTER;
		_textField = (textField==null?new TextField():textField);
		_textField.addEventListener(Event.CHANGE, onChange);
		setInteractiveObject(_textField);
		super(layerName);
	}
	public function setPos(x:Float, y:Float):Void {
		_textField.x = x-_gutter;
		_textField.y = y-_gutter;
	}
	public function setSize(w:Float, h:Float):Void {
		_textField.width = w+_gutter*2;
		_textField.height = h+_gutter*2;
	}
	public function set(x:Float, y:Float, w:Float, h:Float):Void {
		_textField.x = x-_gutter;
		_textField.y = y-_gutter;
		_textField.width = w+_gutter*2;
		_textField.height = h+_gutter*2;
	}
	public var textWidth(get_textWidth, null):Float;
	private function get_textWidth():Float {
		return _textField.textWidth;
	}
	public var textHeight(get_textHeight, null):Float;
	private function get_textHeight():Float {
		return _textField.textHeight;
	}
	public function setAntiAliasing(type:AntiAliasType):Void {
		switch(type) {
			case AaPixel:
				_textField.antiAliasType = NmeAA.ADVANCED;
				#if (flash || js)
					_textField.sharpness = 400;
				#end
				#if flash
					_textField.thickness = 0;
				#end
				//textField.gridFitType = GridFitType.PIXEL;
			case AaSmooth:
				_textField.antiAliasType = NmeAA.NORMAL;
			case Aa(sharpness, thickness):
				_textField.antiAliasType = NmeAA.ADVANCED;
				#if (flash || js)
					_textField.sharpness = sharpness;
				#end
				#if flash
					_textField.thickness = thickness;
				#end
				//textField.gridFitType = GridFitType.NONE;
		}
	}
	public var inputEnabled(default, set_inputEnabled):Bool;
	private function set_inputEnabled(value:Bool):Bool {
		_textField.type = value?TextFieldType.INPUT:TextFieldType.DYNAMIC;
		inputEnabled = value;
		return value;
	}
	
	public var selectable(default, set_selectable):Bool;
	private function set_selectable(value:Bool):Bool{
		_textField.selectable = value;
		selectable = value;
		return value;
	}
	
	private function onChange(e:Event):Void {
		if (_ignoreChanges) return;
		if (textChanged != null) textChanged.dispatch(this);
	}
	
	public var textChanged(get_textChanged, null):Signal1 < ITextInputAccess > ;
	private function get_textChanged():Signal1 < ITextInputAccess >{
		if (textChanged == null) textChanged = new Signal1();
		return textChanged;
	}
	
	
	
	public function getText():String {
		return _textField.text;
	}
	public function setText(run:TextRun, isHtml:Bool):Void {
		if (_ignoreChanges) return;
		
		var text:String;
		var format:TextFormat = new TextFormat();
		if (run != null) {
			text = createHtml(run.runs, isHtml);
			switch(run.style) {
				case Trs(font,size,color,mods,align):
					if(size!=null)format.size = size;
					if (color != null) format.color = color;
					switch(font) {
						case TfSans:		format.font = "_sans";
											_textField.embedFonts = false;
						case TfSerif:		format.font = "_serif";
											_textField.embedFonts = false;
						case TfTypewriter:	format.font = "_typewriter";
											_textField.embedFonts = false;
						case Tf(name):		format.font = name;
											_textField.embedFonts = true;
					}
					if(mods!=null){
						for (mod in mods) {
							switch(mod) {
								case TmBold(bold):
									format.bold = (bold==null?true:bold);
								case TmItalic(italic):
									format.italic = (italic==null?true:italic);
								case TmUnderline(underline):
									format.underline = (underline==null?true:underline);
								default:
									throw "Unsupported Text Mod: " + mod;
							}
						}
					}
					text = wrapInAlign(align, text);
			}
		}else {
			text = "";
		}
		_textField.defaultTextFormat = format;
		if (text.indexOf("<") == -1)_textField.text = text; // jeash has issues with 'htmlText'
		else _textField.htmlText = text;
		_ignoreChanges = true;
		_textField.dispatchEvent(new Event(Event.CHANGE));
		LazyInst.exec(textMeasChanged.dispatch(this));
		_ignoreChanges = false;
		
	}
	public function setAlpha(alpha:Float):Void {
		_textField.alpha = alpha;
	}
	private function createHtml(runs:Array<TextRunData>, isHtml:Bool):String {
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
	}
}
typedef NmeAA = nme.text.AntiAliasType;
typedef NmeTextFormat = nme.text.TextFormat;