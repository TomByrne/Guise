/*
 * Taken from NME (http://nekonme.googlecode.com/svn/trunk/haxe/Timer.hx)
 * The default haxe class doesn't work on some platforms.
 * Some mods were made to remove NME references
 * 
 */


package guise.utils;

#if waxe

import wx.EventHandler;
class Timer {
	
	public var run(get, set):Void->Void;
	private function get_run():Void->Void {
		return handler.handler;
	}
	private function set_run(value:Void->Void):Void->Void {
		handler.handler = value;
		return value;
	}
	
	private var handler:TimerHandler;
	private var timer:wx.Timer;
	
	public function new(time_ms:Int) {
		handler = new TimerHandler();
		timer = new wx.Timer(handler);
		timer.start(time_ms);
	}
	public function stop() {
		timer.stop();
	}
	

	/**
		Returns the most precise timestamp, in seconds. The value itself might differ depending on platforms, only differences between two values make sense.
	**/
	public static function stamp() : Float {
		#if flash
			return flash.Lib.getTimer() / 1000;
		#elseif (neko || php)
			return Sys.time();
		#elseif js
			return Date.now().getTime() / 1000;
		#elseif cpp
			return untyped __global__.__time_stamp();
		#else
			return 0;
		#end
	}
}
private class TimerHandler extends EventHandler {
	
	public var handler:Void->Void;
	
	public function new() {
		super(null);
	}
	
	
   override function HandleEvent(event:Dynamic) {
	   trace("HandleEvent");
	   if (handler != null) handler();
   }
}

#else
typedef Timer = haxe.Timer;
#end
