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
import guise.platform.nme.addTypes.IDisplayObjectType;
import guise.platform.nme.addTypes.IInteractiveObjectType;
import guise.platform.nme.accessTypes.FilterableAccess;
import guise.platform.nme.accessTypes.FocusableAccess;
import guise.platform.nme.accessTypes.GraphicsAccess;
import guise.platform.nme.accessTypes.PositionAccess;
import guise.platform.nme.accessTypes.TextAccess;
import guise.platform.nme.display.ContainerTrait;
import guise.platform.nme.display.StageTrait;
import guise.platform.nme.accessTypes.MouseClickableAccess;
import guise.platform.nme.accessTypes.MouseInteractionsAccess;
import guise.platform.nme.layers.LayerSwapper;
import guise.accessTypes.IMouseInteractionsAccess;
import guise.accessTypes.IMouseClickableAccess;
import guise.controls.ControlTags;
import guise.skin.common.AbsStyledLayer;
import guise.macro.FurnisherMacro;

 
class NmePlatformAccess
{
	public static function install(within:ComposeItem) {
		
		FurnisherMacro.path(within, "../Platforms/NME.xml");
		
		var accessProvider:AccessProvider = new AccessProvider();
		accessProvider.mapAccessType(IFilterableAccess, FilterableAccess);
		accessProvider.mapAccessType(IGraphicsAccess, GraphicsAccess);
		accessProvider.mapAccessType(IPositionAccess, PositionAccess);
		accessProvider.mapAccessType(IBoxPosAccess, PositionAccess);
		accessProvider.mapAccessType(ITextInputAccess, TextAccess);
		accessProvider.mapAccessType(ITextOutputAccess, TextAccess);
		accessProvider.mapAccessType(IFocusableAccess, FocusableAccess);
		accessProvider.mapAccessType(IMouseClickableAccess, MouseClickableAccess);
		accessProvider.mapAccessType(IMouseInteractionsAccess, MouseInteractionsAccess);
		within.addTrait(accessProvider);
	}
}