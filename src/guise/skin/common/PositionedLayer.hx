package guise.skin.common;


#if macro
import guise.macro.ValueMacro;
import haxe.macro.Expr;
import haxe.macro.Context;
#else
import guise.layout.IBoxPos;
import guise.skin.values.Height;
import guise.skin.values.IValue;
import guise.skin.values.Value;
import guise.skin.values.Width;
import guise.trans.ITransitioner;
import guise.states.StateStyledTrait;
#end

class PositionedLayer<StyleType>
#if !macro
extends StateStyledTrait<StyleType>
#end
{
	#if !macro
	
	public var normalLayout(get, set):Layout;
	private function get_normalLayout():Layout {
		return _layoutStyler.normalStyle;
	}
	private function set_normalLayout(value:Layout):Layout {
		return (_layoutStyler.normalStyle = value);
	}
	
	override private function set_injStyleTransitioner(value:ITransitioner):ITransitioner {
		_layoutStyler.injStyleTransitioner = value;
		return super.set_injStyleTransitioner(value);
	}
	override private function set_styleTransitioner(value:ITransitioner):ITransitioner {
		_layoutStyler.styleTransitioner = value;
		return super.set_styleTransitioner(value);
	}
	
	private var _layoutStyler:StateStyledTrait<Layout>;
	
	public var x:Float;
	public var y:Float;
	public var w:Float;
	public var h:Float;
	
	@:isVar public var layerName(default, set):String;
	private function set_layerName(value:String):String {
		this.layerName = value;
		return value;
	}

	public function new(layerName:String, ?normalStyle:StyleType) 
	{
		super(normalStyle);
		this.layerName = layerName;
		
		_layoutStyler = new StateStyledTrait(null, isPosReadyToDraw, doLayoutDraw);
		_layoutStyler.normalStyle = Layout.edge(new Value(0), new Value(0), new Width(), new Height());
		addSiblingTrait(_layoutStyler);
	}
	private function isPosReadyToDraw():Bool {
		return item!=null;
	}
	override private function onItemAdd():Void {
		super.onItemAdd();
		_layoutStyler.invalidate();
	}
	override private function assessStyle():Void {
		super.assessStyle();
		if (styleTransitioner != null) {
			currentTrans = styleTransitioner.doTrans(currentStyle, destStyle,transSubject,null, updateTrans, finishTrans);
		}else if (injStyleTransitioner != null) {
			currentTrans = injStyleTransitioner.doTrans(currentStyle, destStyle,transSubject,null, updateTrans, finishTrans);
		}
	}
	
	#end
	
	@:macro public function addLayout(thisE:Expr, states:Expr, left:Expr, top:Expr, right:Expr, bottom:Expr, ?priority:Int):Expr {
		left = ValueMacro.interpValue(left);
		top = ValueMacro.interpValue(top);
		right = ValueMacro.interpValue(right);
		bottom = ValueMacro.interpValue(bottom);
		if (priority != null) {
			var priorityE = Context.parse(Std.string(priority), Context.currentPos());
			return macro $thisE.addStateLayout($states, $left, $top, $right, $bottom, $priorityE);
		}else {
			return macro $thisE.addStateLayout($states, $left, $top, $right, $bottom);
		}
	}
	
	#if !macro
	public function addStateLayout(states:Array<EnumValue>, left:IValue, top:IValue, right:IValue, bottom:IValue, priority:Int = 0):Void {
		var layout = Layout.size(left, top, right, bottom);
		if (states == null) {
			normalLayout = layout;
		}else {
			_layoutStyler.addStyle(states, layout, priority);
		}
	}
	
	private function doLayoutDraw():Void {
		removeValuesByHandler(onLayoutValueChanged);
		
		var layout:Layout = _layoutStyler.currentStyle;
		var newX:Float;
		var newY:Float;
		var newW:Float;
		var newH:Float;
		switch(layout) {
			case edge(l, t, r, b):
				newX = getValue(l, 0, onLayoutValueChanged);
				newY = getValue(t, 0, onLayoutValueChanged);
				newW = getValue(r, 0, onLayoutValueChanged) - this.x;
				newH = getValue(b, 0, onLayoutValueChanged) - this.y;
			case size(x, y, w, h):
				newX = getValue(x, 0, onLayoutValueChanged);
				newY = getValue(y, 0, onLayoutValueChanged);
				newW = getValue(w, 0, onLayoutValueChanged);
				newH = getValue(h, 0, onLayoutValueChanged);
			
		}
		if (this.x != newX || this.y != newY || this.w != newW || this.h != newH) {
			this.x = newX;
			this.y = newY;
			this.w = newW;
			this.h = newH;
			layoutChanged();
		}
	}
	private function onLayoutValueChanged(?param1:Dynamic, ?param2:Dynamic):Void {
		_layoutStyler.invalidate();
	}
	
	private function layoutChanged():Void {
		super.invalidate();
	}
	
	// This shouldn't be here but it helps for the time being
	override public function invalidate():Void {
		super.invalidate();
		_layoutStyler.invalidate();
	}
	#end
}

#if !macro
enum Layout {
	edge(left:IValue, top:IValue, right:IValue, bottom:IValue);
	size(x:IValue, y:IValue, width:IValue, height:IValue);
}
#end