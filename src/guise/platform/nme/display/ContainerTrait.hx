package guise.platform.nme.display;
import guise.platform.nme.addTypes.IDisplayObjectType;
import nme.display.DisplayObject;
import nme.display.DisplayObjectContainer;
import nme.display.Sprite;

class ContainerTrait extends DisplayTrait
{
	
	private var _layerDisplays:Array<IDisplayObjectType>;
	
	public var container(default, null):DisplayObjectContainer;
	public var sprite(default, null):Sprite;

	public function new(container:DisplayObjectContainer = null) {
		_layerDisplays = [];
		if (container != null)setContainer(container);
		super(container);
	}
	override private function assumeDisplayObject():Void {
		setContainer(new Sprite());
	}
	private function setContainer(container:DisplayObjectContainer):Void {
		if(container!=null){
			for (disp in _layerDisplays) {
				container.removeChild(disp.getDisplayObject());
			}
		}
		
		this.container = container;
		if (Std.is(container, Sprite)) this.sprite = cast container;
		else sprite = null;
		setDisplayObject(container);
		
		if (container != null) {
			for (disp in _layerDisplays) {
				container.addChild(disp.getDisplayObject());
			}
		}
	}
	
	
	@injectAdd
	public function addLayer(display:IDisplayObjectType):Void {
		//layers.push(layerName);
		_layerDisplays.push(display);
		if (container != null) {
			container.addChild(display.getDisplayObject());
		}
		//LazyInst.exec(layeringChanged.dispatch(this));
	}
	@injectRemove
	public function removeLayer(display:IDisplayObjectType):Void {
		//layers.remove(layerName);
		_layerDisplays.remove(display);
		if (container != null) {
			container.removeChild(display.getDisplayObject());
		}
		//LazyInst.exec(layeringChanged.dispatch(this));
	}
}