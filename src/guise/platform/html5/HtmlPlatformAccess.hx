package guise.platform.html5;

import composure.core.ComposeItem;
import composure.utilTraits.Furnisher;
import guise.controls.data.ISelected;
import guise.controls.logic.input.ClickToggleSelect;
import guise.core.CoreTags;
import guise.controls.ControlTags;
import guise.platform.html5.display.WindowTrait;
import guise.platform.html5.display.StageTrait;
import guise.platform.html5.display.ContainerTrait;
import guise.platform.html5.display.DisplayTrait;
import guise.platform.html5.controls.ButtonTrait;
import guise.platform.html5.logic.MouseClickable;

/**
 * ...
 * @author Tom Byrne
 */

 
class HtmlPlatformAccess {
	public static function install(within:ComposeItem) {
		within.addTrait(new Furnisher(WindowTag,	[TFact(getWindow)], null, true, false, true));
		within.addTrait(new Furnisher(StageTag,		[TFact(getStage)], null, true, false, true));
		
		within.addTrait(new Furnisher(TextButtonTag(false),[TType(ButtonTrait), TType(MouseClickable)]));
		within.addTrait(new Furnisher(TextButtonTag(true),[TType(ButtonTrait), TType(MouseClickable)]));
	}
	
	private static var _window:WindowTrait;
	private static var _stage:StageTrait;
	
	private static function getWindow(tag:CoreTags):WindowTrait {
		if (_window==null) {
			_window = new WindowTrait();
		}
		return _window;
	}
	private static function getStage(tag:CoreTags):StageTrait {
		if (_stage==null) {
			_stage = new StageTrait();
		}
		return _stage;
	}
}