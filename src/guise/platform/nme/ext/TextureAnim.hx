package guise.platform.nme.ext;
import flash.display.Bitmap;
import nme.display.BitmapData;
import nme.events.TimerEvent;
import nme.utils.Timer;

class TextureAnim extends Bitmap
{
	private var currId:Int;
	private var textures:Array<BitmapData>;
	private var timer:Timer;

	public function new(textures:Array<BitmapData>, fps:Int) 
	{
		super();
		this.fps = fps;
		setTextures(textures);
	}
	
	@:isVar public var fps(default, set_fps):Int;
	private function set_fps(value:Int):Int {
		if (timer!=null) {
			timer.stop();
			timer = null;
		}
		this.fps = value;
		if (fps > 0) {
			timer = new Timer(1000 / fps, 0);
			timer.addEventListener(TimerEvent.TIMER, onTimer);
			if (textures!=null) timer.start();
		}
		return value;
	}
	
	public function setTextures(textures:Array<BitmapData>):Void {
		currId = 0;
		bitmapData = textures[0];
		this.textures = textures;
		if (timer != null) {
			timer.start();
		}
	}
	
	public function onTimer(e:TimerEvent):Void {
		++currId;
		if (currId >= textures.length) {
			currId = 0;
		}
		bitmapData = textures[currId];
	}
}