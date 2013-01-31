package guise.platform.html5;

import composure.core.ComposeItem;
import composure.utilTraits.Furnisher;
import guise.controls.data.INumRange;
import guise.controls.data.ISelected;
import guise.controls.data.ITextLabel;
import guise.controls.logic.input.ClickToggleSelect;
import guise.core.CoreTags;
import guise.controls.ControlTags;
import guise.platform.html5.controls.CheckBoxTrait;
import guise.platform.html5.display.WindowTrait;
import guise.platform.html5.display.StageTrait;
import guise.platform.html5.display.ContainerTrait;
import guise.platform.html5.display.DisplayTrait;
import guise.platform.html5.controls.TextButtonTrait;
import guise.platform.html5.logic.MouseClickable;
import guise.platform.html5.controls.TextLabelTrait;
import guise.platform.html5.controls.TextInputTrait;
import guise.platform.html5.controls.SliderTrait;

 
class HtmlPlatformAccess {
	public static function install(within:ComposeItem) {
		within.addTrait(new Furnisher(WindowTag,	[TFact(getWindow)], null, true, false, true));
		within.addTrait(new Furnisher(StageTag,		[TFact(getStage)], null, true, false, true));
		
		within.addTrait(new Furnisher(TextButtonTag(false),[TType(TextButtonTrait), TType(MouseClickable), TType(TextLabel, [UnlessHas(ITextLabel)])]));
		within.addTrait(new Furnisher(TextInputTag,[TType(TextInputTrait)]));
		within.addTrait(new Furnisher(TextLabelTag,[TType(TextLabelTrait)]));
		within.addTrait(new Furnisher(SliderTag(true), [TType(SliderTrait), TType(NumRange, [UnlessHas(INumRange)])]));
		within.addTrait(new Furnisher(ToggleButtonTag, [TType(CheckBoxTrait), TType(Selected, [UnlessHas(ISelected)])]));
		
		var furnisher = new Furnisher(TextButtonTag(true), [TType(Selected, [UnlessHas(ISelected)]), TType(ClickToggleSelect)]);
		furnisher.checkEnumParams = [0];
		within.addTrait(furnisher);
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