package guise.platform.tilelayer.display;
import aze.display.TileLayer;
import guise.skin.bitmap.utils.TexturePack;
import nme.display.Stage;
import nme.display.StageAlign;
import nme.display.StageScaleMode;
import nme.events.Event;


class StageTrait extends ContainerTrait
{
	private static var _inst:StageTrait;
	public static function inst():StageTrait {
		if (_inst == null) {
			_inst = new StageTrait();
		}
		return _inst;
	}
	
	@inject
	private var texturePack(default, set_texturePack):TexturePack;
	private function set_texturePack(value:TexturePack):TexturePack {
		if(texturePack!=null){
			_stage.removeChild(_layer.view);
			_layer = null;
			setDisplayObject(null);
		}
		
		this.texturePack = value;
		
		if (texturePack != null) {
			texturePack.contextReady();
			_layer = new TileLayer(value.pack);
			_stage.addChild(_layer.view);
			setContainer(_layer);
			
			/*var sprite = new aze.display.TileClip("Runner", 32);
			sprite.x = 300;
			sprite.y = 300;
			sprite.play();
			_layer.addChild(sprite);*/
		}
		return value;
	}
	
	public var stage(get_stage, null):Stage;
	private function get_stage():Stage {
		return _stage;
	}
	
	private var _stage:Stage;
	private var _layer:TileLayer;

	public function new() 
	{
		_stage = nme.Lib.stage;
		super();
		
		_stage.align = StageAlign.TOP_LEFT;
		_stage.scaleMode = StageScaleMode.NO_SCALE;
		_stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
	}
	override private function assumeDisplayObject():Void {
		//ignore
	}
	
	private function onEnterFrame(e:Event):Void {
		_layer.render();
	}
}