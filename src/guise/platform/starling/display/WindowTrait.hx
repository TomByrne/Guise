package guise.platform.starling.display;
import flash.geom.Rectangle;
import guise.core.IWindowInfo;
import guise.platform.starling.display.ContainerTrait;
import starling.core.Starling;
import starling.display.Stage;
import starling.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import starling.events.Event;
import msignal.Signal;
import guise.skin.bitmap.utils.TexturePack;


class WindowTrait extends ContainerTrait, implements IWindowInfo
{
	private static var _inst:WindowTrait;
	public static function inst():WindowTrait {
		if (_inst == null) {
			_inst = new WindowTrait();
		}
		return _inst;
	}
	
	@lazyInst
	public var availSizeChanged:Signal1<IWindowInfo>;
	
	public var availWidth(default, null):Int;
	public var availHeight(default, null):Int;
	
	@inject
	private var texturePack(default, set_texturePack):TexturePack;
	private function set_texturePack(value:TexturePack):TexturePack {
		this.texturePack = value;
		
		if(texturePack!=null){
			if (_starStage != null) texturePack.contextReady();
		}
		return value;
	}
	
	public var stage(get_stage, null):Stage;
	private function get_stage():Stage {
		return _starStage;
	}
	
	private var _flashStage:flash.display.Stage;
	private var _starStage:Stage;
	private var _starling:Starling;

	public function new() 
	{
		super();
		
		_flashStage = flash.Lib.current.stage;
		
		_flashStage.align = StageAlign.TOP_LEFT;
		_flashStage.scaleMode = StageScaleMode.NO_SCALE;
		_flashStage.addEventListener(flash.events.Event.RESIZE, onResize);
		
		_starling = new Starling(Sprite, _flashStage);
		_starling.simulateMultitouch = true;
		/*_starling.enableErrorChecking = Capabilities.isDebugger;
		_starling.showStats = true;*/
		_starling.addEventListener(Event.ROOT_CREATED, onRootCreated);
		_starling.start();
		
		setAvailSize(_flashStage.stageWidth, _flashStage.stageHeight);
	}
	override private function assumeDisplayObject():Void {
		// ignore
	}
	
	private function onRootCreated(e:Event):Void {
		_starStage = cast _starling.stage;
		setContainer(_starStage);
		if (texturePack != null) texturePack.contextReady();
		
		setViewportSize();
	}
	private function onResize(e:Dynamic):Void {
		setAvailSize(_flashStage.stageWidth, _flashStage.stageHeight);
	}
	
	private function setAvailSize(width:Int, height:Int):Void {
		if (this.availWidth != width || this.availHeight != height) {
			this.availWidth = width;
			this.availHeight = height;
			LazyInst.exec(availSizeChanged.dispatch(this));
			
			if (_starStage!=null) setViewportSize();
		}
	}
	
	private function setViewportSize():Void {
		_starling.viewPort = new Rectangle(0, 0, availWidth, availHeight);
		_starStage.stageWidth = availWidth;
		_starStage.stageHeight = availHeight;
	}
}