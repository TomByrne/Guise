package guiseSkins.trans;

import feffects.Tween;
import guiseSkins.trans.ITransitioner;
import guise.utils.Clone;
import guiseSkins.trans.PropEaser;

/**
 * ...
 * @author Tom Byrne
 */

class StyleTransitioner implements ITransitioner
{
	public var normalTransStyle:TransStyle;
	
	private var styleSwitches:Array<StyleSwitch>;
	private var propEasers:Array<PropEaserInfo>;

	public function new() 
	{
	
	}
	
	public function addStyleSwitch(styleSwitch:StyleSwitch):Void {
		if (styleSwitches == null) {
			styleSwitches = [];
		}
		styleSwitches.push(styleSwitch);
	}
	
	public function addPropEaser(styleType:Dynamic, paramIndex:Int, propEaserFact:EaserFactFunc):Void {
		if (propEasers == null) {
			propEasers = [];
		}
		propEasers.push(new PropEaserInfo(styleType, paramIndex, propEaserFact));
	}
	
	public function doTrans(from:Dynamic, to:Dynamic, subject:Dynamic, ?prop:String, ?update:Dynamic->Void, ?finish:Dynamic->Void):TransTracker {
		var bundle:TransTracker = TransTracker.getNew(transFinished);
		
		bundle.update = update;
		bundle.finish = finish;
		
		bundle.subject = subject;
		
		bundle.to = to;
		bundle.from = from;
		
		bundle.transStyle = findTransStyle(from, to, subject, prop);
		
		var rootSpan:TransSpan = TransSpan.getNew();
		rootSpan.start = 0;
		rootSpan.length = 1;
		bundle.fract = 0;
		bundle.transSpans = [rootSpan];
		
		var dest = Clone.clone(to);
		bundle.curr = checkSpan(bundle, rootSpan, subject, prop, from, dest);
		
		var easing;
		/*switch(bundle.transStyle.easing) {
			case EaseIn:
				easing = com.eclecticdesignstudio.motion.easing.Quad.easeIn;
			case EaseInOut:
				easing = com.eclecticdesignstudio.motion.easing.Quad.easeInOut;
			case EaseOut:
				easing = com.eclecticdesignstudio.motion.easing.Quad.easeOut;
		}*/
		switch(bundle.transStyle.easing) {
			case EaseIn:
				easing = feffects.easing.Quad.easeIn;
			case EaseInOut:
				easing = feffects.easing.Quad.easeInOut;
			case EaseOut:
				easing = feffects.easing.Quad.easeOut;
		}
		bundle.tweenFract(1, bundle.transStyle.time, easing);
		
		return bundle;
	}
	private function findTransStyle(from:Dynamic, to:Dynamic, subject:Dynamic, prop:String):TransStyle {
		return normalTransStyle;
	}
	private function checkSpan(bundle:TransTracker, span:TransSpan, parent:Dynamic, prop:Dynamic, from:Dynamic, dest:Dynamic, ?easerFact:EaserFactFunc):Dynamic {
		/*#if debug
		if (Type.typeof(from) != Type.typeof(to)) {
			trace("Can't transition between two values of different core type");
		}
		#end*/
		var checkVar:Dynamic = (dest == null?from:dest);
		if(easerFact!=null){
			if (span.easeProps == null) span.easeProps = [];
			span.easeProps.push(easerFact(parent, prop, from, dest));
			switch(Type.typeof(checkVar)) {
				case TInt, TFloat: return from;
				default: return dest;
			}
		}
		
		switch(Type.typeof(checkVar)) {
			case TEnum(e):
				var destEnumVal:EnumValue = cast dest;
				var fromEnumVal:EnumValue = cast from;
				var fromType = Type.getEnum(fromEnumVal);
				var destType = Type.getEnum(destEnumVal);
				if (fromType == destType) {
					var destParams = Type.enumParameters(destEnumVal);
					var fromParams = Type.enumParameters(fromEnumVal);
					
					for (styleSwitch in styleSwitches) {
						switch(styleSwitch) {
							//case AnyEnumValueSwitch(toType, goVia, paramsTypes, toStylePropCheck):
							
							case EnumValueSwitch(switchFact, style1, style2, check):
								var style1Type = Type.getEnum(style1);
								var style2Type = Type.getEnum(style2);
								
								
								var style1Match:Dynamic;
								var style2Match:Dynamic;
								var params1:Array<Dynamic>;
								var params2:Array<Dynamic>;
								var direction:Bool;
								if (style1Type == fromType && enumConstMatch(style1,fromEnumVal) && style2Type==destType && enumConstMatch(style2,destEnumVal)) {
									style1Match = from;
									style2Match = dest;
									params1 = fromParams;
									params2 = destParams;
									direction = true;
								}else if (style1Type == destType && enumConstMatch(style1,destEnumVal) && style2Type == fromType && enumConstMatch(style2,fromEnumVal)) {
									style1Match = dest;
									style2Match = from;
									params1 = destParams;
									params2 = fromParams;
									direction = false;
								}else {
									continue;
								}
								if (check!=null && !check(style1Match,params1,style2Match,params2)) break;
								
								var switchInfoList = direction?switchFact(bundle.subject, direction,style1, style1Match, style2, style2Match):switchFact(bundle.subject, direction, style2, style2Match, style1, style1Match);
								return doSwitch(bundle, span, switchInfoList,  style1Match, style2Match, direction, parent, prop);
								
							case EnumTypeSwitch(switchFact, enum1, enum2, check):
								
								var style1Match:Dynamic;
								var style2Match:Dynamic;
								var params1:Array<Dynamic>;
								var params2:Array<Dynamic>;
								var direction:Bool;
								if (enum1 == fromType && enum2==destType) {
									style1Match = from;
									style2Match = dest;
									params1 = fromParams;
									params2 = destParams;
									direction = true;
								}else if (enum1 == destType && enum2 == fromType) {
									style1Match = dest;
									style2Match = from;
									params1 = destParams;
									params2 = fromParams;
									direction = false;
								}else {
									continue;
								}
								if (check!=null && !check(style1Match,params1,style2Match,params2)) continue;
								
								var switchInfoList = direction?switchFact(bundle.subject, direction,enum1, style1Match, enum2, style2Match):switchFact(bundle.subject, direction, enum1, style2Match, enum2, style1Match);
								return doSwitch(bundle, span, switchInfoList,  style1Match, style2Match, direction, parent, prop);
						}
					}
					if(enumConstMatch(destEnumVal,fromEnumVal)){
						for (i in 0 ... destParams.length) {
							checkSpan(bundle, span, destParams, i, fromParams[i], destParams[i], findEaserFact(dest,i));
						}
					}
				}
				return destEnumVal;
			case TObject:
				if (Std.is(dest, Array)) {
					var fromArray:Array<Dynamic> = cast from;
					var destArray:Array<Dynamic> = cast dest;
					for(i in 0 ... destArray.length ){
						checkSpan(bundle, span, destArray, i, fromArray[i], destArray[i]);
					}
				}else{ 
					for( i in Reflect.fields(dest) ){
						checkSpan(bundle, span, dest, i, Reflect.getProperty(from,i), Reflect.getProperty(dest,i));
					}
				}
			case TClass(type):
				if (Std.is(dest, Array)) {
					var fromArray:Array<Dynamic> = cast from;
					var destArray:Array<Dynamic> = cast dest;
					for(i in 0 ... destArray.length ){
						checkSpan(bundle, span, destArray, i, fromArray[i], destArray[i]);
					}
				}else{ 
					for( i in Reflect.fields(dest) ){
						checkSpan(bundle, span, dest, i, Reflect.getProperty(from,i), Reflect.getProperty(dest,i));
					}
				}
			case TInt, TFloat:
				if (prop != null) {
					if (parent == null && prop==null) {
						parent = bundle;
						prop = "curr";
					}
					if (dest == null) dest = 0;
					if (from == null) from = 0;
					
					if(from!=dest){
						if (span.easeProps == null) span.easeProps = [];
						if (easerFact == null) easerFact = PropEaser.getNew;
						span.easeProps.push(easerFact(parent, prop, from, dest));
					}
				}
				return from;
			default:
		}
		return dest;
	}
	private function enumConstMatch(enum1:EnumValue, enum2:EnumValue ):Bool {
		return Type.enumIndex(enum1) == Type.enumIndex(enum2);
	}
	
	private function doSwitch(bundle:TransTracker, span:TransSpan, switchInfoList:Array<SwitchSpanInfo>, style1Match:Dynamic, style2Match:Dynamic, direction:Bool, parent:Dynamic, prop:Dynamic):Dynamic {
		
		if (switchInfoList.length > 1) {
			var spanLength = span.length / switchInfoList.length;
			for (i in 0 ... switchInfoList.length) {
				var switchInfo = switchInfoList[i];
				
				var childSpan:TransSpan = TransSpan.getNew();
				childSpan.start = spanLength*i;
				childSpan.length = spanLength;
				bundle.transSpans.push(childSpan);
				
				if(prop!=null){
					if(i==0){
						UtilFunctions.setProperty(parent, prop, switchInfo.via);
					}else {
						childSpan.easeProps = [PropSetter.getNew(parent,prop,switchInfo.via)];
					}
				}
				doSwitch2(bundle, childSpan, switchInfo.via, switchInfo.toParams, switchInfo.easerFuncs);
			}
			return switchInfoList[0].via;
		}else if (switchInfoList.length == 1) {
			var switchInfo = switchInfoList[0];
			if(prop!=null)UtilFunctions.setProperty(parent, prop, switchInfo.via);
			doSwitch2(bundle, span, switchInfo.via, switchInfo.toParams, switchInfo.easerFuncs);
			return switchInfo.via;
		}else {
			return direction?style1Match:style2Match;
		}
		
	}
	private function doSwitch2(bundle:TransTracker, span:TransSpan, via:Dynamic, destParams:Array<Dynamic>, easerFuncs:Array<EaserFactFunc>):Void {
	
		var viaParams:Array<Dynamic> = Type.enumParameters(via);
		for (i in 0 ... destParams.length) {
			var easerFact:EaserFactFunc;
			if (easerFuncs != null) easerFact = easerFuncs[i];
			else easerFact = null;
			if (easerFact == null) easerFact = findEaserFact(via, i);
			UtilFunctions.setProperty(viaParams, i, checkSpan(bundle, span, viaParams, i, viaParams[i], destParams[i], easerFact));
		}
	}
	public static function ease(paramsTypes:Array<SwitchParamType>):EnumValSwitchFact {
		return function(subject:Dynamic, direction:Bool, style1:Dynamic, style1Match:Dynamic, style2:Dynamic, style2Match:Dynamic):Array<SwitchSpanInfo> {
			return [createSwitchInfo(paramsTypes, direction, style1,style1Match,style2,style2Match)];
		}
	}
	public static function goVia(paramsTypes:Array<SwitchParamType>):EnumValSwitchFact {
		return function(subject:Dynamic, direction:Bool, style1:Dynamic, style1Match:Dynamic, style2:Dynamic, style2Match:Dynamic):Array<SwitchSpanInfo> {
			var ret:Array<SwitchSpanInfo> = [];
			if (direction) {
				ret.push(createSwitchInfo(paramsTypes, true, style1,style1Match,style2,style2Match));
				ret.push(createSwitchInfo(paramsTypes, false, style2,style2Match,style1,style1Match));
			}else {
				ret.push(createSwitchInfo(paramsTypes, true, style2,style2Match,style1,style1Match));
				ret.push(createSwitchInfo(paramsTypes, false, style1,style1Match,style2,style2Match));
			}
			return ret;
		}
	}
	private static function createSwitchInfo(paramsTypes:Array<SwitchParamType>, direction:Bool, style1:Dynamic, style1Match:Dynamic, style2:Dynamic, style2Match:Dynamic):SwitchSpanInfo {
	
		var destParams:Array<Dynamic> = [];
		var easers:Array<EaserFactFunc> = [];
		var via:Dynamic = Clone.clone(style1);
		var ret = { via:via, toParams:destParams, easerFuncs:easers};
		var viaParams:Array<Dynamic> = Type.enumParameters(via);
		
		var params = Type.enumParameters(style1Match);
		var otherParams = Type.enumParameters(style2Match);
		
		for (i in 0 ... paramsTypes.length) {
			switch(paramsTypes[i]) {
				case UseStyle:
					viaParams[i] = params[i];
				case NormalEase(easerFact):
					easers[i] = easerFact;
					if(direction){
						viaParams[i] = params[i];
						destParams[i] = otherParams[i];
						//checkSpan(bundle, span, viaParams, i, viaParams[i], otherParams[i], easerFact);
					}else {
						viaParams[i] = otherParams[i];
						destParams[i] = params[i];
						//checkSpan(bundle, span, viaParams, i, viaParams[i], params[i], easerFact);
					}
				case SwitchEase(easerFact):
					easers[i] = easerFact;
					if(direction){
						destParams[i] = viaParams[i];
						viaParams[i] = params[i];
						//checkSpan(bundle, span, viaParams, i, viaParams[i], was, easerFact);
					}else {
						destParams[i] = params[i];
						//checkSpan(bundle, span, viaParams, i, viaParams[i], params[i], easerFact);
					}
			}
		}
		return ret;
	}
	
	private function findEaserFact(enumVal:Dynamic, paramIndex:Int):EaserFactFunc {
		var enumType = Type.getEnum(enumVal);
		var enumConstIndex:Int = Type.enumIndex(enumVal);
		if(propEasers!=null){
			for (easerInfo in propEasers) {
				if (Type.getEnum(easerInfo.styleType) == enumType && Type.enumIndex(easerInfo.styleType)==enumConstIndex && easerInfo.paramIndex == paramIndex) {
					return easerInfo.propEaserFact;
				}
			}
		}
		return null;
	}
	
	private function transFinished(from:TransTracker):Void {
		from.release();
	}
}


enum Easing {
	EaseInOut;
	EaseIn;
	EaseOut;
}
private class TransTracker implements ITransTracker {
	private static var _pool:Array<TransTracker>;
	public static function getNew(stopHandler:TransTracker->Void):TransTracker {
		if (_pool == null) {
			_pool = [];
			return new TransTracker(stopHandler);
		}else if (_pool.length>0) {
			var ret = _pool.pop();
			ret.stopHandler = stopHandler;
			return ret;
		}else {
			return new TransTracker(stopHandler);
		}
	}
	public function release():Void {
		if (transSpans != null) {
			for (span in transSpans) {
				span.release();
			}
			transSpans = null;
		}
		update = null;
		finish = null;
		to = null;
		curr = null;
		transStyle = null;
		fract = 0;
		transStyle = null;
		subject = null;
		_pool.push(this);
	}
	
	
	public dynamic function update(curr:Dynamic):Void{}
	public dynamic function finish(curr:Dynamic):Void{}
	
	private var stopHandler:TransTracker->Void;
	
	public var to:Dynamic;
	public var from:Dynamic;
	public var curr:Dynamic;
	
	public var subject:Dynamic;
	
	public var transStyle:TransStyle;
	
	public var transSpans:Array<TransSpan>;
	
	private var _tween:Tween;
	
	public function new(stopHandler:TransTracker->Void) {
		this.stopHandler = stopHandler;
	}
	
	public function stopTrans(gotoEnd:Bool):Void {
		//com.eclecticdesignstudio.motion.Actuate.stop(this);
		if (_tween != null) {
			_tween.stop();
			_tween = null;
		}
		if (gotoEnd) fract = 1;
		else stopHandler(this);
	}
	
	public function setUpdateHandler(handler:Dynamic->Void):Void {
		update = handler;
	}
	public function setFinishHandler(handler:Dynamic->Void):Void {
		finish = handler;
	}
	
	public var fract(default, set_fract):Float;
	private function set_fract(value:Float):Float {
		fract = value;
		if (transSpans == null) return value;
		
		for (span in transSpans) {
			if (fract > span.start && fract < span.start + span.length) {
				var spanFract:Float = (fract-span.start)/span.length;
				if (span.easeProps != null) {
					for (ease in span.easeProps) {
						ease.update(spanFract);
					}
				}
			}
		}
		update(curr);
		
		if (fract == 1) {
			finish(to);
			stopHandler(this);
		}
		
		return value;
	}
	public function tweenFract(to:Float, time:Float, easing):Void {
		//com.eclecticdesignstudio.motion.Actuate.tween(this,time,{fract:1}).ease(easing);
		
		if (_tween != null) {
			_tween.stop();
			_tween = null;
		}
		_tween = new Tween(fract, to, Std.int(time * 1000), easing, onUpdate, onComplete, true);
	}
	private function onUpdate(fract:Float):Void {
		trace("ye: "+fract);
		this.fract = fract;
	}
	private function onComplete():Void {
		_tween = null;
	}
}
private class TransSpan {
	private static var _pool:Array<TransSpan>;
	public static function getNew():TransSpan {
		if (_pool == null) {
			_pool = [];
			return new TransSpan();
		}else if (_pool.length>0) {
			return _pool.pop();
		}else {
			return new TransSpan();
		}
	}
	public function release():Void {
		if (easeProps != null) {
			for (prop in easeProps) {
				prop.release();
			}
			easeProps = null;
		}
		_pool.push(this);
	}
	
	public var start:Float; // in fract
	public var length:Float; // in fract
	
	public var easeProps:Array<IPropEaser>;
	
	public function new() { }
}
private class PropEaserInfo {
	public var styleType:Dynamic;
	public var paramIndex:Int;
	public var propEaserFact:EaserFactFunc;
	
	public function new(styleType:Dynamic, paramIndex:Int, propEaserFact:EaserFactFunc) {
		this.styleType = styleType;
		this.paramIndex = paramIndex;
		this.propEaserFact = propEaserFact;
	}
}

// handler(subject:Dynamic, prop:Dynamic, start:Int, end:Int):Bool
typedef EaserFactFunc = Dynamic->Dynamic->Dynamic->Dynamic->IPropEaser;

// handler(style1:Dynamic,style2:Dynamic):Bool
typedef SwitchCheck = Dynamic->Array<Dynamic>->Dynamic->Array<Dynamic>->Bool;

typedef SwitchSpanInfo = { via:Dynamic, toParams:Array<Dynamic>, easerFuncs:Array<EaserFactFunc> };
// handler(subject:Dynamic, direction:Bool, style1:Dynmaic, style1Match:Dynamic, style2:Dynmaic, style2Match:Dynamic)
typedef EnumValSwitchFact = Dynamic->Bool->Dynamic->Dynamic->Dynamic->Dynamic->Array<SwitchSpanInfo>;

// handler(subject:Dynamic, direction:Bool, enum1:Dynamic, enum1Match:Dynamic, enum2:Dynmaic, enum2Match:Dynamic)
typedef EnumSwitchFact = Dynamic->Bool->Enum<Dynamic>->Dynamic->Enum<Dynamic>->Dynamic->Array<SwitchSpanInfo>;

// handler(style1:Dynmaic, style1Match:Dynamic, style2:Dynmaic, style2Match:Dynamic)
//typedef EaseStyleViaFact = Dynamic->Dynamic->Dynamic->Dynamic->{ via1:Dynamic, toParams1:Array<Dynamic>, easerFuncs1:Array<EaserFactFunc>, via2:Dynamic, toParams2:Array<Dynamic>, easerFuncs2:Array<EaserFactFunc> };

enum StyleSwitch {
	EnumValueSwitch(switchFact:EnumValSwitchFact, enumVal1:Dynamic, enumVal2:Dynamic, ?check:SwitchCheck);
	EnumTypeSwitch(switchFact:EnumSwitchFact, enum1:Enum<Dynamic>, enum2:Enum<Dynamic>, ?check:SwitchCheck);
}
/*enum SwitchType {
	Ease(switchFact:EaseStyleFact);
	EaseVia(switchFact:EaseStyleViaFact);
}*/
enum SwitchParamType {
	UseStyle;
	NormalEase(?easerFact:EaserFactFunc);
	SwitchEase(?easerFact:EaserFactFunc);
}



