package guise.controls;

import composure.core.ComposeItem;
import guise.traits.tags.ControlTags;
import composure.utilTraits.Furnisher;
import guise.controls.logic.input.MouseOverTrait;
import guise.controls.logic.states.ButtonStateMapper;
import guise.controls.logic.states.SelectableStateMapper;
import guise.controls.logic.input.ButtonClickTrait;
import guise.controls.logic.input.TextInputPrompt;
import guise.controls.logic.states.FocusStateMapper;

/**
 * @author Tom Byrne
 */

class ControlLogic 
{

	public static function install(within:ComposeItem):Void
	{
		var furnisher = new Furnisher(TextButtonTag, [TType(MouseOverTrait), TType(ButtonStateMapper), TType(SelectableStateMapper), TType(ButtonClickTrait)]);
		//furnisher.addTrait(TType(TextLabel, [UnlessHas(TextLabel)]));
		within.addTrait(furnisher);
		
		var furnisher = new Furnisher(TextInputTag, [TType(TextInputPrompt), Furnisher.fact(new FocusStateMapper(ControlLayers.INPUT_TEXT))]);
		//furnisher.addTrait(TType(TextLabel, [UnlessHas(TextLabel)]));
		within.addTrait(furnisher);
	}
	
}