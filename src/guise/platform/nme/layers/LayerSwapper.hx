package guise.platform.nme.layers;
import composure.traits.AbstractTrait;
import guise.layer.ILayerContainer;
import guise.platform.nme.display.ContainerTrait;
import msignal.Signal;
import nme.events.Event;
import nme.display.DisplayObject;


class LayerSwapper extends AbstractTrait, implements ILayerContainer
{
	@lazyInst
	public var layeringChanged(default, null):Signal1<ILayerContainer>;
	
	
	@inject
	public var container(default, set_container):ContainerTrait;
	private function set_container(value:ContainerTrait):ContainerTrait {
		
		if (container != null) {
			container.container.removeEventListener(Event.ADDED, onChildAdded);
			container.container.removeEventListener(Event.REMOVED, onChildRemoved);
		}
		
		this.container = value;
		
		if (container != null) {
			container.container.addEventListener(Event.ADDED, onChildAdded);
			container.container.addEventListener(Event.REMOVED, onChildRemoved);
			
			_layersInvalid = true;
			LazyInst.exec(layeringChanged.dispatch(this));
		}
		
		return value;
	}
	
	
	private var _layers:Array<String>;
	private var _layersInvalid:Bool;

	public function new() {
		super();
	}
	
	private function onChildAdded(e:Event):Void {
		var child:DisplayObject = (cast e.target);
		if (child.parent == container.container) {
			_layersInvalid = true;
			LazyInst.exec(layeringChanged.dispatch(this));
		}
	}
	private function onChildRemoved(e:Event):Void {
		var child:DisplayObject = (cast e.target);
		if (child.parent == container.container) {
			_layersInvalid = true;
			LazyInst.exec(layeringChanged.dispatch(this));
		}
	}
	
	public function getLayers():Array<String> {
		if (_layersInvalid) {
			_layers = [];
			if (container!=null) {
				for (i in 0 ... container.container.numChildren) {
					var child:DisplayObject = container.container.getChildAt(i);
					if (child.name!=null) {
						_layers.push(child.name);
					}
				}
			}
			
			_layersInvalid = false;
		}
		return _layers;
	}
	public function swapDepths(layer1:String, layer2:String):Void {
		var index1 = Lambda.indexOf(_layers, layer1);
		var index2 = Lambda.indexOf(_layers, layer2);
		
		_layers[index1] = layer2;
		_layers[index2] = layer1;
		
		var disp1 = container.container.getChildByName(layer1);
		var disp2 = container.container.getChildByName(layer2);
		
		if (container != null) {
			container.container.swapChildren(disp1, disp2);
		}
	}
}