package guise.platform.html;
import composure.core.ComposeItem;
import guise.controls.ControlLayers;
import guise.controls.logic.input.TextInputPrompt;
import guise.platform.AbsPlatformAccess;
import guise.platform.html.display.DomContainerTrait;
import guise.platform.html.display.DomElementTrait;
import guise.platform.html.display.DomDocumentTrait;
import guise.platform.html.display.InputFocusTrait;
import guise.platform.html.display.TextLabelTrait;
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
		within.addTrait(new HtmlPlatformAccess());
	}
	
	private static var _window:WindowTrait;
	private static var _document:DomDocumentTrait;
	
	public function new() 
	{
		super(ContInfo.create, ContInfo.destroy, LayerInfo.create, LayerInfo.destroy);
		
		addSiblingTrait(new Furnisher(WindowTag,	[TFact(getWindow)]));
		
		addContainerFurnisher(StageTag, createDocument);
		addContainerFurnisher(TextButtonTag, createTextButton);
		addContainerFurnisher(TextLabelTag, createTextLabel);
		addContainerFurnisher(TextInputTag, createTextInput);
		
		registerAccess(MouseClickable, [IMouseClickable], getMouseClickAccess, returnMouseClickAccess);
		
		registerLayerAccess(MouseClickable, [IMouseClickable], getMouseClickLayerAccess, returnMouseClickLayerAccess);
	}
	private function getWindow(tag:CoreTags):WindowTrait {
		if (_window==null) {
			_window = new WindowTrait();
		}
		return _window;
	}
	private function createDocument(cont:ContInfo, tag:CoreTags):Array<Dynamic> {
		cont.elementType = "body";
		return null;
	}
	private function createTextButton(cont:ContInfo, tag:ControlTags):Array<Dynamic> {
		cont.elementType = "button";
		cont.trait.setAllowSizing(true);
		return [new ButtonElementTrait(cont.domElement)];
	}
	private function createTextLabel(cont:ContInfo, tag:ControlTags):Array<Dynamic> {
		cont.elementType = "label";
		cont.trait.setAllowSizing(true);
		return [new TextLabelTrait(cont.domElement)];
	}
	private function createTextInput(cont:ContInfo, tag:ControlTags):Array<Dynamic> {
		cont.elementType = "input";
		cont.domElement.setAttribute("type", "text");
		cont.trait.setAllowSizing(true);
		return [new TextLabelTrait(cont.domElement), new InputFocusTrait(cont.domElement), new TextInputPrompt()];
	}
	private function getMouseClickAccess(cont:ContInfo):MouseClickable {
		return new MouseClickable(cont.domElement);
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
	
	
	public var elementType(default, set_elementType):String;
	private function set_elementType(value:String):String {
		elementType = value;
		
		if(_contSkin!=null){
			context.removeTrait(_contSkin);
			_contSkin = null;
		}
		
		if (value != null) {
			var elem:HtmlDom;
			if (value == "body") {
				elem = Lib.document.body;
			}else {
				elem = Lib.document.createElement(value);
			}
			_contSkin = new DomContainerTrait(elem);
			context.addTrait(_contSkin);
		}
		
		return value;
	}
	public var domElement(get_domElement, null):HtmlDom;
	private function get_domElement():HtmlDom {
		return _contSkin.domElement;
	}
	public var trait(get_trait, null):DomContainerTrait;
	private function get_trait():DomContainerTrait {
		return _contSkin;
	}
	
	
	private var _contSkin:DomContainerTrait;
	
	public function new(context:ComposeItem=null, elementType:String="div"){
		//super();
		
		this.context = context;
		this.elementType = elementType;
		
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
			if (container != null) contInfo.domElement.removeChild(container);
		}
		contInfo = value;
		if (contInfo != null) {
			if (container != null) contInfo.domElement.appendChild(container);
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
			
			if(contInfo!=null)contInfo.domElement.appendChild(container);
		}
	}
}