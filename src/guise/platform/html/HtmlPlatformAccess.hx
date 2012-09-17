package guise.platform.html;
import composure.core.ComposeItem;
import guise.controls.ControlLayers;
import guise.platform.AbsPlatformAccess;
import guise.platform.html.input.MouseClickable;
import guise.platform.IPlatformAccess;
import guise.platform.types.TextAccessTypes;
import guise.platform.types.DisplayAccessTypes;
import guise.platform.types.CoreAccessTypes;
import guise.platform.types.DrawingAccessTypes;
import guise.platform.types.InteractionAccessTypes;
import cmtc.ds.hash.ObjectHash;
import guise.traits.tags.CoreTags;
import composure.utilTraits.Furnisher;
import guise.platform.nme.core.FrameTicker;

/**
 * ...
 * @author Tom Byrne
 */

 
class HtmlPlatformAccess extends AbsPlatformAccess<ContInfo, LayerInfo>
{
	public static function install(within:ComposeItem){
		within.addTrait(new HtmlPlatformAccess());
		//within.addTrait(new Furnisher(StageTag,	[TType(StageSkin)]));
	}
	
	
	public function new() 
	{
		super(ContInfo.create, ContInfo.destroy, LayerInfo.create, LayerInfo.destroy);
		
		registerLayerAccess(MouseClickable, [IMouseClickable], getMouseClickLayerAccess, returnMouseClickLayerAccess);
	}
	
	private function getMouseClickLayerAccess(layer:LayerInfo):MouseClickable {
		layer.createContainer();
		return new MouseClickable(layer.container);
	}
	private function returnMouseClickLayerAccess(layer:LayerInfo, access:MouseClickable):Void {
		access.interactiveObject = null;
	}
}
class ContInfo {
	// TODO:pooling
	public static function create(context:ComposeItem):ContInfo {
		return new ContInfo(context);
	}
	public static function destroy(contInfo:ContInfo):Void {
		contInfo.context = null;
	}
	
	
	
	public var context(default, set_context):ComposeItem;
	private function set_context(value:ComposeItem):ComposeItem {
		context = value;
		return value;
	}
	
	public function new(context:ComposeItem){
		//super();
		
		this.context = context;
	}
}
class LayerInfo{
	// TODO:pooling
	public static function create(contInfo:ContInfo, layerName:String):LayerInfo {
		return new LayerInfo(contInfo, layerName);
	}
	public static function destroy(layerInfo:LayerInfo):Void{
		layerInfo.contInfo = null;
	}
	
	
	
	public var contInfo(default, set_contInfo):ContInfo;
	private function set_contInfo(value:ContInfo):ContInfo {
		contInfo = value;
		return value;
	}
	
	public var layerName:String;
	
	public function new(contInfo:ContInfo, layerName:String) 
	{
		//super();
		this.contInfo = contInfo;
		this.layerName = layerName;
	}
	
	public function createContainer():Void {
		if (container == null) {
			container = new Sprite();
			container.name = layerName;
			
			assessDisplayObject();
		}
	}
}