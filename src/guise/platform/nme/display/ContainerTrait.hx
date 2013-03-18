package guise.platform.nme.display;
import guise.accessTypes.IVisualAccessType;
import guise.platform.nme.addTypes.IDisplayObjectType;
import nme.display.DisplayObject;
import nme.display.DisplayObjectContainer;
import nme.display.Sprite;
import nme.geom.Rectangle;

using Lambda;

class ContainerTrait extends DisplayTrait
{
	
	private var _layerDisplays:Array<IDisplayObjectType>;
	
	public var childContainer(default, null):DisplayObjectContainer;
	public var container(default, null):DisplayObjectContainer;
	public var sprite(default, null):Sprite;

	public function new(container:DisplayObjectContainer = null) {
		_layerDisplays = [];
		childContainer = new Sprite();
		if (container != null)setContainer(container);
		super(container);
	}
	override private function assumeDisplayObject():Void {
		setContainer(new Sprite());
	}
	private function setContainer(container:DisplayObjectContainer):Void {
		if(this.container!=null){
			this.container.removeChild(childContainer);
			for (display in _layerDisplays) {
				this.container.removeChild(display.getDisplayObject());
			}
		}
		
		this.container = container;
		if (Std.is(container, Sprite)) this.sprite = cast container;
		else sprite = null;
		setDisplayObject(container);
		
		if (container != null) {
			container.addChild(childContainer);
			sortLayers();
		}
	}
	
	public function setChildScrollRect(rect:Rectangle):Void {
		childContainer.scrollRect = rect;
	}
	private function isLayerDisplay(display:DisplayObject):Bool{
		for (displayType in _layerDisplays) {
			if (displayType.getDisplayObject() == display) {
				return true;
			}
		}
		return false;
	}
	
	@injectAdd
	public function addLayer(display:IDisplayObjectType):Void {
		_layerDisplays.push(display);
		_layerDisplays.sort(sortLayerFunc);
		container.addChild(display.getDisplayObject());
		display.idealDepthChanged.add(onLayerDepthChange);
		if (container != null) {
			sortLayers();
		}
	}
	private function onLayerDepthChange(from:IVisualAccessType):Void {
		_layerDisplays.sort(sortLayerFunc);
		if (container != null) {
			sortLayers();
		}
	}
	private function sortLayerFunc(display1:IDisplayObjectType, display2:IDisplayObjectType):Int{
		if (display1.idealDepth < display2.idealDepth) return -1;
		else if (display1.idealDepth > display2.idealDepth) return 1;
		else return 0;
	}
	@injectRemove
	public function removeLayer(display:IDisplayObjectType):Void {
		_layerDisplays.remove(display);
		display.idealDepthChanged.remove(onLayerDepthChange);
		if (container != null) {
			container.removeChild(display.getDisplayObject());
		}
	}
	
	private function sortLayers():Void {
		container.setChildIndex(childContainer, 0);
		var containerDepth:Int = 0;
		var totalDepth:Int = 1;
		for (display in _layerDisplays) {
			var idealDepth:Int = display.idealDepth;
			var disp = display.getDisplayObject();
			if (idealDepth > 0) {
				container.setChildIndex(disp, totalDepth);
				++totalDepth;
			}else {
				container.setChildIndex(disp, containerDepth);
				++totalDepth;
				++containerDepth;
			}
		}
	}
}