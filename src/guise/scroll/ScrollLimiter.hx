package guise.scroll;

import composure.traits.AbstractTrait;
import guise.scroll.IScrollMetrics;

class ScrollLimiter extends AbstractTrait
{
	public var overshoot(default, set_overshoot):Float;
	@:isVar private function set_overshoot(value:Float):Float {
		this.overshoot = value;
		checkAllScrollMetrics();
		return value;
	}
	
	public var scrollDir(default, set_scrollDir):ScrollDir;
	@:isVar private function set_scrollDir(value:ScrollDir):ScrollDir {
		this.scrollDir = value;
		checkAllScrollMetrics();
		return value;
	}
	
	private var _scrollMetrics:Array<IScrollMetrics<Dynamic>>;

	public function new(overshoot:Float = 0, ?scrollDir:ScrollDir) {
		super();
		_scrollMetrics = new Array<IScrollMetrics<Dynamic>>();
		this.scrollDir = scrollDir==null?Both:scrollDir;
		this.overshoot = overshoot;
	}
	
	@injectAdd
	private function addScrollMetrics(scrollMetrics:IScrollMetrics<Dynamic>):Void {
		scrollMetrics.scrollChanged.add(checkScrollMetrics);
		_scrollMetrics.push(scrollMetrics);
		checkScrollMetrics(scrollMetrics);
	}
	@injectRemove
	private function removeScrollMetrics(scrollMetrics:IScrollMetrics<Dynamic>):Void {
		scrollMetrics.scrollChanged.remove(checkScrollMetrics);
		_scrollMetrics.remove(scrollMetrics);
	}
	
	private function checkAllScrollMetrics():Void {
		for (scrollMetrics in _scrollMetrics) {
			checkScrollMetrics(scrollMetrics);
		}
	}
	private function checkScrollMetrics(scrollMetrics:IScrollMetrics<Dynamic>):Void {
		if (scrollDir == Both) {
			limitMetrics(scrollMetrics);
		}else if (scrollDir == Horizontal) {
			if (Std.is(scrollMetrics, IHScrollMetrics)) {
				limitMetrics(scrollMetrics);
			}
		}else if (scrollDir == Vertical) {
			if (Std.is(scrollMetrics, IVScrollMetrics)) {
				limitMetrics(scrollMetrics);
			}
		}
	}
	private function limitMetrics(scrollMetrics:IScrollMetrics<Dynamic>):Void {
		if (scrollMetrics.scroll < scrollMetrics.min) {
			if (overshoot <= 0) {
				scrollMetrics.scroll = scrollMetrics.min;
			}else {
				throw "implement";
			}
		}else if (scrollMetrics.scroll+scrollMetrics.pageSize > scrollMetrics.max){
			if (overshoot <= 0) {
				scrollMetrics.scroll = scrollMetrics.max - scrollMetrics.pageSize;
			}else {
				throw "implement";
			}
		}
	}
}

enum ScrollDir {
	Horizontal;
	Vertical;
	Both;
}