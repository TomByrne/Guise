package guise.accessTypes;

interface ITextOutputAccess implements IAccessType{
	var textWidth(get_textWidth, null):Float;
	var textHeight(get_textHeight, null):Float;
	
	var selectable(default, set_selectable):Bool;
	
	function setAntiAliasing(type:AntiAliasType):Void;
	function setText(run:TextRun, isHtml:Bool):Void;
	
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