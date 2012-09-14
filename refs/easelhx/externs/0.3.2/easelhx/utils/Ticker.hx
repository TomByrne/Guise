/**
* Bitmap by Grant Skinner. Dec 5, 2010
* Visit www.gskinner.com/blog for documentation, updates and more free code.
*
*
* Copyright (c) 2010 Grant Skinner
* 
* Permission is hereby granted, free of charge, to any person
* obtaining a copy of this software and associated documentation
* files (the "Software"), to deal in the Software without
* restriction, including without limitation the rights to use,
* copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the
* Software is furnished to do so, subject to the following
* conditions:
* 
* The above copyright notice and this permission notice shall be
* included in all copies or substantial portions of the Software.
* 
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
* EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
* OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
* NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
* HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
* FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
* OTHER DEALINGS IN THE SOFTWARE.
**/
package easelhx.utils;

@:native("Ticker")
extern class Ticker {

// constructor:
	/**
	* The Tick class uses a static interface (ex. Tick.getPaused()) and should not be instantiated.
	* @class Provides a centralized tick or heartbeat. Listeners can subscribe to the tick, and identify whether they are pausable or not.
	**/
	//function Tick() {
	//	throw "Tick cannot be instantiated.";
	//}
	
// public static methods:
	/**
	* Adds a listener to the tick. The listener object must expose a .tick() method, which will be called once each tick. 
	* The exposed tick method can optionally accept a single parameter, which will include the elapsed time between the previous 
	* tick and the current one.
	* @param o The object to add as a listener.
	* @param pausable If false, the listener will continue to have tick called even when Tick is paused via Tick.pause(). Default is false.
	* @static
	**/
	public static function addListener( o : Dynamic, ?pauseable : Bool ) : Void;
	
	/**
	* Removes the specified listener.
	* @param o The listener to remove.
	* @static
	**/
	public static function removeListener( o : Dynamic ) : Void;
	
	/**
	* Removes all listeners.
	* @static
	**/
	public static function removeAllListeners() : Void;
	
	/**
	* Sets the time (in milliseconds) between ticks. Default is 50 (20 FPS).
	* @param interval Time in milliseconds between ticks.
	* @static
	**/
	public static function setInterval( interval : Int ) : Void;
	
	/**
	* Returns the current time between ticks, as set with setInterval.
	* @static
	**/
	public static function getInterval() : Int;
	
	/**
	* Returns the frame rate in frames per second (FPS). For example, with an interval of 40, getFPS() will return 25 (1000ms 
	* per second divided by 40 ms per tick = 25fps).
	* @static
	**/
	public static function getFPS() : Float;
	
	/**
	* Sets the target frame rate in frames per second (FPS). For example, with an interval of 40, getFPS() will 
	* return 25 (1000ms per second divided by 40 ms per tick = 25fps).
	* @method setFPS
	* @static
	* @param {Number} value Target number of ticks broadcast per second.
	**/	
	public static function setFPS(value:Float) : Void;
	
	/**
	* Returns the actual frames / ticks per second.
	* @method getMeasuredFPS
	* @static
	* @param {Number} ticks Optional. The number of previous ticks over which to measure the actual 
	* frames / ticks per second.
	* @return {Number} The actual frames / ticks per second. Depending on performance, this may differ
	* from the target frames per second.
	**/
	public static function getMeasuredFPS(ticks:Float) : Float;
	
	/**
	* While Tick is paused, pausable listeners are not ticked. See addListener for more information.
	* @param value Indicates whether to pause (true) or unpause (false) Tick.
	* @static
	**/
	public static function setPaused( value : Bool ) : Void;
	
	/**
	* Returns a boolean indicating whether Tick is currently paused, as set with setPaused.
	* @static
	**/
	public static function getPaused() : Bool;
	
	/**
	* Returns the number of milliseconds that have elapsed since Tick was loaded. For example, you could use this in a 
	* time synchronized animation to determine the exact amount of time that has elapsed.
	* @param pauseable Indicates whether to return the elapsed time for pauseable, or unpauseable listeners. If true, time that 
	* elapsed while Tick was paused is not included.
	* @static
	**/
	public static function getTime( pauseable : Bool ) : Int;
	
	/**
	* Returns the number of ticks that have elapsed while Tick was active.
	* @param pauseable Indicates whether to return the elapsed ticks for pauseable, or unpauseable listeners.
	* @static
	**/
	public static function getTicks( pauseable : Bool ) : Int;
	
}
