package guise.platform.nme.display;

import composure.injectors.Injector;
import composure.traitCheckers.TraitTypeChecker;
import guise.layout.IBoxPos;
import guise.platform.cross.display.AbsDisplayTrait;
import nme.display.DisplayObject;
import nme.events.Event;

import msignal.Signal;


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
		if (_parent != null) {
			// parent container has been added between here and existing parent
			onParentRemoved(_parent);
		}
		
		_parent = parent;
		if(displayObject!=null && parent.childContainer!=null){
			parent.childContainer.addChild(displayObject);
		}
	}
	private function onParentRemoved(parent:ContainerTrait):Void {
		if (_parent != parent) return;
		
		if(displayObject!=null && parent.childContainer!=null){
			parent.childContainer.removeChild(displayObject);
		}
		_parent = null;
	}
	private function assumeDisplayObject():Void {
		throw "Must override";
	}
	
	private function setDisplayObject(value:DisplayObject):Void {
		if (displayObject != null) {
			if(_parent!=null && _parent.childContainer!=null){
				_parent.childContainer.removeChild(displayObject);
			}
		}
		this.displayObject = value;
		if (displayObject!=null) {
			if(_parent!=null && _parent.childContainer!=null){
				_parent.childContainer.addChild(displayObject);
			}
		}
	}
	
	override private function onPosValid(x:Float, y:Float):Void {
		displayObject.x = x;
		displayObject.y = y;
	}
	/*public function setPosition(x:Float, y:Float, w:Float, h:Float):Void {
		displayObject.x = x;
		displayObject.y = y;
	}*/
}