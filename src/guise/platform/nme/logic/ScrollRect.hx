package guise.platform.nme.logic;
import composure.traits.AbstractTrait;
import guise.platform.nme.display.ContainerTrait;
import guise.skin.values.IValue;
import guise.skin.values.ValueUtils;
import msignal.Signal;
import nme.geom.Rectangle;

class ScrollRect extends AbstractTrait
{
	@:isVar public var xValue(default, set_xValue):IValue;
	private function set_xValue(value:IValue):IValue {
		xValue = value;
		onXChanged();
		return value;
	}
	@:isVar public var yValue(default, set_yValue):IValue;
	private function set_yValue(value:IValue):IValue {
		yValue = value;
		onYChanged();
		return value;
	}
	@:isVar public var wValue(default, set_wValue):IValue;
	private function set_wValue(value:IValue):IValue {
		wValue = value;
		onWChanged();
		return value;
	}
	@:isVar public var hValue(default, set_hValue):IValue;
	private function set_hValue(value:IValue):IValue {
		hValue = value;
		onHChanged();
		return value;
	}
	
	private var _xSignals:Array<AnySignal>;
	private var _ySignals:Array<AnySignal>;
	private var _wSignals:Array<AnySignal>;
	private var _hSignals:Array<AnySignal>;
	
	private var _scrollRect:Rectangle;
	private var _container:ContainerTrait;

	public function new(xValue:IValue, yValue:IValue, wValue:IValue, hValue:IValue) 
	{
		super();
		
		_xSignals = [];
		_ySignals = [];
		_wSignals = [];
		_hSignals = [];
		
		_scrollRect = new Rectangle();
		
		this.xValue = xValue;
		this.yValue = yValue;
		this.wValue = wValue;
		this.hValue = hValue;
	}
	
	@injectAdd
	private function addContainer(value:ContainerTrait):Void {
		_container = value;
		updateScrollRect();
	}
	@injectRemove
	private function removeContainer(value:ContainerTrait):Void {
		_container.container.scrollRect = null;
		_container = null;
	}
	
	override private function onItemAdd():Void {
		super.onItemAdd();
		onXChanged();
		onYChanged();
		onWChanged();
		onHChanged();
	}
	override private function onItemRemove():Void {
		super.onItemRemove();
		ValueUtils.clear(_xSignals, onXChanged);
		ValueUtils.clear(_ySignals, onYChanged);
		ValueUtils.clear(_wSignals, onWChanged);
		ValueUtils.clear(_hSignals, onHChanged);
	}
	
	private function onXChanged(?param1:Dynamic, ?param2:Dynamic):Void {
		if (item == null) return;
		
		ValueUtils.update(xValue, item, _xSignals, onXChanged, true);
		if(!Math.isNaN(xValue.currentValue))_scrollRect.x = xValue.currentValue;
		updateScrollRect();
	}
	private function onYChanged(?param1:Dynamic, ?param2:Dynamic):Void {
		if (item == null) return;
		
		ValueUtils.update(yValue, item, _ySignals, onYChanged, true);
		if(!Math.isNaN(yValue.currentValue))_scrollRect.y = yValue.currentValue;
		updateScrollRect();
	}
	private function onWChanged(?param1:Dynamic, ?param2:Dynamic):Void {
		if (item == null) return;
		
		ValueUtils.update(wValue, item, _wSignals, onWChanged, true);
		if(!Math.isNaN(wValue.currentValue))_scrollRect.width = wValue.currentValue;
		updateScrollRect();
	}
	private function onHChanged(?param1:Dynamic, ?param2:Dynamic):Void {
		if (item == null) return;
		
		ValueUtils.update(hValue, item, _hSignals, onHChanged, true);
		if(!Math.isNaN(hValue.currentValue))_scrollRect.height = hValue.currentValue;
		updateScrollRect();
	}
	
	private function updateScrollRect():Void {
		if (_container == null) return;
		_container.setChildScrollRect(_scrollRect);
	}
}