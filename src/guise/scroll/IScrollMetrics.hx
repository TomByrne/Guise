package guise.scroll;

import msignal.Signal;

interface IScrollMetrics<T:IScrollMetrics<T>> {
	
	public var scrollChanged(get_scrollChanged, null):Signal1<T>;
	
	public var min(get_min, null):Float;
	public var max(get_max, null):Float;
	public var pageSize(get_pageSize, null):Float;
	public var scroll(get_scroll, set_scroll):Float;
	
	public var validScrollNorm(get_validScrollNorm, null):Float;
	public var validPageSizeNorm(get_validPageSizeNorm, null):Float;
}
interface IHScrollMetrics implements IScrollMetrics<IHScrollMetrics>{
	
}
interface IVScrollMetrics implements IScrollMetrics<IVScrollMetrics>{
	
}

// default implementation
@:build(LazyInst.check())
class ScrollMetrics<T:IScrollMetrics<T>> implements IScrollMetrics<T>{
	
	@lazyInst public var scrollChanged:Signal1<T>;
	
	@change("scrollChanged")
	@:isVar public var min(get_min, null):Float;
	private function get_min():Float {
		return this.min;
	}
	
	@change("scrollChanged")
	@:isVar public var max(get_max, null):Float;
	private function get_max():Float {
		return this.max;
	}
	
	@change("scrollChanged")
	@:isVar public var pageSize(get_pageSize, null):Float;
	private function get_pageSize():Float {
		return this.pageSize;
	}
	
	@change("scrollChanged")
	@:isVar public var scroll(get_scroll, set_scroll):Float;
	private function get_scroll():Float {
		return this.scroll;
	}
	
	@change("scrollChanged")
	public var validScrollNorm(get_validScrollNorm, set_validScrollNorm):Float;
	private function get_validScrollNorm():Float {
		var val = this.scroll;
		if (val < min) {
			val = min;
		}else if (val > max) {
			val = max;
		}
		return val/(this.max-this.min-this.pageSize);
	}
	private function set_validScrollNorm(value:Float):Float {
		set_scroll(value * (this.max - this.min - this.pageSize));
		return value;
	}
	
	@change("scrollChanged")
	public var validPageSizeNorm(get_validPageSizeNorm, null):Float;
	private function get_validPageSizeNorm():Float {
		var val = this.pageSize+this.scroll;
		if (val < min) {
			val = min;
		}else if (val > max) {
			val = max;
		}
		return (val-this.scroll)/(this.max-this.min);
	}
	
	private function set_scroll(value:Float):Float {
		if (!canScroll()) value = min;
		
		if (this.scroll == value) return value;
		
		this.scroll = value;
		LazyInst.exec(scrollChanged.dispatch(untyped this));
		
		return value;
	}
	
	
	
	
	public function new(max:Float = 1, scroll:Float = 0, min:Float = 0) {
		this.min = min;
		this.max = max;
		this.scroll = scroll;
	}
	
	public function setRange(max:Float, min:Float = 0):Void {
		if (this.min == min && this.max == max) return;
		
		this.min = min;
		this.max = max;
		LazyInst.exec(scrollChanged.dispatch(untyped this));
	}
	
	public function setPageSize(value:Float):Void {
		if (this.pageSize == value) return;
		
		this.pageSize = value;
		LazyInst.exec(scrollChanged.dispatch(untyped this));
	}
	
	private function canScroll():Bool {
		return (max-min>pageSize);
	}
}
class HScrollMetrics extends ScrollMetrics<IHScrollMetrics>, implements IHScrollMetrics {

	public function new(max:Float = 1, scroll:Float = 0, min:Float = 0) {
		super(max, scroll, min);
	}
}
class VScrollMetrics extends ScrollMetrics<IVScrollMetrics>, implements IVScrollMetrics {

	public function new( max:Float = 1, scroll:Float = 0, min:Float = 0) {
		super( max, scroll, min);
	}
}