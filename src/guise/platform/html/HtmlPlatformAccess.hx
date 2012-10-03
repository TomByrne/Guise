package guise.platform.html;
import composure.core.ComposeItem;
import guise.controls.ControlLayers;
import guise.controls.logic.input.TextInputPrompt;
import guise.platform.AbsPlatformAccess;
import guise.platform.html.display.DomContainerTrait;
import guise.platform.html.display.DomElementTrait;
import guise.platform.html.display.DomDocumentTrait;
import guise.platform.html.display.TextInputTrait;
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
import js.Dom;
import js.Lib;
import guise.platform.html.display.ButtonElementTrait;
import guise.platform.html.display.WindowTrait;
import guise.traits.tags.ControlTags;

/**
 * ...
 * @author Tom Byrne
 */

 
class HtmlPlatformAccess extends AbsPlatformAccess<ContInfo, LayerInfo>
{
	public static function install(within:ComposeItem) {
		within.addTrait(new Furnisher(WindowTag,	[TType(WindowTrait)]));
		within.addTrait(new Furnisher(StageTag,		[TType(DomDocumentTrait)]));
		within.addTrait(new Furnisher(TextButtonTag,	[TType(ButtonElementTrait)]));
		within.addTrait(new Furnisher(TextInputTag,	[TType(TextInputTrait), TType(TextInputPrompt)]));
		within.addTrait(new HtmlPlatformAccess());
	}
	
	
	public function new() 
	{
		super(ContInfo.create, ContInfo.destroy, LayerInfo.create, LayerInfo.destroy);
		
		registerAccess(MouseClickable, [IMouseClickable], getMouseClickAccess, returnMouseClickAccess);
		
		registerLayerAccess(MouseClickable, [IMouseClickable], getMouseClickLayerAccess, returnMouseClickLayerAccess);
	}
	private function getMouseClickAccess(cont:ContInfo):MouseClickable {
		return new MouseClickable(cont.container);
	}
	private function returnMouseClickAccess(cont:ContInfo, access:MouseClickable):Void {
		access.domElement = null;
	}
	
	private function getMouseClickLayerAccess(layer:LayerInfo):MouseClickable {
		layer.createContainer();
		return new MouseClickable(layer.container);
	}
	private function returnMouseClickLayerAccess(layer:LayerInfo, access:MouseClickable):Void {
		access.domElement = null;
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
	
	private var _contSkin:DomContainerTrait;
	
	public var container:HtmlDom;
	
	public function new(context:ComposeItem){
		//super();
		
		this.context = context;
		container = Lib.document.createElement("div");
		
		_contSkin = new DomContainerTrait(container);
		context.addTrait(_contSkin);
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
		if (contInfo != null) {
			if (container != null) contInfo.container.removeChild(container);
		}
		contInfo = value;
		if (contInfo != null) {
			if (container != null) contInfo.container.appendChild(container);
		}
		return value;
	}
	
	public var layerName:String;
	public var container:HtmlDom;
	
	public function new(contInfo:ContInfo, layerName:String) 
	{
		//super();
		this.contInfo = contInfo;
		this.layerName = layerName;
	}
	
	public function createContainer():Void {
		if (container == null) {
			container = Lib.document.createElement("div");
			container.id = layerName;
			
			if(contInfo!=null)contInfo.container.appendChild(container);
		}
	}
}