package guise.platform.nme.layers;

import flash.text.TextField;
import guise.layout.IDisplayPosition;
import guise.platform.cross.display.AbsDisplayTrait;
import guise.platform.nme.display.FilterableAccess;
import guise.platform.nme.display.GraphicsAccess;
import guise.platform.nme.input.TextAccess;
import guise.platform.types.TextAccessTypes;
import guise.styledLayers.IDisplayLayer;
import guise.styledLayers.IGraphicsLayer;
import guise.styledLayers.ITextLayer;
import guise.platform.nme.display.ContainerTrait;
import nme.display.DisplayObject;
import nme.display.Shape;
import cmtc.ds.hash.ObjectHash;

/**
 * ...
 * @author Tom Byrne
 */

class LayerContainer extends AbsDisplayTrait
{
	@inject
	public var container(default, set_container):ContainerTrait;
	private function set_container(value:ContainerTrait):ContainerTrait {
		
		if (container != null) {
			for (bundle in _layers) {
				container.container.removeChild(bundle.display);
			}
		}
		
		this.container = value;
		
		if (container != null) {
			for (bundle in _layers) {
				container.container.addChild(bundle.display);
			}
		}
		
		return value;
	}
	
	private var _layers:Array<LayerBundle>;
	private var _layerToBundle:ObjectHash<IDisplayLayer, LayerBundle>;
	private var _graphLayers:Array<IGraphicsLayer>;
	private var _textLayers:Array<ITextLayer>;

	public function new() 
	{
		super();
		_sizeListen = true;
		
		_layerToBundle = new ObjectHash();
		_layers = [];
		_graphLayers = [];
		_textLayers = [];
	}
	
	@injectAdd
	public function onGraphLayerAdd(layer:IGraphicsLayer):Void {
		var display:Shape = new Shape();
		layer.filterAccess = new FilterableAccess(display);
		layer.graphicsAccess = new GraphicsAccess(display.graphics);
		_graphLayers.push(layer);
		attemptAddLayer(layer,display);
	}
	@injectRemove
	public function onGraphLayerRemove(layer:IGraphicsLayer):Void {
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
		_textLayers.remove(layer);
		attemptRemoveLayer(layer);
	}
	
	
	private function attemptAddLayer(layer:IDisplayLayer, display:DisplayObject):Void {
		if (!_layerToBundle.exists(layer)) {
			var bundle = new LayerBundle(layer, display);
			_layerToBundle.set(layer, bundle);
			_layers.push(bundle);
			//sortLayers();
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
			if (position!=null) {
				layer.setPosition(0, 0, position.width, position.height);
			}
			_layerToBundle.delete(layer);
			_layers.remove(bundle);
		}else {
			throw "Layer not addded";
		}
	}
	
	override private function onSizeChanged(from:IDisplayPosition):Void {
		for (bundle in _layers) {
			bundle.layer.setPosition(0, 0, from.width, from.height);
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