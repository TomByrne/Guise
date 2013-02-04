package guise.layout;


import msignal.Signal;

interface IBoxPos 
{

	public var changed(get_changed, null):Signal1<IBoxPos>;
	public var posChanged(get_posChanged, null):Signal1<IBoxPos>;
	public var sizeChanged(get_sizeChanged, null):Signal1<IBoxPos>;
	
	public var x(default, null):Float;
	public var y(default, null):Float;
	public var w(default, null):Float;
	public var h(default, null):Float;
	
}

@:build(LazyInst.check())
class BoxPos implements IBoxPos
{
	@lazyInst
	public var changed:Signal1<IBoxPos>;
	
	@lazyInst
	public var posChanged:Signal1<IBoxPos>;
	
	@lazyInst
	public var sizeChanged:Signal1<IBoxPos>;
	
	public var x(default, null):Float;
	public var y(default, null):Float;
	public var w(default, null):Float;
	public var h(default, null):Float;

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
	/*public function set(x:Float, y:Float, width:Float, height:Float):Void {
		if (this.x != x || this.y != y || this.width != width || this.height != height) {
			this.x = x;
			this.y = y;
			this.width = width;
			this.height = height;
			LazyInst.exec(posChanged.dispatch(this));
			LazyInst.exec(sizeChanged.dispatch(this));
			LazyInst.exec(changed.dispatch(this));
		}
	}*/
	
	
}