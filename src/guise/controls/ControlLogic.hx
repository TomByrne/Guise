package guise.controls;

import composure.utilTraits.Furnisher;
import composure.core.ComposeItem;
import guise.controls.data.INumRange;
import guise.controls.logic.input.MouseDragChangeValue;
import guise.skin.values.Bind;

import guise.controls.ControlTags;
import guise.controls.data.ISelected;
import guise.controls.logic.states.ButtonStateMapper;
import guise.controls.logic.states.SelectableStateMapper;
import guise.controls.logic.states.FocusStateMapper;
import guise.controls.logic.input.MouseOverTrait;
import guise.controls.logic.input.ButtonClickTrait;
import guise.controls.logic.input.TextInputPrompt;
import guise.controls.logic.input.ClickToggleSelect;
import guise.layout.IBoxPos;

/**
 * This should eventually be obsolete, it's purpose achieved by the Platform XML files.
 */

class ControlLogic 
{

	public static function install(within:ComposeItem):Void
	{
		var furnisher;
		furnisher = new Furnisher(TextButtonTag(false), [TType(MouseOverTrait), TType(ButtonStateMapper), TType(ButtonClickTrait)]);
		within.addTrait(furnisher);
		
		furnisher = new Furnisher(TextButtonTag(true), [TType(SelectableStateMapper), TType(ClickToggleSelect), TType(Selected, [UnlessHas(ISelected)])]);
		furnisher.checkEnumParams = [0];
		within.addTrait(furnisher);
		
		furnisher = new Furnisher(TextInputTag, [TType(TextInputPrompt), Furnisher.fact(new FocusStateMapper(ControlLayers.INPUT_TEXT))]);
		within.addTrait(furnisher);
		
		furnisher = new Furnisher(ToggleButtonTag, [TType(MouseOverTrait), TType(ButtonStateMapper), TType(SelectableStateMapper), TType(ButtonClickTrait), TType(ClickToggleSelect), TType(Selected, [UnlessHas(ISelected)])]);
		within.addTrait(furnisher);
		
		furnisher = new Furnisher(SliderTag(true), [TType(MouseOverTrait), TType(ButtonStateMapper), TType(NumRange, [UnlessHas(INumRange)]), Furnisher.fact(new MouseDragChangeValue(null,true,INumRange,"valueNorm",null,null,new Bind(BoxPos, "w", "sizeChanged")))]);
		within.addTrait(furnisher);
	}
	
}