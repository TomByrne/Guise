package guise.platform.nme;
import composure.core.ComposeItem;
import composure.utilTraits.Furnisher;
import guise.controls.logic.states.ButtonStateMapper;
import guise.core.CoreTags;
import guise.layer.LayerOrderer;
import guise.platform.nme.display.ContainerTrait;
import guise.platform.nme.display.StageTrait;
import guise.platform.nme.accessTypes.MouseClickable;
import guise.platform.nme.accessTypes.MouseInteractions;
import guise.platform.nme.layers.LayerContainer;
import guise.styledLayers.IDisplayLayer;
import guise.accessTypes.IMouseInteractionsAccess;
import guise.accessTypes.IMouseClickableAccess;
import guise.controls.ControlTags;


 
class NmePlatformAccess
{
	public static function install(within:ComposeItem) {
		within.addTrait(new Furnisher(WindowTag,	[TInst(StageTrait.inst())], null, true, false, true));
		within.addTrait(new Furnisher(StageTag,		[TInst(StageTrait.inst())], null, true, false, true));
		
		within.addTrait(new Furnisher(ContainerTag,		[TType(ContainerTrait, [UnlessHas(ContainerTrait)])]));
		within.addTrait(new Furnisher(IDisplayLayer,	[TType(ContainerTrait, [UnlessHas(ContainerTrait)]), TType(LayerContainer, [UnlessHas(LayerContainer)]), TType(LayerOrderer, [UnlessHas(LayerOrderer)])]));
		
		within.addTrait(new Furnisher(TextLabelTag, [TType(ContainerTrait, [UnlessHas(ContainerTrait)]), TType(LayerContainer, [UnlessHas(LayerContainer)])]));
		
		within.addTrait(new Furnisher(TextButtonTag(true), [TType(MouseClickable, [UnlessHas(IMouseClickableAccess)])]));
		
		within.addTrait(new Furnisher(ToggleButtonTag, [TType(MouseClickable, [UnlessHas(IMouseClickableAccess)])]));
		
		within.addTrait(new Furnisher(ButtonStateMapper, [TType(MouseInteractions, [UnlessHas(IMouseInteractionsAccess)])]));
	}
	
}