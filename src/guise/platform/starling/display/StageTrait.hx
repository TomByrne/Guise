package guise.platform.starling.display;
import guise.platform.starling.display.ContainerTrait;
import starling.core.Starling;
import starling.display.Stage;
import starling.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import starling.events.Event;
import msignal.Signal;
import guise.skin.bitmap.utils.TexturePack;


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
	private var texturePack(default, set):TexturePack;
	private function set_texturePack(value:TexturePack):TexturePack {
		this.texturePack = value;
		
		if(texturePack!=null){
			if (_stage != null) texturePack.contextReady();
		}
		return value;
	}
	
	public var stage(get, null):Stage;
	private function get_stage():Stage {
		return _stage;
	}
	
	private var _stage:Stage;
	private var _starling:Starling;

	public function new() 
	{
		super();
		
		var stage = flash.Lib.current.stage;
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.align = StageAlign.TOP_LEFT;
		
		_starling = new Starling(Sprite, stage);
		_starling.simulateMultitouch = true;
		/*_starling.enableErrorChecking = Capabilities.isDebugger;
		_starling.showStats = true;*/
		_starling.addEventListener(Event.ROOT_CREATED, onRootCreated);
		_starling.start();
	}
	override private function assumeDisplayObject():Void {
		// ignore
	}
	
	private function onRootCreated(e:Event):Void {
		_stage = cast _starling.stage;
		setContainer(_stage);
		if (texturePack != null) texturePack.contextReady();
	}
}