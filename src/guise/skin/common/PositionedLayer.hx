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
	
	public var normalLayout(get_normalLayout, set_normalLayout):Layout;
	private function get_normalLayout():Layout {
		return _layoutStyler.normalStyle;
	}
	private function set_normalLayout(value:Layout):Layout {
		return (_layoutStyler.normalStyle = value);
	}
	
	private var _layoutStyler:StateStyledTrait<Layout>;
	
	public var x:Float;
	public var y:Float;
	public var w:Float;
	public var h:Float;
	
	public var layerName:String;

	public function new(layerName:String, ?normalStyle:StyleType) 
	{
		super(normalStyle);
		this.layerName = layerName;
		
		_layoutStyler = new StateStyledTrait(null, _isReadyToDraw, doLayoutDraw);
		_layoutStyler.normalStyle = Layout.edge(new Value(0), new Value(0), new Width(), new Height());
		addSiblingTrait(_layoutStyler);
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
		var layout:Layout = _layoutStyler.currentStyle;
		switch(layout) {
			case edge(l, t, r, b):
				this.x = getValue(l, 0);
				this.y = getValue(t, 0);
				this.w = getValue(r, 0) - this.x;
				this.h = getValue(b, 0) - this.y;
			case size(x, y, w, h):
				this.x = getValue(x, 0);
				this.y = getValue(y, 0);
				this.w = getValue(w, 0);
				this.h = getValue(h, 0);
			
		}
		super.invalidate();
	}
	
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