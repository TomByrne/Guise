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

@:native("BitmapSequence")
extern class BitmapSequence extends DisplayObject {

// public properties:
	/** Specifies a funciton to call whenever any sequence reaches its end. **/
	//TODO: fix this - haXe keyword issue
	//public var callback( default, default ) : Dynamic;
	
	/** The frame that will be drawn on the next tick. This can also be set, but it will not update the current sequence, so 
	* it may result in unexpected behaviour if you are using frameData. **/
	public var currentFrame( default, default ) : Int;
	
	/** Returns the currently playing sequence when using frameData. READ-ONLY. **/
	public var currentSequence( default, null ) : BitmapSequence;
	
	/** Returns the last frame of the currently playing sequence when using frameData. READ-ONLY. **/
	public var currentEndFrame( default, null ) : Int;
	
	/** Returns the first frame of the currently playing sequence when using frameData. READ-ONLY. **/
	public var currentStartFrame( default, null ) : Int;
	
	/** Returns the name of the next sequence that will be played, or null if it will stop playing after the current 
	* sequence. READ-ONLY. **/
	public var nextSequence( default, null ) : String;
	
	/** Prevents the animation from advancing each tick automatically. For example, you could create a sprite sheet of icons, 
	* set paused to true, and display the appropriate icon by setting currentFrame. **/
	public var paused( default, default ) : Bool;
	
	/** The SpriteSheet instance to play back. This includes the source image, frame dimensions, and frame data. See SpriteSheet 
	* for more information. **/
	public var spriteSheet( default, default ) : SpriteSheet;
	
	/**
	* Whether or not the Bitmap should be draw to the canvas at whole pixel coordinates.
	* @property snapToPixel
	* @type Boolean
	* @default true
	**/
	override public var snapToPixel( default, default ) : Bool;
	
// constructor:
	/**
	* Constructs a BitmapSequence object with the specified sprite sheet.
	* @param spriteSheet The SpriteSheet instance to play back. This includes the source image, frame dimensions, and 
	* frame data. See SpriteSheet for more information.
	* @class Displays frames or sequences of frames from a sprite sheet image. A sprite sheet is a series of images 
	* (usually animation frames) combined into a single image on a regular grid. For example, an animation consisting 
	* of 8 100x100 images could be combined into a 400x200 sprite sheet (4 frames across by 2 high). You can display individual 
	* frames, play sequential frames as an animation, and even sequence animations together. See the SpriteSheet class for more 
	* information on setting up frames and animation.
	* @augments DisplayObject
	**/
	public function new( spriteSheet : SpriteSheet ) : Void;
	
// public methods:

	/**
	* Returns true or false indicating whether the display object would be visible if drawn to a canvas.
	* This does not account for whether it would be visible within the boundaries of the stage.
	* NOTE: This method is mainly for internal use, though it may be useful for advanced uses.
	* @method isVisible
	* @return {Boolean} Boolean indicating whether the display object would be visible if drawn to a canvas
	**/
	override public function isVisible() : Bool;
	
	override public function draw( ctx : Dynamic, ignoreCache : Bool ) : Bool;
	
	/**
	* Advances the currentFrame if paused is not true. This is called automatically when the Stage ticks.
	**/
	public function tick() : Void;
	
	/**
	* Because the content of a Bitmap is already in a simple format, cache is unnecessary for BitmapSequence instances.
	**/
	//override public function cache() : Void;
	override public function cache( x : Float, y : Float, w : Float, h : Float ) : Void;
	
	/**
	* Because the content of a Bitmap is already in a simple format, cache is unnecessary for BitmapSequence instances.
	**/
	override public function uncache() : Void;
	
	/**
	* Sets paused to false and plays the specified sequence name, named frame, or frame number.
	**/
	public function gotoAndPlay( frameOrSequence : String ) : Void;
	
	/**
	* Sets paused to true and seeks to the specified sequence name, named frame, or frame number.
	**/
	public function gotoAndStop( frameOrSequence : String ) : Void;
	
	override public function clone() : DisplayObject;
		
	override public function toString() : String;
	
	/** 
	* @method cloneProps
	* @param {Text} o
	* @protected
	**/
	public function cloneProps(o:Dynamic) : Void;


}
