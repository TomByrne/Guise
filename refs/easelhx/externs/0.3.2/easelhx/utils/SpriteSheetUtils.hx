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

import easelhx.display.SpriteSheet;

@:native("SpriteSheetUtils")
extern class SpriteSheetUtils {

// constructor:
	/**
	* The SpriteSheetUtils class uses a static interface and should not be instantiated.
	* @class The SpriteSheetUtils class is a collection of static methods for working with sprite sheets.  
	* A sprite sheet is a series of images (usually animation frames) combined into a single image on a regular grid. 
	* For example, an animation consisting of 8 100x100 images could be combined into a 400x200 sprite sheet 
	* (4 frames across by 2 high).
	**/
	//function SpriteSheetUtils() {
	//	throw "SpriteSheetUtils cannot be instantiated"; 
	//}
	
// public static methods:
	/**
	* Builds a new extended sprite sheet based on the specified image adding flipped frames (vertical, horizontal, or both). 
	* Flipping elements on the display list by using setting scaleX/scaleY to -1 is quite expensive in most browsers, so this 
	* method allows you to incur the cost of flipping once, in advance, without increasinig the load size of your sprite sheets. 
	* Returns a generic object with a property "image" containing the new sprite sheet as an Image instance, and "frameData" 
	* which contains the new frame data object.
	* @param image The sprite sheet (canvas, image or video) to use as the source material image.
	* @param frameWidth The width of each frame in the sprite sheet.
	* @param frameHeight The height of each frame in the sprite sheet.
	* @param frameData The frameData that defines the frames and sequences in the sprite sheet. See BitmapSequence.frameData for 
	* more information.
	* @param flipData A generic object that specifies which frames will be flipped, what to name the flipped result, and how to 
	* flip the frames (horizontally, vertically, or both). Each property name indicates the name of a new sequence to create, and 
	* should reference an array where the first index is the name of the original sequence to flip, the second index indicates whether 
	* to flip it horizontally, the third index indicates whether to flip it vertically, and the fourth indicates what the "next" 
	* value for the resulting frame data should be. For example, the following would create a new sequence named "walk_left" consisting 
	* of the frames from the original "walk_right" sequence flipped horizontally: {walk_left:["walk_right", true, false]}
	* @static
	**/
	public static function flip( spriteSheet : SpriteSheet, flipData : Dynamic ) : SpriteSheet;
	
	/**
	* Returns a string representing the specified frameData object.
	* @param frameData The frame data to output.
	* @static
	**/
	public static function frameDataToString( frameData : Dynamic ) : String;
	
	/**
	* Returns a single frame of the specified sprite sheet as a new PNG image.
	* @method extractFrame
	* @static
	* @param {Image} spriteSheet The SpriteSheet instance to extract a frame from.
	* @param {Number} frame The frame number or sequence name to extract. If a sequence 
	* name is specified, only the first frame of the sequence will be extracted.
	* @return {Image} a single frame of the specified sprite sheet as a new PNG image.
	*/
	public static function frameDataToString( spriteSheet:Image, frame:Float ) : Image;


}
