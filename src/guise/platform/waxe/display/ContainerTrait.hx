package guise.platform.waxe.display;
import composure.injectors.Injector;
import composure.traitCheckers.TraitTypeChecker;
import composure.traits.AbstractTrait;
import guise.platform.cross.display.AbsDisplayTrait;
import wx.Window;
import wx.Panel;
import msignal.Signal;

class ContainerTrait extends AbsDisplayTrait
{
	@lazyInst
	public var posChanged:Signal1<ContainerTrait>;
	
	private var _parentCont:ContainerTrait;
	private var _descX:Float = 0;
	private var _descY:Float = 0;
	
	public function new() {
		super();
		
		var injector = new Injector(ContainerTrait, onParentContAdded, onParentContRemoved, true, false, true);
		injector.stopAscendingAt = TraitTypeChecker.createMulti([DisplayTrait, ContainerTrait], true);
		injector.matchTrait = TraitTypeChecker.create(ContainerTrait,true,this);
		addInjector(injector);
	}
	
	private function onParentContAdded(parent:ContainerTrait):Void {
		if (_parentCont != null) return;
		
		_parentCont = parent;
		_parentCont.posChanged.add(onParentPosChanged);
		doChange();
	}
	private function onParentContRemoved(parent:ContainerTrait):Void {
		if (_parentCont != parent) return;
		_parentCont.posChanged.remove(onParentPosChanged);
		_parentCont = null;
		doChange();
	}
	private function onParentPosChanged(parent:ContainerTrait ):Void {
		doChange();
	}
	
	override private function onPosValid(w:Float, h:Float):Void {
		doChange();
	}
	
	public function getDescX():Float {
		return _descX;
	}
	public function getDescY():Float {
		return _descY;
	}
	private function doChange():Void {
		var newX:Float;
		var newY:Float;
		if(position!=null){
			if (_parentCont != null) {
				newX = position.x+_parentCont.getDescX();
				newY = position.y+_parentCont.getDescY();
			}else {
				newX = position.x;
				newY = position.y;
			}
		}else if (_parentCont != null) {
			newX = _parentCont.getDescX();
			newY = _parentCont.getDescY();
		}else {
			newX = 0;
			newY = 0;
		}
		if (_descX != newX || _descY != newY) {
			setPos(newX, newY);
		}
	}
	private function setPos(x:Float, y:Float):Void {
		_descX = x;
		_descY = y;
		LazyInst.exec(posChanged.dispatch(this));
	}
}