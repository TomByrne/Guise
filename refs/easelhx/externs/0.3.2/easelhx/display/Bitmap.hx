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

@:native("Bitmap")
extern class Bitmap extends DisplayObject {
	
// public properties:
	/** The image to render. This can be an Image, a Canvas, or a Video. **/
	public var image( default, default ) : Dynamic;
	
// constructor:
	/**
	* Constructs a Bitmap object with the specified source image.
	* @param image The Image, Canvas, or Video to render to the display list.
	* @class A Bitmap represents an Image, Canvas, or Video in the display list.
	* @augments DisplayObject
	**/
	public function new( image : Dynamic ) : Void;
	
	/**
	* Returns true or false indicating whether the display object would be visible if drawn to a canvas.
	* This does not account for whether it would be visible within the boundaries of the stage.
	* NOTE: This method is mainly for internal use, though it may be useful for advanced uses.
	* @method isVisible
	* @return {Boolean} Boolean indicating whether the display object would be visible if drawn to a canvas
	**/
	override public function isVisible() : Bool;
	
	/**
	* Whether or not the Bitmap should be draw to the canvas at whole pixel coordinates.
	* @property snapToPixel
	* @type Boolean
	* @default true
	**/
	override public var snapToPixel( default, default ) : Bool;
	
// public methods:
	/** @borrows DisplayObject#draw as this.draw **/
	override public function draw( ctx : Dynamic, ignoreCache : Bool ) : Bool;
	
	/**
	* Because the content of a Bitmap is already in a simple format, cache is unnecessary for Bitmap instances.
	**/
	//public function cache() : Void;
	override public function cache( x : Float, y : Float, w : Float, h : Float ) : Void;
	
	/**
	* Because the content of a Bitmap is already in a simple format, cache is unnecessary for Bitmap instances.
	**/
	override public function uncache() : Void;
	
	override public function clone() : DisplayObject;
	
	override public function toString() : String;
	
}
