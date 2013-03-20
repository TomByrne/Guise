package guise.accessTypes;

import msignal.Signal;

interface ITextOutputAccess extends IVisualAccessType {
	var textMeasChanged(get, null):Signal1<ITextOutputAccess>;
	
	var textWidth(get, null):Float;
	var textHeight(get, null):Float;
	
	var selectable(default, set):Bool;
	
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