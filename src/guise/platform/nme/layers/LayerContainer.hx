package guise.platform.nme.layers;

import flash.text.TextField;
import guise.layout.IDisplayPosition;
import guise.platform.cross.display.AbsDisplayTrait;
import guise.platform.nme.display.FilterableAccess;
import guise.platform.nme.display.GraphicsAccess;
import guise.platform.nme.display.PositionAccess;
import guise.platform.nme.input.TextAccess;
import guise.platform.types.TextAccessTypes;
import guise.styledLayers.IDisplayLayer;
import guise.styledLayers.IGraphicsLayer;
import guise.styledLayers.ITextLayer;
import guise.platform.nme.display.ContainerTrait;
import nme.display.DisplayObject;
import nme.display.Shape;
import cmtc.ds.hash.ObjectHash;
import guise.platform.types.DisplayAccessTypes;
import msignal.Signal;

/**
 * ...
 * @author Tom Byrne
 */

class LayerContainer extends AbsDisplayTrait, implements ILayerOrderAccess
{
	@lazyInst
	public var layeringChanged(default, null):Signal1<ILayerOrderAccess>;
	
	
	@inject
	public var container(default, set_container):ContainerTrait;
	private function set_container(value:ContainerTrait):ContainerTrait {
		
		if (container != null) {
			for (bundle in _layerBundles) {
				container.container.removeChild(bundle.display);
			}
		}
		
		this.container = value;
		
		if (container != null) {
			for (bundle in _layerBundles) {
				container.container.addChild(bundle.display);
			}
		}
		
		return value;
	}
	
	public var layers(default, null):Array<String>;
	
	private var _layerBundles:Array<LayerBundle>;
	private var _layerToBundle:ObjectHash<IDisplayLayer, LayerBundle>;
	private var _graphLayers:Array<IGraphicsLayer>;
	private var _textLayers:Array<ITextLayer>;

	public function new() 
	{
		super();
		_sizeListen = true;
		
		_layerToBundle = new ObjectHash();
		layers = [];
		_layerBundles = [];
		_graphLayers = [];
		_textLayers = [];
	}
	
	@injectAdd
	public function onGraphLayerAdd(layer:IGraphicsLayer):Void {
		var display:Shape = new Shape();
		layer.filterAccess = new FilterableAccess(display);
		layer.graphicsAccess = new GraphicsAccess(display.graphics);
		layer.positionAccess = new PositionAccess(display);
		_graphLayers.push(layer);
		attemptAddLayer(layer,display);
	}
	@injectRemove
	public function onGraphLayerRemove(layer:IGraphicsLayer):Void {
		layer.filterAccess = null;
		layer.graphicsAccess = null;
		layer.positionAccess = null;
		_graphLayers.remove(layer);
		attemptRemoveLayer(layer);
	}
	
	@injectAdd
	public function onTextLayerAdd(layer:ITextLayer):Void {
		var display:TextField = new TextField();
		layer.filterAccess = new FilterableAccess(display);
		layer.textAccess = new TextAccess(display);
		_textLayers.push(layer);
		attemptAddLayer(layer, display);
	}
	@injectRemove
	public function onTextLayerRemove(layer:ITextLayer):Void {
		layer.filterAccess = null;
		layer.textAccess = null;
		_textLayers.remove(layer);
		attemptRemoveLayer(layer);
	}
	
	
	private function attemptAddLayer(layer:IDisplayLayer, display:DisplayObject):Void {
		if (!_layerToBundle.exists(layer)) {
			var bundle = new LayerBundle(layer, display);
			_layerToBundle.set(layer, bundle);
			_layerBundles.push(bundle);
			layers.push(layer.layerName);
			LazyInst.exec(layeringChanged.dispatch(this));
			if (position!=null) {
				layer.setPosition(0, 0, position.w, position.h);
			}
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
	
	override private function onSizeChanged(from:IDisplayPosition):Void {
		for (bundle in _layerBundles) {
			bundle.layer.setPosition(0, 0, from.w, from.h);
		}
	}
	public function swapDepths(layer1:String, layer2:String):Void {
		var index1 = Lambda.indexOf(layers, layer1);
		var index2 = Lambda.indexOf(layers, layer2);
		
		layers[index1] = layer2;
		layers[index2] = layer1;
		
		var bundle1 = _layerBundles[index1];
		var bundle2 = _layerBundles[index2];
		
		_layerBundles[index1] = bundle2;
		_layerBundles[index2] = bundle1;
		
		if (container != null) {
			container.container.swapChildren(bundle1.display, bundle2.display);
		}
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