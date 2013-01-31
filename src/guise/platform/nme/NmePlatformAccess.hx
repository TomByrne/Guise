package guise.platform.nme;
import composure.core.ComposeItem;
import composure.utilTraits.Furnisher;
import guise.accessTypes.IBoxPosAccess;
import guise.accessTypes.IFilterableAccess;
import guise.accessTypes.IFocusableAccess;
import guise.accessTypes.IGraphicsAccess;
import guise.accessTypes.IPositionAccess;
import guise.accessTypes.ITextInputAccess;
import guise.accessTypes.ITextOutputAccess;
import guise.controls.logic.states.ButtonStateMapper;
import guise.core.CoreTags;
import guise.layer.LayerOrderer;
import guise.platform.cross.AccessProvider;
import guise.platform.nme.accessTypes.AdditionalTypes;
import guise.platform.nme.accessTypes.FilterableAccess;
import guise.platform.nme.accessTypes.FocusableAccess;
import guise.platform.nme.accessTypes.GraphicsAccess;
import guise.platform.nme.accessTypes.PositionAccess;
import guise.platform.nme.accessTypes.TextAccess;
import guise.platform.nme.display.ContainerTrait;
import guise.platform.nme.display.StageTrait;
import guise.platform.nme.accessTypes.MouseClickable;
import guise.platform.nme.accessTypes.MouseInteractions;
import guise.platform.nme.layers.LayerSwapper;
import guise.accessTypes.IMouseInteractionsAccess;
import guise.accessTypes.IMouseClickableAccess;
import guise.controls.ControlTags;
import guiseSkins.styled.AbsStyledLayer;

 
class NmePlatformAccess
{
	public static function install(within:ComposeItem) {
		within.addTrait(new Furnisher(WindowTag,	[TInst(StageTrait.inst())], null, true, false, true));
		within.addTrait(new Furnisher(StageTag,		[TInst(StageTrait.inst())], null, true, false, true));
		
		within.addTrait(new Furnisher(ContainerTag,		[TType(ContainerTrait, [UnlessHas(ContainerTrait)])]));
		
		within.addTrait(new Furnisher(IDisplayObjectType, [TType(ContainerTrait, [UnlessHas(ContainerTrait)]), TType(LayerSwapper, [UnlessHas(LayerSwapper)]), TType(LayerOrderer, [UnlessHas(LayerOrderer)])]));
		
		
		within.addTrait(new Furnisher(TextButtonTag(true), [TType(MouseClickable, [UnlessHas(IMouseClickableAccess)])]));
		
		within.addTrait(new Furnisher(ToggleButtonTag, [TType(MouseClickable, [UnlessHas(IMouseClickableAccess)])]));
		
		within.addTrait(new Furnisher(ButtonStateMapper, [TType(MouseInteractions, [UnlessHas(IMouseInteractionsAccess)])]));
		
		
		var accessProvider:AccessProvider = new AccessProvider();
		accessProvider.mapAccessType(IFilterableAccess, FilterableAccess);
		accessProvider.mapAccessType(IGraphicsAccess, GraphicsAccess);
		accessProvider.mapAccessType(IPositionAccess, PositionAccess);
		accessProvider.mapAccessType(IBoxPosAccess, PositionAccess);
		accessProvider.mapAccessType(ITextInputAccess, TextAccess);
		accessProvider.mapAccessType(ITextOutputAccess, TextAccess);
		accessProvider.mapAccessType(IFocusableAccess, FocusableAccess);
		within.addTrait(accessProvider);
	}
}