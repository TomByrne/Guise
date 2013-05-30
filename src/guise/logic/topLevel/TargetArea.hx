package guise.logic.topLevel;

import msignal.Signal;

@:build(LazyInst.check())
class TargetArea
{
	@lazyInst
	public var changed:Signal1<TargetArea>;
	
	@lazyInst
	public var posChanged:Signal1<TargetArea>;
	
	@lazyInst
	public var sizeChanged:Signal1<TargetArea>;
	
	@lazyInst
	public var focusChanged:Signal1<TargetArea>;
	
	@change("posChanged")
	public var x(default, null):Float;
	@change("posChanged")
	public var y(default, null):Float;
	@change("sizeChanged")
	public var w(default, null):Float;
	@change("sizeChanged")
	public var h(default, null):Float;
	
	@change("focusChanged")
	public var focusX(default, null):Float;
	@change("focusChanged")
	public var focusY(default, null):Float;

	public function new(x:Float=0, y:Float=0, ?width:Null<Float>, ?height:Null<Float>) 
	{
		setPos(x, y);
		if(width!=null && height!=null)setSize(width, height);
	}
	
	public function setPos(x:Float, y:Float):Void {
		if (this.x != x || this.y != y) {
			this.x = x;
			this.y = y;
			LazyInst.exec(posChanged.dispatch(this));
			LazyInst.exec(changed.dispatch(this));
		}
	}
	public function setSize(width:Float, height:Float):Void {
		if (this.w != width || this.h != height) {
			this.w = width;
			this.h = height;
			LazyInst.exec(sizeChanged.dispatch(this));
			LazyInst.exec(changed.dispatch(this));
		}
	}
	public function set(x:Float, y:Float, width:Float, height:Float):Void {
		if (this.x != x || this.y != y || this.w != width || this.h != height) {
			this.x = x;
			this.y = y;
			this.w = width;
			this.h = height;
			LazyInst.exec(posChanged.dispatch(this));
			LazyInst.exec(sizeChanged.dispatch(this));
			LazyInst.exec(changed.dispatch(this));
		}
	}
	
	public function setFocus(x:Float, y:Float):Void {
		if (this.focusX != x || this.focusY != y) {
			this.focusX = x;
			this.focusY = y;
			LazyInst.exec(focusChanged.dispatch(this));
		}
	}
}