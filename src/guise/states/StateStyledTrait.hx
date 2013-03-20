package guise.states;
import composure.traits.AbstractTrait;
import guise.skin.values.ValueUtils;
import guise.utils.Clone;
import guise.skin.values.IValue;
import guise.trans.ITransitioner;

import Lambda;

using Lambda;

import msignal.Signal;

class StateStyledTrait<StyleType> extends AbstractTrait
{
	
	@inject({asc:true})
	@:isVar public var injStyleTransitioner(default, set):ITransitioner;
	private function set_injStyleTransitioner(value:ITransitioner):ITransitioner {
		this.injStyleTransitioner = value;
		return value;
	}
	
	@:isVar public var styleTransitioner(default, set):ITransitioner;
	private function set_styleTransitioner(value:ITransitioner):ITransitioner {
		this.styleTransitioner = value;
		return value;
	}
	
	
	@:isVar public var normalStyle(default, set):StyleType;
	private function set_normalStyle(value:StyleType):StyleType {
		normalStyle = value;
		assessStyle();
		return value;
	}
	
	private var currentTrans:ITransTracker;
	
	@:isVar public var currentStyle(default, null):StyleType;
	@:isVar public var previousStyle(default, null):StyleType;
	@:isVar public var destStyle(default, null):StyleType;
	
	private var styles:Array<{states:Array<String>,style:StyleType, priority:Int}>;
	private var states:Array<IState<EnumValue>>;
	private var _handlerToSignals:Map<String, Dynamic->Dynamic->Void, Array<AnySignal>>;
	
	private var transSubject:Dynamic;

	public function new(?normalStyle:StyleType, ?isReadyToDraw:Void->Bool, ?drawStyle:Void->Void, ?transSubject:Dynamic) 
	{
		super();
		this.normalStyle = normalStyle;
		if(isReadyToDraw!=null)this.isReadyToDraw = isReadyToDraw;
		if (drawStyle != null) this.drawStyle = drawStyle;
		if (transSubject != null) this.transSubject = transSubject;
		else this.transSubject = this;
		
		_handlerToSignals = new Map();
	}
	
	@injectAdd
	public function addState(state:IState<EnumValue>):Void {
		if (states == null) states = [];
		
		state.stateChanged.add(onStateChanged);
		states.push(state);
		assessStyle();
	}
	@injectRemove
	public function removeState(state:IState<EnumValue>):Void {
		state.stateChanged.remove(onStateChanged);
		states.remove(state);
		assessStyle();
	}
	private function onStateChanged(state:IState<EnumValue>):Void {
		assessStyle();
	}
	
	public function addStyle(states:Array<EnumValue>, style:StyleType, priority:Int = 0):Void {
		if (states == null || states.length == 0) {
			normalStyle = style;
			return;
		}
		if (styles == null) styles = [];
		
		var stateStrs = [];
		for (state in states) {
			stateStrs.push(getStateKey(state));
		}
		styles.push({states:stateStrs, style:style, priority:priority});
		
		assessStyle();
	}
	public function removeStyle(style:StyleType):Void {
		for (styleInfo in styles) {
			if (styleInfo.style == style) {
				styles.remove(styleInfo);
				return;
			}
		}
	}
	private function assessStyle():Void {
		destStyle = findDestStyle();
		
		if (previousStyle == null) {
			setCurrentStyle(Clone.clone(destStyle));
			previousStyle = destStyle;
			attemptDrawStyle();
		}else if (destStyle != previousStyle) {
			if (currentTrans != null) {
				currentTrans.stopTrans(false);
				currentTrans = null;
			}
			
			if (styleTransitioner != null) {
				currentTrans = styleTransitioner.doTrans(currentStyle, destStyle,transSubject,null, updateTrans, finishTrans);
			}else if (injStyleTransitioner != null) {
				currentTrans = injStyleTransitioner.doTrans(currentStyle, destStyle,transSubject,null, updateTrans, finishTrans);
			}else{
				//previousStyle = currentStyle;
				setCurrentStyle(destStyle);
				attemptDrawStyle();
			}
			previousStyle = destStyle;
		}
		
	}
	private function updateTrans(current:StyleType):Void {
		setCurrentStyle(current);
		attemptDrawStyle();
	}
	private function finishTrans(finish:StyleType):Void {
		currentTrans = null;
		setCurrentStyle(finish);
		attemptDrawStyle();
		previousStyle = finish;
	}
	private function setCurrentStyle(value:StyleType):Void {
		if (currentStyle == value) return;
		currentStyle = value;
	}
	private function getValue(value:IValue, def:Float, changeHandler:Dynamic->Dynamic->Void, doRemoveListeners:Bool):Float {
		if (value == null) return def;
		
		var signals:Array<AnySignal> = _handlerToSignals.get(changeHandler);
		if (signals == null) {
			signals = new Array<AnySignal>();
			_handlerToSignals.set(changeHandler, signals);
		}
		ValueUtils.update(value, item, signals, changeHandler, doRemoveListeners);
		return value.currentValue;
	}
	private function removeValuesByHandler(changeHandler:Dynamic->Dynamic->Void):Void {
		if (_handlerToSignals == null) return;
		
		var signals:Array<AnySignal> = _handlerToSignals.get(changeHandler);
		if (signals != null) {
			for (signal in signals) {
				signal.remove(changeHandler);
			}
			_handlerToSignals.delete(changeHandler);
		}
	}
	
	
	private function findDestStyle():StyleType {
		if (states == null || styles==null) return normalStyle;
		
		var stateKeys:Array<String> = [];
		for (state in states) {
			var curr = state.current;
			if (curr != null) {
				stateKeys.push(getStateKey(curr));
			}
		}
		var styles:Array<{states:Array<String>, style:StyleType, priority:Int}> = this.styles.concat([]);
		var i = 0;
		while (i < styles.length) {
			var styleInfo = styles[i];
			for(state in styleInfo.states){
				if (Lambda.indexOf(stateKeys, state) == -1) {
					styles.splice(i, 1);
					--i;
					break;
				}
			}
			++i;
		}
		if (styles.length>0) {
			styles.sort(sortStyles);
			return styles[0].style;
		}else{
			return normalStyle;
		}
	}
	private function sortStyles(style1:{states:Array<String>, style:StyleType, priority:Int}, style2:{states:Array<String>, style:StyleType, priority:Int}):Int{
		if (style1.priority > style2.priority) {
			return -1;
		}else if (style1.priority < style2.priority) {
			return 1;
		}else {
			return 0;
		}
	}
	public function invalidate():Void {
		// should add invalidation loop here
		attemptDrawStyle();
	}
	private function attemptDrawStyle():Void {
		if (isReadyToDraw()) {
			if (currentStyle != null) drawStyle();
			else clearStyle();
		}
	}
	private function getStateKey(state:EnumValue):String {
		return Type.getEnumName(Type.getEnum(state)) + "." + Type.enumConstructor(state);
	}
	
	
	/**
	 * Overriding dynamic functions disallows calling the 
	 * super version of the function. By using the _methods
	 * you can super call like normal.
	 */
	private dynamic function isReadyToDraw():Bool {
		// override
		return _isReadyToDraw();
	}
	private dynamic function drawStyle():Void {
		_drawStyle();
	}
	private dynamic function clearStyle():Void {
		_clearStyle();
	}
	
	private function _isReadyToDraw():Bool {
		// override
		return true;
	}
	private function _drawStyle():Void {
		// override
	}
	private function _clearStyle():Void {
		// override
	}
	
}