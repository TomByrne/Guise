package guise.skin.drawn.utils;
import guise.values.IValue;
import guise.values.Value;
import guise.trans.StyleTransitioner;
import composure.traits.AbstractTrait;
import guise.trans.IPropEaser;
import guise.skin.drawn.BoxLayer;
import guise.trans.TransStyle;
import guise.trans.ColorEaser;
import guise.utils.Clone;
import guise.trans.UtilFunctions;
import guise.skin.drawn.utils.DrawnStyles;
import guise.accessTypes.IFilterableAccess;
import guise.skin.common.PositionedLayer;

class DrawnStyleTrans extends StyleTransitioner
{

	public function new() 
	{
		super();
		
		normalTransStyle = new TransStyle(0.15, EaseOut);
		addStyleSwitch(TypeSwitch(valueSwitch, IValue, IValue));
		addStyleSwitch(EnumValueSwitch(StyleTransitioner.ease([SwitchEase(), UseStyle, UseStyle]), SsSolid(0.0001, null, null),SsNone));
		addStyleSwitch(EnumValueSwitch(StyleTransitioner.goVia([SwitchEase(), NormalEase(), SwitchEase(), NormalEase(ColorEaser.getNew), NormalEase(), UseStyle]), DropShadow(0, -1, 0, -1, -1), DropShadow(0, -1, 0, -1, -1), function(s1:Dynamic, p1:Array<Dynamic>, s2:Dynamic, p2:Array<Dynamic>):Bool { return p1[5] != p2[5]; } ));
		addStyleSwitch(EnumValueSwitch(easeCapsuleToRoundedRect, BsCapsule(null,null), BsRectComplex(null,null,null), checkCapsuleToRoundedRect));
		addStyleSwitch(EnumValueSwitch(StyleTransitioner.ease([SwitchEase()]), CsCirc(0),CsSquare));
		addStyleSwitch(EnumTypeSwitch(easeFillToDiffFill,FillStyle, FillStyle, checkFillToDiffFill));
		addStyleSwitch(EnumTypeSwitch(easeGradientColours,FillStyle, FillStyle, checkGradientColours));
		addPropEaser(FsSolid(0, 0), 0, ColorEaser.getNew);
	}
	private function valueSwitch(subject:Dynamic, direction:Bool, style1:Dynamic, style2:Dynamic):Array<SwitchSpanInfo> {
		var value1:IValue = cast style1;
		value1.update(cast subject.item);
		
		var value2:IValue = cast style2;
		value2.update(cast subject.item);
		
		var via:Value;
		if (Std.is(style2, Value)) {
			via = cast style2;
		}else {
			via = new Value(value2.currentValue);
		}
		var toParams:Hash<Dynamic> = new Hash();
		toParams.set("value", Math.isNaN(value1.currentValue)?value2.currentValue: value1.currentValue);
		return [{ via:via, toParams:toParams, easerFuncs:null}];
	}
	private function checkFillToDiffFill(style1:Dynamic, params1:Array<Dynamic>, style2:Dynamic, params2:Array<Dynamic>):Bool{
		var const1:Int = Type.enumIndex(style1);
		var const2:Int = Type.enumIndex(style2);
		if (const1 == const2) {
			switch(style1) {
				case FsSolid(c, a):return false;
				case FsNone: return false;
				case FsTransparent: return false;
				default: return params1[0].length!=params2[0].length;
			}
		}else {
			return true;
		}
	}
	
	private function easeFillToDiffFill(subject:Dynamic, direction:Bool, enum1:Enum<Dynamic>, style1Match:Dynamic, enum2:Enum<Dynamic>, style2Match:Dynamic):Array<SwitchSpanInfo> {
		var fill1Start:FillStyle = cast style1Match;
		var fill2Start:FillStyle = cast style2Match;
		
		var fill1End:FillStyle = cast style1Match;
		var fill2End:FillStyle = cast style2Match;
		
		if (direction) {
			fill2Start = Clone.clone(fill2Start);
			setFillOpacity(fill2Start, 0, false);
			
			setFillOpacity(fill2End, 1, true);
			
			setFillOpacity(fill1Start,1, true);
			
			fill1End = Clone.clone(fill1End);
			setFillOpacity(fill1End,0, false);
		}else {
			fill1Start = Clone.clone(fill1Start);
			setFillOpacity(fill1Start, 0, false);
			
			setFillOpacity(fill1End, 1, true);
			
			setFillOpacity(fill2Start,1, true);
			
			fill2End = Clone.clone(fill2End);
			setFillOpacity(fill2End,0, false);
		}
		
		var via:Dynamic = FsMulti([fill1Start, fill2Start]);
		var toParams:Array<Dynamic> = [[fill1End, fill2End]];
		return [{ via:via, toParams:toParams, easerFuncs:null}];
	}
	private function checkGradientColours(style1:Dynamic, params1:Array<Dynamic>, style2:Dynamic, params2:Array<Dynamic>):Bool{
		var const1:Int = Type.enumIndex(style1);
		var const2:Int = Type.enumIndex(style2);
		if (const1 == const2) {
			switch(style1) {
				case FsSolid(c, a):return false;
				case FsNone: return false;
				case FsTransparent: return false;
				default:
					var col1:Array<Int> = params1[0];
					var col2:Array<Int> = params2[0];
					if (col1.length != col2.length) return false; // can't trans between different amount of points
					
					for (i in 0...col1.length) {
						if (col1[i] != col2[i]) return true;
					}
					return false; // if all colors are the same, no need for this interpolation
			}
		}else {
			return false;
		}
	}
	
	private function easeGradientColours(subject:Dynamic, direction:Bool, enum1:Enum<Dynamic>, style1Match:Dynamic, enum2:Enum<Dynamic>, style2Match:Dynamic):Array<SwitchSpanInfo> {
		setFillOpacity(cast style1Match, 1, true);
		setFillOpacity(cast style2Match, 1, true);
		var via = Clone.clone(style1Match);
		var toParams:Array<Dynamic> = Type.enumParameters(style2Match);
		var easerFuncs:Array<EaserFactFunc> = [ColorArrayEaser.getNew];
		return [{ via:via, toParams:toParams, easerFuncs:easerFuncs}];
	}
	private function setFillOpacity(fill:FillStyle, to:Float, onlyIfNull:Bool):Void {
		var params:Array<Dynamic> = Type.enumParameters(fill);
		switch(fill) {
			case FsSolid(c, a):
				if (onlyIfNull) {
					if(a==null)params[1] = to;
				}else params[1] = (a == null?to:a * to);
			case FsLinearGradient(c, a, r, mat):
				setGradPointOpacity(a, to, onlyIfNull);
			case FsRadialGradient(c, a, r, mat, fpr):
				setGradPointOpacity(a, to, onlyIfNull);
			case FsHLinearGradient(c, a, r):
				setGradPointOpacity(a, to, onlyIfNull);
			case FsVLinearGradient(c, a, r):
				setGradPointOpacity( a, to, onlyIfNull);
			case FsMulti(fills):
				for (fill in fills) setFillOpacity(fill, to, onlyIfNull);
			default:
		}
	}
	private function setGradPointOpacity( alphas:Array<Null<Float>>, to:Float, onlyIfNull:Bool):Void {
		if(onlyIfNull){
			for (i in 0...alphas.length) {
				var a = alphas[i];
				if(a==null || Math.isNaN(a))alphas[i] = to;
			}
		}else {
			for (i in 0...alphas.length) {
				var a = alphas[i];
				alphas[i] = (a==null || Math.isNaN(a)?to:a * to);
			}
		}
	}
	
	private function easeCapsuleToRoundedRect(subject:Dynamic, direction:Bool, style1:Dynamic, style1Match:Dynamic, style2:Dynamic, style2Match:Dynamic):Array<SwitchSpanInfo> {
		var params = Type.enumParameters(style1Match);
		var otherParams = Type.enumParameters(style2Match);
		var box:BoxLayer = cast subject;
		var exW:Float = params[2];
		if (Math.isNaN(exW)) exW = 0;
		var exH:Float = params[3];
		if (Math.isNaN(exH)) exH = 0;
		
		var r:Float = Math.min(box.w+exW, box.h+exH) / 2;
		var circCorners:Corners;
		var capCorners:Corners;
		switch(direction?otherParams[2]:params[2]) {
			case CSame(cs):
				var cParams:Array<Dynamic> = Type.enumParameters(cs);
				circCorners = CSame(CsCirc(cParams.length>0?cParams[0]:0));
				capCorners = CSame(CsCirc(r));
			case CDiff(tl, tr, br, bl):
				var tlParams:Array<Dynamic> = Type.enumParameters(tl);
				var trParams:Array<Dynamic> = Type.enumParameters(tr);
				var brParams:Array<Dynamic> = Type.enumParameters(br);
				var blParams:Array<Dynamic> = Type.enumParameters(bl);
				circCorners = CDiff(CsCirc(tlParams.length>0?tlParams[0]:0),CsCirc(trParams.length>0?trParams[0]:0),CsCirc(brParams.length>0?brParams[0]:0),CsCirc(blParams.length>0?blParams[0]:0));
				capCorners = CDiff(CsCirc(r),CsCirc(r),CsCirc(r),CsCirc(r));
		}
		
		
		var via:Dynamic = BsRectComplex(Clone.clone(params[0]), Clone.clone(params[1]), direction?capCorners:circCorners/*, Clone.clone(direction?params[2]:params[3]), Clone.clone(direction?params[3]:params[4])*/);
		var toParams:Array<Dynamic> = [];
		toParams[0] = otherParams[0];
		toParams[1] = otherParams[1];
		toParams[2] = direction?circCorners:capCorners;
		toParams[3] = direction?otherParams[3]:otherParams[2];
		toParams[4] = direction?otherParams[4]:otherParams[3];
		
		return [{via:via,toParams:toParams,easerFuncs:null}];
	}
	private function checkCapsuleToRoundedRect(style1:BoxStyle, params1:Array<Dynamic>, style2:BoxStyle, params2:Array<Dynamic>):Bool {
		switch(style2) {
			case BsRectComplex(f,s,c,e):
				var circIndex:Int = Type.enumIndex(CsCirc(0));
				var squaIndex:Int = Type.enumIndex(CsSquare);
				switch(c) {
					case CSame(cs):
						var cIndex:Int = Type.enumIndex(cs);
						return (cIndex==circIndex || cIndex==squaIndex);
					case CDiff(tl, tr, br, bl):
						var tlIndex:Int = Type.enumIndex(tl);
						var trIndex:Int = Type.enumIndex(tr);
						var blIndex:Int = Type.enumIndex(bl);
						var brIndex:Int = Type.enumIndex(br);
						return ((tlIndex == circIndex || tlIndex == squaIndex) && 
								(trIndex == circIndex || trIndex == squaIndex) && 
								(blIndex == circIndex || blIndex == squaIndex) && 
								(brIndex == circIndex || brIndex == squaIndex)
								);
				}
			default: return false;
		}
	}
}

import guise.trans.IPropEaser;
class ColorArrayEaser implements IPropEaser {
	private static var _pool:Array<ColorArrayEaser>;
	public static function getNew(subject:Dynamic, prop:Dynamic, start:Array<Int>, end:Array<Int>):ColorArrayEaser {
		if (_pool == null) {
			_pool = [];
			return new ColorArrayEaser(subject, prop, start, end);
		}else if (_pool.length>0) {
			var ret =  _pool.pop();
			ret.subject = subject;
			ret.prop = prop;
			ret.start = start;
			ret.end = end;
			return ret;
		}else {
			return new ColorArrayEaser(subject, prop, start, end);
		}
	}
	
	public var subject:Dynamic;
	public var prop:Dynamic;
	public var start:Array<Int>;
	public var end:Array<Int>;
	
	public var inited:Bool;
	public var curr:Array<Int>;
	public var colStart:Array<{r:Int,g:Int,b:Int}>;
	public var colDiff:Array<{r:Int,g:Int,b:Int}>;
	
	public function new(subject:Dynamic, prop:Dynamic, start:Array<Int>, end:Array<Int>) {
		this.subject = subject;
		this.prop = prop;
		this.start = start;
		this.end = end;
		inited = false;
	}
	public function release():Void {
		subject = null;
		_pool.push(this);
		inited = false;
	}
	public function update(fract:Float):Void {
		if (!inited) {
			inited = true;
			curr = [];
			colStart = [];
			colDiff = [];
			for (i in 0...start.length) {
				var sta = start[i];
				var fin = end[i];
				curr.push(sta);
				
				var sta = {	r:(( sta >> 16 ) & 0xFF),
								g:(( sta >> 8 ) & 0xFF),
								b:(( sta ) & 0xFF)};
				colStart.push(sta);
				
				colDiff.push({	r:(( fin >> 16 ) & 0xFF)-sta.r,
								g:(( fin >> 8 ) & 0xFF)-sta.g,
								b:(( fin ) & 0xFF) - sta.b} );
			}
		}
		for (i in 0...start.length) {
			var sta = colStart[i];
			var dif = colDiff[i];
			
			var newR:Int = Std.int(sta.r + dif.r * fract);
			var newG:Int = Std.int(sta.g + dif.g * fract);
			var newB:Int = Std.int(sta.b + dif.b * fract);
			curr[i] = ( ( newR << 16 ) | ( newG << 8 ) | newB );
		}
		UtilFunctions.setProperty(subject, prop, curr);
	}
}