package guise.platform.waxe;
import wx.Button;
import composure.core.ComposeItem;
import guise.controls.ControlLayers;
import guise.controls.logic.input.TextInputPrompt;
import guise.platform.AbsPlatformAccess;
import guise.platform.waxe.display.ContainerTrait;
import guise.platform.waxe.display.DisplayTrait;
import guise.platform.waxe.display.StageTrait;
//import guise.platform.waxe.display.InputFocusTrait;
//import guise.platform.waxe.display.TextLabelTrait;
//import guise.platform.waxe.input.MouseClickable;
import guise.platform.IPlatformAccess;
import guise.platform.types.TextAccessTypes;
import guise.platform.types.DisplayAccessTypes;
import guise.platform.types.CoreAccessTypes;
import guise.platform.types.DrawingAccessTypes;
import guise.platform.types.InteractionAccessTypes;
import cmtc.ds.hash.ObjectHash;
import guise.core.CoreTags;
import composure.utilTraits.Furnisher;
import guise.platform.nme.core.FrameTicker;
import guise.platform.waxe.display.TextButtonTrait;
import guise.platform.waxe.display.WindowTrait;
import guise.controls.ControlTags;

/**
 * ...
 * @author Tom Byrne
 */

 
class WaxePlatformAccess extends AbsPlatformAccess<ContInfo, LayerInfo>
{
	public static function install(within:ComposeItem) {
		within.addTrait(new WaxePlatformAccess());
	}
	
	private static var _window:WindowTrait;
	private static var _stage:StageTrait;
	
	public function new() 
	{
		super(ContInfo.create, ContInfo.destroy, LayerInfo.create, LayerInfo.destroy);
		
		addSiblingTrait(new Furnisher(WindowTag,	[TFact(getWindow)]));
		
		addContainerFurnisher(StageTag, createDocument);
		addContainerFurnisher(TextButtonTag, createTextButton);
		//addContainerFurnisher(TextLabelTag, createTextLabel);
		//addContainerFurnisher(TextInputTag, createTextInput);
		
		//registerAccess(MouseClickable, [IMouseClickable], getMouseClickAccess, returnMouseClickAccess);
		
		//registerLayerAccess(MouseClickable, [IMouseClickable], getMouseClickLayerAccess, returnMouseClickLayerAccess);
	}
	private function getWindow(tag:CoreTags):WindowTrait {
		if (_window==null)_window = new WindowTrait();
		return _window;
	}
	private function createDocument(cont:ContInfo, tag:CoreTags):Array<Dynamic> {
		if (_stage==null)_stage = new StageTrait();
		return [_stage];
	}
	private function createTextButton(cont:ContInfo, tag:ControlTags):Array<Dynamic> {
		var buttonTrait:TextButtonTrait = new TextButtonTrait();
		cont.addDisplayAware(buttonTrait);
		cont.displayFactory = Button.create;
		cont.trait.setAllowSizing(true);
		return [buttonTrait];
	}
	private function destroyTextButton(cont:ContInfo, tag:ControlTags, traits:Array<Dynamic>):Void {
		var buttonTrait:TextButtonTrait = cast traits[0];
		cont.removeDisplayAware(buttonTrait);
	}
	/*private function createTextLabel(cont:ContInfo, tag:ControlTags):Array<Dynamic> {
		cont.elementType = "label";
		cont.trait.setAllowSizing(true);
		return [new TextLabelTrait(cont.domElement)];
	}
	private function createTextInput(cont:ContInfo, tag:ControlTags):Array<Dynamic> {
		cont.elementType = "input";
		cont.domElement.setAttribute("type", "text");
		cont.trait.setAllowSizing(true);
		return [new TextLabelTrait(cont.domElement), new InputFocusTrait(cont.domElement), new TextInputPrompt()];
	}*/
	/*private function getMouseClickAccess(cont:ContInfo):MouseClickable {
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
	}*/
}

import wx.Window;
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
		if (context!=null) {
			context.removeTrait(_contTrait);
		}
		context = value;
		if (context!=null) {
			context.addTrait(_contTrait);
		}
		return value;
	}
	
	
	public var displayFactory(default, set_displayFactory):DisplayFactory;
	private function set_displayFactory(value:String):DisplayFactory {
		displayFactory = value;
		_contTrait.displayFactory = value;
		return value;
	}
	public var display(get_display, null):Window;
	private function get_display():Window {
		return _contTrait.display;
	}
	public var trait(get_trait, null):ContainerTrait;
	private function get_trait():ContainerTrait {
		return _contTrait;
	}
	
	
	private var _contTrait:ContainerTrait;
	
	public function new(context:ComposeItem=null){
		//super();
		_contTrait = new ContainerTrait();
		this.context = context;
	}
	
	public function addDisplayAware(displayAware:IDisplayAwareTrait):Void {
		_contTrait.addDisplayAware(displayAware);
	}
	public function removeDisplayAware(displayAware:IDisplayAwareTrait):Void {
		_contTrait.removeDisplayAware(displayAware);
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
			//if (container != null) contInfo.domElement.removeChild(container);
		}
		contInfo = value;
		if (contInfo != null) {
			//if (container != null) contInfo.domElement.appendChild(container);
		}
		return value;
	}
	
	public var layerName:String;
	public var container:Window;
	
	public function new(contInfo:ContInfo, layerName:String) 
	{
		//super();
		this.contInfo = contInfo;
		this.layerName = layerName;
	}
	
	public function createContainer():Void {
		throw "Hm";
		/*if (container == null) {
			container = Lib.document.createElement("div");
			container.id = layerName;
			
			if(contInfo!=null)contInfo.domElement.appendChild(container);
		}*/
	}
}