package guise.logic.popout;


#if !macro
import composure.core.ComposeGroup;
import composure.core.ComposeItem;
import guise.ControlTags;
import guise.core.IWindowInfo;
import guise.data.IControlInfo;
import guise.layout.IBoxPos;
import guise.layout.SizeByMeas;
import guise.logic.topLevel.TargetArea;
import guise.logic.topLevel.TopLevelDisplay;
import guise.states.StateStyledTrait;
import guise.values.IValue;
import guise.states.State;
import guise.states.IState;
#else
import haxe.macro.Expr;
import haxe.macro.Context;
import guise.Macro;
#end

class AbsPopoutTrait
#if !macro
extends StateStyledTrait<PopoutPos>
#end
{
	
	@:macro public function setFocus(thisE:Expr, states:Expr, x:Expr, y:Expr, ?priority:Int):Expr {
		x = Macro.interpValue(x);
		y = Macro.interpValue(y);
		if (priority != null) {
			var priorityE = Context.parse(Std.string(priority), Context.currentPos());
			return macro $thisE.addFocus($states, $x, $y, $priorityE);
		}else {
			return macro $thisE.addFocus($states, $x, $y);
		}
	}
	
	#if !macro
	
	@inject({asc:true})
	@:isVar public var windowInfo(default, set_windowInfo):IWindowInfo;
	public function set_windowInfo(value:IWindowInfo):IWindowInfo {
		if (windowInfo != null) {
			windowInfo.availSizeChanged.remove(onAvailSizeChanged);
		}
		this.windowInfo = value;
		if (windowInfo != null) {
			windowInfo.availSizeChanged.add(onAvailSizeChanged);
			onAvailSizeChanged(windowInfo);
		}
		return value;
	}
	
	@inject @:isVar public var boxPos(default, set_boxPos):IBoxPos;
	private function set_boxPos(value:IBoxPos):IBoxPos {
		if (boxPos != null) {
			boxPos.changed.remove(onBoxPosChanged);
		}
		this.boxPos = value;
		if (boxPos != null) {
			boxPos.changed.add(onBoxPosChanged);
			onBoxPosChanged(boxPos);
		}
		return value;
	}
	
	private var popoutItem:ComposeGroup;
	private var popoutPos:BoxPos;
	private var targetArea:TargetArea;
	private var parentPositions:Array<IBoxPos>;
	private var parentOffsetX:Float;
	private var parentOffsetY:Float;
	private var _focusStyler:StateStyledTrait<FocusPos>;

	public function new(?type:ControlInfoType) 
	{
		super();
		
		_focusStyler = new StateStyledTrait<FocusPos>(null, isFocusReadyToDraw, doFocusDraw);
		addSiblingTrait(_focusStyler);
		
		popoutPos = new BoxPos();
		targetArea = new TargetArea();
		popoutItem = new ComposeGroup([popoutPos, targetArea, new State(type)]);
		
		addSiblingTrait(new TopLevelDisplay(popoutItem, true));
	}
	
	override private function addState(state:IState<EnumValue>):Void {
		popoutItem.addTrait(state);
		super.addState(state);
	}
	override private function removeState(state:IState<EnumValue>):Void {
		popoutItem.removeTrait(state);
		super.removeState(state);
	}
	
	private function onAvailSizeChanged(from:IWindowInfo):Void {
		invalidate();
	}
	override private function onItemAdd():Void {
		super.onItemAdd();
		
		parentPositions = [];
		var item = this.item;
		while (item!=null) {
			var boxPos:IBoxPos = item.getTrait(IBoxPos);
			if (boxPos != null) {
				parentPositions.push(boxPos);
				boxPos.changed.add(onParentChanged);
			}
			item = item.parentItem;
		}
		_focusStyler.invalidate();
	}
	override private function onItemRemove():Void {
		super.onItemRemove();
		
		for (boxPos in parentPositions) {
			boxPos.posChanged.remove(onParentChanged);
		}
		parentPositions = null;
	}
	
	private function onParentChanged(from:IBoxPos):Void {
		invalidate();
	}
	
	override private function _isReadyToDraw():Bool {
		return windowInfo!=null;
	}
	
	override private function _drawStyle():Void {
		removeValuesByHandler(onPosChanged);
		parentOffsetX = 0;
		parentOffsetY = 0;
		for (parPos in parentPositions) {
			parentOffsetX += parPos.x;
			parentOffsetY += parPos.y;
		}
		doPos(currentStyle, false);
	}
	private function doPos(style:PopoutPos, checkScreen:Bool):Bool {
		switch(style) {
			case pref(options):
				for (option in options) {
					if (doPos(option, true)) {
						return true;
					}
				}
				if (!checkScreen) {
					// if none fit, use first
					return doPos(options[0], false);
				}
				return false;
			case size(x, y, w, h):
				var x = getValue(x, 0, onPosChanged, false, popoutItem);
				var y = getValue(y, 0, onPosChanged, false, popoutItem);
				var w = getValue(w, 0, onPosChanged, false, popoutItem);
				var h = getValue(h, 0, onPosChanged, false, popoutItem);
				if (checkScreen) {
					if (parentOffsetX + x<0 || parentOffsetX+x+w>windowInfo.availWidth ||
						parentOffsetY + y < 0 || parentOffsetY + y + h > windowInfo.availHeight) {
							
						return false;
					}
				}
				
				popoutPos.set(x, y, w, h);
				return true;
		}
	}
	private function onPosChanged(?param1:Dynamic, ?param2:Dynamic):Void {
		invalidate();
	}
	public function addFocus(states:Array<EnumValue>, x:IValue, y:IValue, priority:Int = 0):Void {
		var posStyle = FocusPos.pos(x, y);
		if (states == null || states.length==0) {
			_focusStyler.normalStyle = posStyle;
		}else {
			_focusStyler.addStyle(states, posStyle, priority);
		}
	}
	private function onBoxPosChanged(from:IBoxPos):Void {
		targetArea.set(from.x, from.y, from.w, from.h);
	}
	
	
	// Focus functions
	private function isFocusReadyToDraw():Bool {
		return item!=null;
	}
	private function doFocusDraw():Void {
		removeValuesByHandler(onFocusValueChanged);
		switch(_focusStyler.currentStyle) {
			case pos(x, y):
				targetArea.setFocus(getValue(x, 0, onFocusValueChanged, false), getValue(y, 0, onFocusValueChanged, false));
			
		}
	}
	private function onFocusValueChanged(?param1:Dynamic, ?param2:Dynamic):Void {
		_focusStyler.invalidate();
	}
	
	
	#end
}

#if !macro
enum PopoutPos {
	size(x:IValue, y:IValue, w:IValue, h:IValue);
	pref(options:Array<PopoutPos>);
}
enum FocusPos {
	pos(x:IValue, y:IValue);
}
#end