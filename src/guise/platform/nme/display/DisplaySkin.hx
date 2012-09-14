package guise.platform.nme.display;

import composure.injectors.Injector;
import composure.traitCheckers.TraitTypeChecker;
import guise.core.AbsPosAwareTrait;
import guise.layout.IPositionable;
import nme.display.DisplayObject;
import nme.events.Event;

import msignal.Signal;

/**
 * @author Tom Byrne
 */

class DisplaySkin extends AbsPosAwareTrait, implements IPositionable
{
	
	public var displayObject(default, null):DisplayObject;
	
	private var _parent:ContainerSkin;

	public function new(displayObject:DisplayObject=null) 
	{
		super();
		
		var injector = new Injector(ContainerSkin, onParentAdded, onParentRemoved, true, false, true);
		injector.stopAscendingAt = TraitTypeChecker.create(DisplaySkin);
		injector.matchTrait = TraitTypeChecker.create(ContainerSkin,true,this);
		addInjector(injector);
		
		if(displayObject!=null && this.displayObject!=displayObject){
			setDisplayObject(displayObject);
		}else if(this.displayObject==null){
			assumeDisplayObject();
		}
	}
	private function onParentAdded(parent:ContainerSkin):Void {
		if (_parent != null) return;
		
		_parent = parent;
		if(displayObject!=null && parent.container!=null){
			parent.container.addChild(displayObject);
		}
	}
	private function onParentRemoved(parent:ContainerSkin):Void {
		if (_parent != parent) return;
		
		if(displayObject!=null && parent.container!=null){
			parent.container.removeChild(displayObject);
		}
		_parent = null;
	}
	private function assumeDisplayObject():Void {
		throw "Must override";
	}
	
	private function setDisplayObject(value:DisplayObject):Void {
		if (displayObject != null) {
			if(_parent!=null && _parent.container!=null){
				_parent.container.removeChild(displayObject);
			}
		}
		this.displayObject = value;
		if (displayObject!=null) {
			if(_parent!=null && _parent.container!=null){
				_parent.container.addChild(displayObject);
			}
		}
	}
	
	override private function posChanged():Void {
		if (!Math.isNaN(position.y) && !Math.isNaN(position.x)) {
			displayObject.x = position.x;
			displayObject.y = position.y;
		}
	}
	public function setPosition(x:Float, y:Float, w:Float, h:Float):Void {
		displayObject.x = x;
		displayObject.y = y;
	}
}