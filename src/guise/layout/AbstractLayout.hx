package guise.layout;
import composure.core.ComposeItem;
import composure.injectors.Injector;
import composure.traits.AbstractTrait;
import cmtc.ds.hash.ObjectHash;
import msignal.Signal;

/**
 * ...
 * @author Tom Byrne
 */

class AbstractLayout<InfoType : LayoutInfo<InfoType>> extends AbstractTrait
{
	private var _children:Array<InfoType>;
	private var _childToItem:ObjectHash<InfoType, ComposeItem>;

	private function new(t:Class<InfoType>) 
	{
		super();
		
		_children = [];
		_childToItem = new ObjectHash();
		
		var injector:Injector = new Injector(t, addLayoutChild, removeLayoutChild, false, true);
		injector.passThroughItem = true;
		addInjector(injector);
	}
	
	public function addLayoutChild(trait:InfoType, item:ComposeItem):Void {
		trait.layoutInfoChanged.add(layoutChild);
		_childToItem.set(trait, item);
		layoutChild(trait);
	}
	public function removeLayoutChild(trait:InfoType, item:ComposeItem):Void {
		trait.layoutInfoChanged.remove(layoutChild);
		_childToItem.delete(trait);
	}
	
	private function layoutChild(trait:InfoType):Void {
		// override me
	}
	private function getItem(trait:InfoType):ComposeItem {
		return _childToItem.get(trait);
	}
	private function getPositionables(item:ComposeItem):Iterable<IPositionable> {
		return item.getTraits(IPositionable);
	}
}

@:build(LazyInst.check())
class LayoutInfo<InfoType:LayoutInfo<InfoType>>
{
	@lazyInst
	public var layoutInfoChanged:Signal1<InfoType>;
	
	private function layoutChanged():Void{
		LazyInst.exec(layoutInfoChanged.dispatch(cast this));
	}
	
}