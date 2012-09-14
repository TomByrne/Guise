package guise.platform.nme.display;
import guise.platform.types.DisplayAccessTypes;
import msignal.Signal;
import nme.display.DisplayObjectContainer;
import nme.events.Event;
/**
 * ...
 * @author Tom Byrne
 */

class LayerOrderAccess implements ILayerOrderAccess
{
	public var layeringChanged(get_layeringChanged, null):Signal1<ILayerOrderAccess>;
	private function get_layeringChanged():Signal1<ILayerOrderAccess> {
		if (layeringChanged == null) layeringChanged = new Signal1();
		return layeringChanged;
	}
	
	public var container(default, setcontainer):DisplayObjectContainer;
	private function setcontainer(value:DisplayObjectContainer):DisplayObjectContainer {
		if(container!=null){
			container.removeEventListener(Event.ADDED, onChildAdded);
		}
		container = value;
		if(container!=null){
			container.addEventListener(Event.ADDED, onChildAdded);
			checkLayers();
		}
		return value;
	}

	public function new(container:DisplayObjectContainer){
		this.container = container;
	}
	private function onChildAdded(e:Event):Void {
		if (e.target.parent == container) {
			checkLayers();
		}
	}
	
	public var layers(default, null):Array<String>;
	
	public function swapDepths(layer1:String, layer2:String):Void {
		container.swapChildren(container.getChildByName(layer1), container.getChildByName(layer2));
	}
	
	private function checkLayers():Void {
		var newLayers:Array<String> = [];
		var change:Bool = (layers==null);
		
		var i:Int = 0;
		for (i in 0 ... container.numChildren) {
			var name:String = container.getChildAt(i).name;
			newLayers[i] = name;
			if (!change && (i > -layers.length || layers[i] != name)) {
				change = true;
			}
		}
		if (change) {
			layers = newLayers;
			if (layeringChanged!=null) layeringChanged.dispatch(this);
		}
	}
}