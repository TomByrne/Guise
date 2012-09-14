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

@:native("SpriteSheet")
extern class SpriteSheet {

// public properties:
	/** The Image, Canvas, or Video instance to use as a sprite sheet. **/
	public var image( default, default ) : Dynamic;
	
	/** The width in pixels of each frame on the sprite sheet image. **/
	public var frameWidth( default, default ) : Float;
	
	/** The height in pixels of each frame on the sprite sheet image. **/
	public var frameHeight( default, default ) : Float;
	
	/** Defines named frames and frame sequences. Frame data is specified as a generic object, where each property 
	* name will be used to define a new named frame or sequence. Named frames specify a frame number. Sequences are 
	* defined using an array of 2 or 3 values: the start frame, the end frame, and optionally the name of the next sequence 
	* to play.<br/><br/>For example, examine the following frame data:<br/>{walk:[0,20], shoot:[21,25,"walk"], 
	* crouch:[26,30,false], stand:31}<br/>This will create 3 sequences and a named frame. The first sequence will be named 
	* "walk", and will loop frames 0 to 20 inclusive. The second sequence will be named "shoot", and will play frames 21 to 25 
	* then play the walk sequence. The third sequence "crouch" will play frames 26 to 30 then pause on frame 30, due to false 
	* being passed as the next sequence. The named frame "stand" will display frame 31. **/
	public var frameData( default, default ) : Dynamic;
	
	/** The loop property is only used if no frameData is specified, and indicates whether all frames (as specified with 
	* totalFrames) should loop. If false, the animation will play to totalFrames, then pause. **/
	public var loop( default, default ) : Bool;
	
	/** Specifies the total number of frames in the sprite sheet if no frameData is specified. This is useful for 
	* excluding extraneous frames (for example, if you have 7 frames in a 2x4 sprite sheet). The total frames will be 
	* automatically calculated by BitmapSequence based on frame and image dimensions if totalFrames is 0. **/
	public var totalFrames( default, default ) : Int;
	
// constructor:
	/**
	* Constructs a new SpriteSheet object.
	* @param image The Image, Canvas, or Video instance to use as a sprite sheet.
	* @param frameWidth The width in pixels of each frame on the sprite sheet.
	* @param frameHeight The height in pixels of each frame on the sprite sheet.
	* @param frameData Defines named frames and frame sequences. See the frameData property for more information.
	* @class Encapsulates the properties associated with a sprite sheet. A sprite sheet is a series of images (usually animation 
	* frames) combined into a single image on a regular grid. For example, an animation consisting of 8 100x100 images could be 
	* combined into a 400x200 sprite sheet (4 frames across by 2 high).
	* The simplest form of sprite sheet has values for the image, frameWidth, and frameHeight properties, but does not include frameData. 
	* It will then play all of the frames in the animation and loop if the loop property is true. In this simple mode, you can also 
	* set the totalFrames property if you have extraneous frames in your sprite sheet (for example, a 2x4 frame sprite sheet, with only 
	* 7 frames used).<br/><br/>
	* More complex sprite sheets include a frameData property, which provides named frames and animations which can be played and sequenced 
	* together. See frameData for more information.
	**/
	public function new( image : Dynamic, frameWidth : Float, frameHeight : Float, frameData : Dynamic ) : Void;
	
// public methods:
	/**
	* Returns a string representation of this object.
	**/
	public function toString() : String;
	
	/**
	* Returns a clone of this object.
	**/
	public function clone() : SpriteSheet;
	
}
