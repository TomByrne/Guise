package guise.platform.nme.display;

import composure.injectors.Injector;
import composure.traitCheckers.TraitTypeChecker;
import guise.layout.IDisplayPosition;
import guise.platform.cross.display.AbsDisplayTrait;
import nme.display.DisplayObject;
import nme.events.Event;

import msignal.Signal;

/**
 * @author Tom Byrne
 */

class DisplayTrait extends AbsDisplayTrait
{
	
	public var displayObject(default, null):DisplayObject;
	
	private var _parent:ContainerTrait;

	public function new(displayObject:DisplayObject=null) 
	{
		super();
		_posListen = true;
		
		var injector = new Injector(ContainerTrait, onParentAdded, onParentRemoved, true, false, true);
		injector.stopAscendingAt = TraitTypeChecker.create(DisplayTrait);
		injector.matchTrait = TraitTypeChecker.create(ContainerTrait,true,this);
		addInjector(injector);
		
		if(displayObject!=null && this.displayObject!=displayObject){
			setDisplayObject(displayObject);
		}else if(this.displayObject==null){
			assumeDisplayObject();
		}
	}
	private function onParentAdded(parent:ContainerTrait):Void {
		if (_parent != null) return;
		
		_parent = parent;
		if(displayObject!=null && parent.container!=null){
			parent.container.addChild(displayObject);
		}
	}
	private function onParentRemoved(parent:ContainerTrait):Void {
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
	
	override private function onPosChanged(from:IDisplayPosition):Void {
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