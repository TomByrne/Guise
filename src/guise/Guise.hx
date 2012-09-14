package guise;
import guise.core.GuiseItem;
import guise.traits.tags.CoreTags;
import composure.core.ComposeGroup;
import composure.core.ComposeRoot;

/**
 * ...
 * @author Tom Byrne
 */

class Guise
{
	public var root(get_root, null):ComposeRoot;
	public function get_root():ComposeRoot {
		return _parent.root;
	}
	
	public var window(default, null):GuiseItem;
	public var stage(default, null):GuiseItem;
	
	private var _parent:ComposeGroup;

	public function new(parent:ComposeGroup = null) {
		if (parent == null) {
			_parent = new ComposeRoot();
		}else {
			_parent = parent;
		}
		
		window = new GuiseItem();
		window.addTrait(new WindowTag());
		_parent.addChild(window);
		
		stage = new GuiseItem();
		stage.addTrait(new StageTag());
		window.addChild(stage);
	}
	
}