package guise.controls.logic.input;

import composure.injectors.Injector;
import composure.traits.AbstractTrait;
import guise.platform.types.InteractionAccessTypes;
import guise.platform.PlatformAccessor;
import guiseSkins.styled.values.IValue;
import haxe.Timer;
/**
 * ...
 * @author Tom Byrne
 */

class MouseDragChangeValue extends AbstractTrait
{
	private var _dragStartTime:Float;
	
	private var _dragStartX:Float;
	private var _dragStartY:Float;
	private var _propStartX:Float;
	private var _propStartY:Float;
	
	private var _updatePropX:String;
	private var _updatePropY:String;
	
	private var _updateTraitX:Dynamic;
	private var _updateTraitY:Dynamic;
	
	private var _mouseInt:IMouseInteractions;
	
	private var _hasDragged:Bool;
	
	public var clickTime:Float = 0.2;
	public var dragMinDist:Float = 2;
	public var allowClick:Bool;
	
	public var normaliseX:IValue;
	public var normaliseY:IValue;

	public function new(?layerName:String, allowClick:Bool=false, ?updateTraitX:Dynamic, ?updatePropX:String, ?updateTraitY:Dynamic, ?updatePropY:String, ?normaliseX:IValue, ?normaliseY:IValue) 
	{
		super();
		
		addSiblingTrait(new PlatformAccessor(IMouseInteractions, layerName, onMouseIntAdd, onMouseIntRemove));
		
		this.allowClick = allowClick;
		this.normaliseX = normaliseX;
		this.normaliseY = normaliseY;
		
		if (updateTraitX != null && updatePropX != null) {
			_updatePropX = updatePropX;
			addInjector(new Injector(updateTraitX, onAddTraitX, onRemoveTraitX));
		}
		if(updateTraitY!=null && updatePropY!=null){
			_updatePropY = updatePropY;
			addInjector(new Injector(updateTraitY, onAddTraitY, onRemoveTraitY));
		}
	}
	
	private function onAddTraitX(trait:Dynamic):Void {
		_updateTraitX = trait;
	}
	private function onRemoveTraitX(trait:Dynamic):Void {
		_updateTraitX = null;
	}
	
	private function onAddTraitY(trait:Dynamic):Void {
		_updateTraitY = trait;
	}
	private function onRemoveTraitY(trait:Dynamic):Void {
		_updateTraitY = null;
	}
	
	private function onMouseIntAdd(access:IMouseInteractions):Void {
		_mouseInt = access;
		_mouseInt.pressed.add(onPressed);
		_mouseInt.released.add(onReleased);
	}
	private function onMouseIntRemove(access:IMouseInteractions):Void {
		_mouseInt.pressed.remove(onPressed);
		_mouseInt.released.remove(onReleased);
		_mouseInt = null;
	}
	
	private function onPressed(info:MouseInfo):Void {
		_mouseInt.moved.add(onMoved);
		
		_hasDragged = false;
		_dragStartX = info.mouseX;
		_dragStartY = info.mouseY;
		_dragStartTime = Timer.stamp();
		
		if (_updateTraitX!=null) {
			_propStartX = Reflect.getProperty(_updateTraitX,_updatePropX);
		}
		if (_updateTraitY!=null) {
			_propStartY = Reflect.getProperty(_updateTraitY,_updatePropY);
		}
	}
	private function onMoved(info:MouseInfo):Void {
		if(!_hasDragged){
			var difX:Float = info.mouseX - _dragStartX;
			var difY:Float = info.mouseY - _dragStartY;
			
			var dist:Float = Math.sqrt(difX * difX + difY * difY);
			
			if (dist > dragMinDist) {
				_hasDragged = true;
			}
		}
		if (_hasDragged) {
			updatePosition(info.mouseX - _dragStartX, info.mouseY - _dragStartY, _propStartX, _propStartY);
		}
	}
	private function onReleased(info:MouseInfo):Void {
		_mouseInt.moved.remove(onMoved);
		
		if (allowClick && !_hasDragged && (Timer.stamp() - _dragStartTime) < clickTime) {
			updatePosition(info.mouseX, info.mouseY, 0, 0);
		}
	}
	private function updatePosition(x:Float, y:Float, offsetX:Float, offsetY:Float):Void {
		if (_updateTraitX!=null) {
			if (normaliseX != null) {
				normaliseX.update(item);
				x /= normaliseX.currentValue;
			}
			Reflect.setProperty(_updateTraitX,_updatePropX, x+offsetX);
		}
		if (_updateTraitY!=null) {
			if (normaliseY != null) {
				normaliseY.update(item);
				y /= normaliseY.currentValue;
			}
			Reflect.setProperty(_updateTraitY,_updatePropY, y+offsetY);
		}
	}
	
}