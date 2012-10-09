package guise.platform.waxe.display;
import composure.traits.AbstractTrait;
import guise.controls.data.ITextLabel;
import guise.controls.data.ISelected;
import guise.platform.IPlatformAccess;
import msignal.Signal;

/**
 * ...
 * @author Tom Byrne
 */


@:build(LazyInst.check())
class InputFocusTrait implements IFocusableAccess
{
	
	private var _domElement:HtmlDom;

	public function new(domElement:HtmlDom){
		_domElement = domElement;
		
		_domElement.onfocus = onFocusIn;
		_domElement.onblur = onFocusOut;
	}
	
	private function onFocusIn(e:Event):Void {
		this.focused = true;
		LazyInst.exec(focusedChanged.dispatch(this));
	}
	private function onFocusOut(e:Event):Void {
		this.focused = false;
		LazyInst.exec(focusedChanged.dispatch(this));
	}
	
	public var focused(default, null):Bool;
	
	@lazyInst
	public var focusedChanged(default, null):Signal1 < IFocusableAccess > ;
}