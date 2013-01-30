package guiseSkins.styled;
import guise.layout.IDisplayPosition;
import guise.styledLayers.IDisplayLayer;
import guiseSkins.styled.values.IValue;
import guiseSkins.trans.ITransitioner;
import guise.states.StateStyledTrait;

/**
 * ...
 * @author Tom Byrne
 */

class AbsStyledLayer<StyleType> extends StateStyledTrait<StyleType>
{
	@inject
	public var position(default, set_position):IDisplayPosition;
	private function set_position(value:IDisplayPosition):IDisplayPosition {
		if (position != null) {
			position.changed.remove(onPosChanged);
		}
		this.position = value;
		if (position != null) {
			position.changed.add(onPosChanged);
			onPosChanged(value);
		}
		
		return value;
	}
	

	public function new(?normalStyle:StyleType, ?isReadyToDraw:Void->Bool, ?drawStyle:Void->Void, ?transSubject:Dynamic) 
	{
		super(normalStyle, isReadyToDraw, drawStyle, transSubject);
	}
	
	override private function _isReadyToDraw():Bool {
		return (!_requirePos || (!Math.isNaN(x) && !Math.isNaN(y))) && (!_requireSize || (!Math.isNaN(w) && !Math.isNaN(h)));
	}
	
	private var _requirePos:Bool = false;
	private var _requireSize:Bool = true;
	
	public var x:Float;
	public var y:Float;
	public var w:Float;
	public var h:Float;
	public function setPosition(x:Float, y:Float, w:Float, h:Float):Void {
		var change:Bool = false;
		if(this.x!=x || this.y!=y){
			this.x = x;
			this.y = y;
			if (_requirePos) change = true;
		}
		if(this.w!=w || this.h!=h){
			this.w = w;
			this.h = h;
			if (_requireSize) change = true;
		}
		if(change)invalidate();
	}
	
	public function onPosChanged(from:IDisplayPosition):Void {
		setPosition(from.x,from.y,from.w,from.h);
	}
}
