package guise.states;
import composure.traits.AbstractTrait;
import guise.utils.Clone;
import guiseSkins.styled.values.IValue;
import guiseSkins.trans.ITransitioner;
import cmtc.ds.hash.ObjectHash;

import msignal.Signal;
/**
 * ...
 * @author Tom Byrne
 */

class StateStyledTrait<StyleType> extends AbstractTrait
{
	
	@inject({asc:true})
	public var injStyleTransitioner:ITransitioner;
	
	public var styleTransitioner:ITransitioner;
	
	
	public var normalStyle(default, set_normalStyle):StyleType;
	private function set_normalStyle(value:StyleType):StyleType {
		normalStyle = value;
		assessStyle();
		return value;
	}
	
	private var currentTrans:ITransTracker;
	
	public var currentStyle(default, null):StyleType;
	public var previousStyle(default, null):StyleType;
	public var destStyle(default, null):StyleType;
	
	private var styles:Array<{states:Array<String>,style:StyleType, priority:Int}>;
	private var states:Array<IState<EnumValue>>;
	private var values:Array<IValue>;
	//private var _values:Array<IValue>;
	private var _valueToSignals:ObjectHash<IValue, Array<AnySignal>>;
	
	private var transSubject:Dynamic;

	public function new(?normalStyle:StyleType, ?isReadyToDraw:Void->Bool, ?drawStyle:Void->Void, ?transSubject:Dynamic) 
	{
		super();
		this.normalStyle = normalStyle;
		if(isReadyToDraw!=null)this.isReadyToDraw = isReadyToDraw;
		if (drawStyle != null) this.drawStyle = drawStyle;
		if (transSubject != null) this.transSubject = transSubject;
		else this.transSubject = this;
		
		_valueToSignals = new ObjectHash();
		//_values = new Array();
	}
	/*override private function onItemRemove():Void{
		for (value in _values) {
			deactivateValue(value);
		}
	}
	override private function onItemAdd():Void{
		for (value in _values) {
			activateValue(value);
		}
	}*/
	
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
	
	public function addStyle(states:Array<EnumValue>, style:StyleType, priority:Int=0):Void {
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
		if (currentStyle == null) {
			if (normalStyle == null) return;
			setCurrentStyle(Clone.clone(normalStyle));
			previousStyle = normalStyle;
			attemptDrawStyle();
		}else {
			destStyle = findDestStyle();
			if (destStyle != previousStyle) {
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
		if (currentStyle != null) {
			for (value in values) {
				removeValue(value);
			}
			values = null;
		}
		currentStyle = value;
		if (currentStyle!=null) {
			values = [];
			findValues(currentStyle, values);
			/*for (value in values) {
				addValue(value);
			}*/
		}
	}
	private function findValues(within:Dynamic, addTo:Array<IValue>):Void {
		if (Std.is(within, IValue)) {
			addTo.push(cast within);
		}else{
			switch(Type.typeof(within)) {
				case TEnum(e):
					var params:Array<Dynamic> = Type.enumParameters(cast within);
					for (param in params) {
						findValues(param, addTo);
					}
				case TObject:
					var fields = Reflect.fields(within);
					for ( ff in fields ) {
						findValues(Reflect.field(within, ff), addTo);
					}
				case TClass(c):
					if (Std.is(within, Array)) {
						untyped { 
							for( ii in 0...within.length ) 
								findValues(within[ii], addTo); 
						}
					}else{
						var type = Type.getClass(within);
						var fields = Type.getInstanceFields(type);
						for ( ff in fields ) {
							findValues(Reflect.field(within, ff), addTo);
						}
					}
				default:
					// ignore 
			}
		}
	}
	
	/*private function addValue(value:IValue):Void {
		_values.push(value);
		if (item!=null) {
			activateValue(value);
		}
	}
	private function removeValue(value:IValue):Void {
		_values.remove(value);
		if (item!=null) {
			deactivateValue(value);
		}
	}*/
	
	/*private function activateValue(value:IValue):Void {
		var signals:Array<AnySignal> = value.activate(item);
		if (signals != null) {
			for (signal in signals) {
				signal.add(onValueChanged);
			}
			_valueToSignals.set(value, signals);
		}
	}
	private function deactivateValue(value:IValue):Void {
		var signals:Array<AnySignal> = _valueToSignals.get(value);
		if (signals != null) {
			for (signal in signals) {
				signal.remove(onValueChanged);
			}
			_valueToSignals.delete(value);
		}
	}*/
	private function getValue(value:IValue):Float {
		var signals:Array<AnySignal> = _valueToSignals.get(value);
		var newSignals:Array<AnySignal> = value.update(item);
		
		if (signals != null || newSignals != null) {
			if (signals == null) {
				for (signal in newSignals) {
					signal.add(onValueChanged);
				}
				_valueToSignals.set(value, signals);
			}else if (newSignals == null) {
				for (signal in signals) {
					signal.remove(onValueChanged);
				}
				_valueToSignals.delete(value);
			}else {
				var i:Int = 0;
				while (i < signals.length) {
					var signal = signals[i];
					if (!Lambda.has(newSignals, signal)) {
						signal.remove(onValueChanged);
						signals.remove(signal);
					}else {
						++i;
					}
				}
				for (signal in newSignals) {
					if (!Lambda.has(signals, signal)) {
						signals.push(signal);
						signal.add(onValueChanged);
					}
				}
			}
		}
		return value.currentValue;
	}
	private function removeValue(value:IValue):Void {
		var signals:Array<AnySignal> = _valueToSignals.get(value);
		if (signals != null) {
			for (signal in signals) {
				signal.remove(onValueChanged);
			}
			_valueToSignals.delete(value);
		}
	}
	private function onValueChanged(?param1:Dynamic, ?param2:Dynamic):Void {
		invalidate();
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

		if (currentStyle != null && isReadyToDraw()) {
			/*for (value in values) {
				value.update(item);
			}*/
			drawStyle();
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
	
	private function _isReadyToDraw():Bool {
		// override
		return true;
	}
	private function _drawStyle():Void {
		// override
	}
	
}