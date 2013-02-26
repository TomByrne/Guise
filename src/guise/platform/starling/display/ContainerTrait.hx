package guise.platform.starling.display;
import guise.platform.starling.addTypes.IDisplayObjectType;
import starling.display.DisplayObject;
import starling.display.DisplayObjectContainer;
import starling.display.Sprite;

class ContainerTrait extends DisplayTrait
{
	
	private var _layerDisplays:Array<IDisplayObjectType>;
	
	@:isVar public var container(default, null):DisplayObjectContainer;
	@:isVar public var sprite(default, null):Sprite;

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
		_layerDisplays.push(display);
		if (container != null) {
			container.addChild(display.getDisplayObject());
		}
	}
	@injectRemove
	public function removeLayer(display:IDisplayObjectType):Void {
		_layerDisplays.remove(display);
		if (container != null) {
			container.removeChild(display.getDisplayObject());
		}
	}
}