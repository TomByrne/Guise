package guise.platform.types;
import guise.platform.IPlatformAccess;
import msignal.Signal;
/**
 * ...
 * @author Tom Byrne
 */

class TextAccessTypes 
{
}


interface ITextInputAccess implements IAccessType {
	public function getText():String ;
	public var textChanged(get_textChanged, null):Signal1 < ITextInputAccess > ;
	
	var inputEnabled(default, set_inputEnabled):Bool;
}


interface ITextOutputAccess implements IAccessType{
	function getTextWidth():Float;
	function getTextHeight():Float;
	
	var selectable(default, set_selectable):Bool;
	
	function setAntiAliasing(type:AntiAliasType):Void;
	function setText(run:TextRun, isHtml:Bool):Void;
	
	function setPos(x:Float, y:Float, w:Float, h:Float):Void;
	
}
class TextRun {
	public var style:TextStyle;
	public var runs:Array<TextRunData>;
	
	public function new(style:TextStyle, runs:Array<TextRunData>) {
		this.style = style;
		this.runs = runs;
	}
	public function addData(data:TextRunData):Void {
		if (runs == null) runs = [];
		runs.push(data);
	}
}
enum TextRunData {
	Text(text:String);
	Run(runs:TextRun);
}
enum AntiAliasType {
	AaPixel;
	AaSmooth;
	Aa(sharpness:Float, thickness:Float);
}
enum TextStyle {
	Trs(font:Null<Typeface>, size:Null<Float>, color:Null<Int>, ?mods:Array<TextModifier>, ?align:Align);
}
enum TextModifier {
	TmBold(?bold:Bool);
	TmItalic(?italic:Bool);
	TmUnderline(?underline:Bool);
	TmStrikeThru(?strikethrough:Bool);
}
enum Typeface {
	TfSans;
	TfSerif;
	TfTypewriter;
	Tf(name:String);
}
enum Align {
	Left;
	Center;
	Right;
	Justify;
}