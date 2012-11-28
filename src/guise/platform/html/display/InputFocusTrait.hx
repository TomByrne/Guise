package guise.platform.html.display;
import composure.traits.AbstractTrait;
import guise.controls.data.ITextLabel;
import guise.controls.data.ISelected;
import guise.platform.IPlatformAccess;
import msignal.Signal;
import js.Lib;
import js.Dom;

/**
 * ...
 * @author Tom Byrne
 */


@:build(LazyInst.check())
class InputFocusTrait implements IFocusableAccess
{
	@inject
	private var textTrait(default, set_textTrait):TextLabelTrait;
	private function set_textTrait(value:TextLabelTrait):TextLabelTrait {
		if (textTrait != null) {
			textTrait.domElement.onfocus = null;
			textTrait.domElement.onblur = null;
		}
		
		this.textTrait = value;
		
		var newFoc:Bool;
		if (textTrait != null) {
			textTrait.domElement.onfocus = onFocusIn;
			textTrait.domElement.onblur = onFocusOut;
			newFoc = Lib.document.activeElement == textTrait.domElement;
		}else {
			newFoc = false;
		}
		if (focused != newFoc) {
			this.focused = newFoc;
			LazyInst.exec(focusedChanged.dispatch(this));
		}
		return value;
	}

	public function new(){
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