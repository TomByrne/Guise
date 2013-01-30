package guise.platform.nme.layers;

import cmtc.ds.hash.ObjectHash;
import composure.core.ComposeItem;
import flash.text.TextField;
import guise.accessTypes.IAccessType;
import guise.accessTypes.IBoxPosAccess;
import guise.accessTypes.IFilterableAccess;
import guise.accessTypes.IFocusableAccess;
import guise.accessTypes.IGraphicsAccess;
import guise.accessTypes.IPositionAccess;
import guise.accessTypes.ITextInputAccess;
import guise.accessTypes.ITextOutputAccess;
import guise.layer.ILayerContainer;
import guise.layer.LayerAccessRequire;
import guise.platform.cross.AccessProvider;
import guise.platform.cross.display.AbsDisplayTrait;
import guise.platform.nme.accessTypes.AdditionalTypes;
import guise.platform.nme.display.ContainerTrait;
import guise.platform.nme.accessTypes.FilterableAccess;
import guise.platform.nme.accessTypes.GraphicsAccess;
import guise.platform.nme.accessTypes.PositionAccess;
import guise.platform.nme.accessTypes.FocusableAccess;
import guise.platform.nme.accessTypes.TextAccess;
import guise.styledLayers.IDisplayLayer;
import guise.styledLayers.IGraphicsLayer;
import guise.styledLayers.ITextLayer;
import nme.display.DisplayObject;
import nme.display.Shape;
import msignal.Signal;

class LayerContainer extends AbsDisplayTrait, implements ILayerContainer
{

	@lazyInst
	public var layeringChanged(default, null):Signal1<ILayerContainer>;
	
	
	@inject
	public var container(default, set_container):ContainerTrait;
	private function set_container(value:ContainerTrait):ContainerTrait {
		
		if (container != null) {
			for (bundle in _layerBundles) {
				container.container.removeChild(bundle.display);
			}
			for (item in _itemToLayers) {
				for (display in _itemToLayers.get(item)) {
					container.container.removeChild(display);
				}
			}
		}
		
		this.container = value;
		
		if (container != null) {
			for (bundle in _layerBundles) {
				container.container.addChild(bundle.display);
			}
			for (item in _itemToLayers) {
				for (display in _itemToLayers.get(item)) {
					container.container.addChild(display);
				}
			}
		}
		
		return value;
	}
	
	public var layers(default, null):Array<String>;
	
	private var _layerBundles:Array<LayerBundle>;
	private var _layerToBundle:ObjectHash<IDisplayLayer, LayerBundle>;
	private var _graphLayers:Array<IGraphicsLayer>;
	private var _textLayers:Array<ITextLayer>;
	
	private var _itemToLayers:ObjectHash<ComposeItem, Hash<DisplayObject>>;
	

	public function new() 
	{
		super();
		_sizeListen = true;
		_layerToBundle = new ObjectHash();
		layers = [];
		_layerBundles = [];
		_graphLayers = [];
		_textLayers = [];
		
		_itemToLayers = new ObjectHash();
		
		var accessProvider:AccessProvider = new AccessProvider(onAccessAdd, onAccessRemove);
		accessProvider.mapAccessType(IFilterableAccess, FilterableAccess);
		accessProvider.mapAccessType(IGraphicsAccess, GraphicsAccess);
		accessProvider.mapAccessType(IPositionAccess, PositionAccess);
		accessProvider.mapAccessType(IBoxPosAccess, PositionAccess);
		accessProvider.mapAccessType(ITextInputAccess, TextAccess);
		accessProvider.mapAccessType(ITextOutputAccess, TextAccess);
		accessProvider.mapAccessType(IFocusableAccess, FocusableAccess);
		addSiblingTrait(accessProvider);
	}
	public function onAccessAdd(item:ComposeItem, layerName:String, trait:Dynamic):Void {
		if (Std.is(trait, IDisplayObjectType)) {
			var castTrait:IDisplayObjectType = cast trait;
			addDisplay(item, layerName, castTrait.getDisplayObject());
		}
	}
	public function onAccessRemove(item:ComposeItem, layerName:String, trait:Dynamic):Void {
		if (Std.is(trait, IDisplayObjectType)) {
			var castTrait:IDisplayObjectType = cast trait;
			removeDisplay(item, layerName, castTrait.getDisplayObject());
		}
	}
	public function addDisplay(item:ComposeItem, layerName:String, displayObject:DisplayObject):Void {
		var layers = _itemToLayers.get(item);
		if (layers == null) {
			layers = new Hash();
			_itemToLayers.set(item, layers);
		}else if (layers.exists(layerName)) {
			throw "Item already has display layer with name " + layerName;
		}
		this.layers.push(layerName);
		layers.set(layerName, displayObject);
		LazyInst.exec(layeringChanged.dispatch(this));
		
		if (container != null) {
			container.container.addChild(displayObject);
		}
	}
	public function removeDisplay(item:ComposeItem, layerName:String, displayObject:DisplayObject):Void {
		var layers = _itemToLayers.get(item);
		if (layers.get(layerName) != displayObject) {
			return;
		}
		this.layers.remove(layerName);
		layers.remove(layerName);
		LazyInst.exec(layeringChanged.dispatch(this));
		
		if (container != null) {
			container.container.removeChild(displayObject);
		}
	}
	
	@injectAdd
	public function onGraphLayerAdd(layer:IGraphicsLayer):Void {
		var display:Shape = new Shape();
		layer.filterAccess = addAccess(new FilterableAccess(display, layer.layerName));
		layer.graphicsAccess = addAccess(new GraphicsAccess(layer.layerName, display.graphics));
		layer.positionAccess = addAccess(new PositionAccess(display, layer.layerName));
		_graphLayers.push(layer);
		attemptAddLayer(layer,display);
	}
	@injectRemove
	public function onGraphLayerRemove(layer:IGraphicsLayer):Void {
		removeSiblingTrait(layer.filterAccess);
		removeSiblingTrait(layer.graphicsAccess);
		removeSiblingTrait(layer.positionAccess);
		
		layer.filterAccess = null;
		layer.graphicsAccess = null;
		layer.positionAccess = null;
		
		_graphLayers.remove(layer);
		attemptRemoveLayer(layer);
	}
	
	/*@injectAdd
	public function onTextLayerAdd(layer:ITextLayer):Void {
		var display:TextField = new TextField();
		
		layer.filterAccess = addAccess(new FilterableAccess(display, layer.layerName));
		layer.textAccess = addAccess(new TextAccess(layer.layerName, display));
		layer.focusableAccess = addAccess(new FocusableAccess(layer.layerName, display));
		
		_textLayers.push(layer);
		attemptAddLayer(layer, display);
	}
	@injectRemove
	public function onTextLayerRemove(layer:ITextLayer):Void {
		removeSiblingTrait(layer.filterAccess);
		removeSiblingTrait(layer.textAccess);
		removeSiblingTrait(layer.focusableAccess);
		
		layer.filterAccess = null;
		layer.textAccess = null;
		layer.focusableAccess = null;
		
		_textLayers.remove(layer);
		attemptRemoveLayer(layer);
	}*/
	
	private function addAccess<T:IAccessType>(access:T):T {
		addSiblingTrait(access);
		return access;
	}
	
	private function attemptAddLayer(layer:IDisplayLayer, display:DisplayObject):Void {
		if (!_layerToBundle.exists(layer)) {
			var bundle = new LayerBundle(layer, display);
			_layerToBundle.set(layer, bundle);
			_layerBundles.push(bundle);
			layers.push(layer.layerName);
			LazyInst.exec(layeringChanged.dispatch(this));
			/*if (position!=null) {
				layer.setPosition(0, 0, position.w, position.h);
			}*/
		}else {
			throw "Layer already addded";
		}
	}
	private function attemptRemoveLayer(layer:IDisplayLayer):Void {
		var bundle:LayerBundle = _layerToBundle.get(layer);
		if (bundle != null) {
			if (container != null) {
				container.container.removeChild(bundle.display);
			}
			_layerToBundle.delete(layer);
			_layerBundles.remove(bundle);
			layers.remove(layer.layerName);
			LazyInst.exec(layeringChanged.dispatch(this));
		}else {
			throw "Layer not addded";
		}
	}
	
	/*override private function onSizeValid(w:Float, h:Float):Void {
		for (bundle in _layerBundles) {
			bundle.layer.setPosition(0, 0, w, h);
		}
	}*/
	public function swapDepths(layer1:String, layer2:String):Void {
		/*var index1 = Lambda.indexOf(layers, layer1);
		var index2 = Lambda.indexOf(layers, layer2);
		
		layers[index1] = layer2;
		layers[index2] = layer1;
		
		var bundle1 = _layerBundles[index1];
		var bundle2 = _layerBundles[index2];
		
		_layerBundles[index1] = bundle2;
		_layerBundles[index2] = bundle1;
		
		if (container != null) {
			container.container.swapChildren(bundle1.display, bundle2.display);
		}*/
	}
}
class LayerBundle {
	
	public var display:DisplayObject;
	public var layer:IDisplayLayer;
	
	public function new(layer:IDisplayLayer, display:DisplayObject) {
		this.layer = layer;
		this.display = display;
	}
}