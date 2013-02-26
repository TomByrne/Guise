package guise.core;
import haxe.ds.GenericStack;
import msignal.Signal;
import composure.injectors.Injector;
import composure.core.ComposeItem;
import composure.traits.AbstractTrait;
import composure.traitCheckers.TraitTypeChecker;

/**
 * ...
 * @author Tom Byrne
 */

class CascadingActive extends AbstractTrait implements IActive
{

	@:isVar public var activeChanged(default, null):Signal1<IActive>;
	
	@:isVar public var active(default, null):Bool;
	@:isVar public var explicit(default, null):Bool;
	
	public var cascade:Bool;
	
	private var _children:GenericStack<IActive>;

	public function new(active:Bool = true, explicit:Bool=false , cascade:Bool = true) 
	{
		super();
		
		activeChanged = new Signal1();
		if(active || explicit)set(active, explicit);
		
		var injector:Injector = new Injector(IActive, onChildAdded, onChildRemoved, false, true);
		injector.stopDescendingAt = TraitTypeChecker.create(IActive);
		addInjector(injector);
	}
	
	public function set(active:Bool, explicit:Bool):Void{
		if (this.active != active || this.explicit!=explicit) {
			this.active = active;
			this.explicit = explicit;
			
			if(cascade && _children!=null){
				for (child in _children) {
					if(!child.explicit)child.set(active, false);
				}
			}
			
			activeChanged.dispatch(this);
		}
	}
	
	private function onChildAdded(child:IActive):Void {
		if (_children==null) {
			_children = new GenericStack<IActive>();
		}
		_children.add(child);
		if (child.explicit) {
			child.set(active, false);
		}
		
	}
	private function onChildRemoved(child:IActive):Void {
		_children.remove(child);
	}
}