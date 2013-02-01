package guise.skin.drawn.utils;
import composure.core.ComposeItem;
import composure.utilTraits.Furnisher;
import guise.controls.ControlLayers;
import guise.controls.ControlTags;
import guise.controls.data.ISelected;
import guise.controls.logic.input.ClickToggleSelect;
import guise.layer.LayerOrderer;

/**
 * This class will eventually be factored out, layering will be implied by the styles XML files.
 */

class NormalLayering 
{

	public static function install(within:ComposeItem) 
	{
		var furnisher:Furnisher = new Furnisher(TextButtonTag(false));
		furnisher.addTrait(TFact(function(tag:Dynamic) { return new LayerOrderer([ControlLayers.BACKING, ControlLayers.LABEL_TEXT]);}) );
		within.addTrait(furnisher);
		
		furnisher = new Furnisher(TextInputTag);
		furnisher.addTrait(TFact(function(tag:Dynamic) { return new LayerOrderer([ControlLayers.BACKING, ControlLayers.INPUT_TEXT]);} ));
		within.addTrait(furnisher);
		
		furnisher = new Furnisher(ToggleButtonTag);
		furnisher.addTrait(TFact(function(tag:Dynamic) { return new LayerOrderer([ControlLayers.BACKING, ControlLayers.CONTROL_HANDLE]);} ));
		within.addTrait(furnisher);
		
		furnisher = new Furnisher(SliderTag(true));
		furnisher.addTrait(TFact(function(tag:Dynamic) { return new LayerOrderer([ControlLayers.BACKING, ControlLayers.CONTROL_HANDLE]);} ));
		within.addTrait(furnisher);
	}
	
}