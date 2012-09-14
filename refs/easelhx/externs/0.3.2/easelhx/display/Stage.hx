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
package easelhx.display;

import js.DomCanvas;

@:native("Stage")
extern class Stage extends Container {

// public properties:
	/** Indicates whether the stage should automatically clear the canvas before each render. You can set this to false 
	* to manually control clearing (for generative art, or when pointing multiple stages at the same canvas for example). **/
	public var autoClear( default, default ) : Bool;
	
	/** The canvas the stage will render to. Multiple stages can share a single canvas, but you must disable autoClear for all 
	* but the first stage that will be ticked (or they will clear each other's render). **/
	public var canvas( default, default ) : DomCanvas;
	
	public var mouseX( default, default ) : Float;
	public var mouseY( default, default ) : Float;

// constructor:
	/**
	* Constructs a Stage object with the specified target canvas.
	* @param canvas The canvas the stage will render to.
	* @class A stage is the root level Container for a display list. Each time its tick method is called, it will render 
	* its display list to its target canvas.
	* @augments Container
	**/
	public function new( canvas : DomCanvas ) : Void;
	
// public methods:
	/**
	* Each time tick is called, the stage will render its entire display list to the canvas.
	**/
	public function tick() : Void;
	
	/**
	* Clears the target canvas. Useful if autoClear is set to false.
	**/
	public function clear() : Void;
	
	/**
	* Returns an array of all display objects under the specified canvas coordinates that are in this stage's display 
	* list. This routine ignores any display objects with mouseEnabled set to false (the default) or that are inside 
	* containers with mouseChildren set to false (the default). The array will be sorted in order of visual depth, with the 
	* top-most display object at index 0. This uses shape based hit detection, and can be an expensive operation to 
	* run, so it is best to use it carefully. For example, if testing for objects under the mouse, test on tick 
	* (instead of on mousemove), and only if the mouse's position has changed.
	* @param x The x coordinate to test.
	* @param y The y coordinate to test.
	**/
	override public function getObjectsUnderPoint( x : Float, y : Float ) : Array<DisplayObject>;
	
	/**
	* Similar to getObjectsUnderPoint(), but returns only the top-most display object. This runs significantly faster 
	* than getObjectsUnderPoint(), but is still an expensive operation. See getObjectsUnderPoint() for more information.
	* @param x The x coordinate to test.
	* @param y The y coordinate to test.
	**/
	override public function getObjectUnderPoint( x : Float, y : Float ) : DisplayObject;
	
	/**
	* Enables or disables (by passing a frequency of 0) mouse over handlers (onMouseOver and onMouseOut) for this stage's display
	* list. These events can be expensive to generate, so they are disabled by default, and the frequency of the events
	* can be controlled independently of mouse move events via the frequency parameter.
	* @method enableMouseOver
	* @param {Number} frequency The maximum number of times per second to broadcast mouse over/out events. Set to 0 to disable mouse
	* over events completely. Maximum is 50. A lower frequency is less responsive, but uses less CPU.
	**/
	public function enableMouseOver(frequency:Float) : Void;
	
	override public function clone() : DisplayObject;
		
	override public function toString() : String;
	
}
