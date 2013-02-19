package guise.platform.tilelayer.display;
import aze.display.TileGroup;
import guise.platform.tilelayer.addTypes.ITileBaseType;

class ContainerTrait extends DisplayTrait
{
	
	private var _layerDisplays:Array<ITileBaseType>;
	
	public var container(default, null):TileGroup;

	public function new(container:TileGroup = null) {
		_layerDisplays = [];
		if (container != null)setContainer(container);
		super(container);
	}
	override private function assumeDisplayObject():Void {
		setContainer(new TileGroup());
		
	}
	private function setContainer(container:TileGroup):Void {
		if(container!=null){
			for (disp in _layerDisplays) {
				container.removeChild(disp.getTileBase());
			}
		}
		
		this.container = container;
		setDisplayObject(container);
		
		if (container != null) {
			for (disp in _layerDisplays) {
				container.addChild(disp.getTileBase());
			}
		}
	}
	
	
	@injectAdd
	public function addLayer(display:ITileBaseType):Void {
		_layerDisplays.push(display);
		if (container != null) {
			container.addChild(display.getTileBase());
		}
	}
	@injectRemove
	public function removeLayer(display:ITileBaseType):Void {
		_layerDisplays.remove(display);
		if (container != null) {
			container.removeChild(display.getTileBase());
		}
	}
}