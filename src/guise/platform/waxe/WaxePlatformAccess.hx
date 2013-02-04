package guise.platform.waxe;

import composure.core.ComposeItem;
import composure.utilTraits.Furnisher;
import guise.controls.data.INumRange;
import guise.controls.data.ISelected;
import guise.controls.data.ITextLabel;
import guise.controls.logic.input.ClickToggleSelect;
import guise.core.CoreTags;
import guise.controls.ControlTags;
import guise.platform.waxe.display.WindowTrait;
import guise.platform.waxe.display.StageTrait;
import guise.platform.waxe.display.ContainerTrait;
import guise.platform.waxe.display.DisplayTrait;
import guise.platform.waxe.display.PanelTrait;

 
class WaxePlatformAccess {
	public static function install(within:ComposeItem) { 
		within.addTrait(new Furnisher(WindowTag,	[TFact(getWindow)], null, true, false, true));
		within.addTrait(new Furnisher(StageTag,		[TFact(getStage)], null, true, false, true));
		within.addTrait(new Furnisher(ContainerTag,		[TType(PanelTrait)], null, true, false, true));
		
		within.addTrait(new Furnisher(TextButtonTag(false),[TType(guise.platform.waxe.controls.TextButtonTrait), TType(guise.platform.waxe.logic.MouseClickable)/*, TType(TextLabel, [UnlessHas(ITextLabel)])*/]));
		within.addTrait(new Furnisher(TextInputTag,[TType(guise.platform.waxe.controls.TextInputTrait)]));
		within.addTrait(new Furnisher(TextLabelTag,[TType(guise.platform.waxe.controls.TextLabelTrait)]));
		/*within.addTrait(new Furnisher(SliderTag(true), [TType(guise.platform.waxe.controls.SliderTrait), TType(NumRange, [UnlessHas(INumRange)])]));
		within.addTrait(new Furnisher(ToggleButtonTag, [TType(guise.platform.waxe.controls.CheckBoxTrait), TType(Selected, [UnlessHas(ISelected)])]));
		
		var furnisher = new Furnisher(TextButtonTag(true), [TType(Selected, [UnlessHas(ISelected)]), TType(ClickToggleSelect)]);
		furnisher.checkEnumParams = [0];
		within.addTrait(furnisher);*/
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