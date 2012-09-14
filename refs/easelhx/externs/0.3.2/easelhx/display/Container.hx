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
import easelhx.display.DisplayObject;

@:native("Container")
extern class Container extends DisplayObject {

// public properties:
	/** The array of children in the display list. You should usually use the child management methods, rather than 
	* accessing this directly, but it is included for advanced users. **/
	public var children( default, default ) : Array<DisplayObject>;
	
	/** Indicates whether the children of this Container should be tested in getObjectsUnderPoint() and getObjectUnderPoint() 
	* calls. It is false by default, except on Stage instances where it is true by default. **/
	public var mouseChildren( default, default ) : Bool;

// constructor:
	/**
	* Constructs a new Container instance.
	* @class Containers are nestable display lists that allow you to work with compound display elements. For example 
	* you could group arm, leg, torso and head Bitmaps together into a Person Container, and transform them as a group, 
	* while still being able to move the individual parts relative to each other. Children of containers have their transform 
	* and alpha properties concatenated with their parent Container. For example, a Shape with x=100 and alpha=0.5, placed 
	* in a Container with x=50 and alpha=0.7 will be rendered to the canvas at x=150 and alpha=0.35. Containers have some overhead, 
	* so you generally shouldn't create a Container to hold a single child.
	* @augments DisplayObject
	**/
	public function new() : Void;
	
	/**
	* Returns true or false indicating whether the display object would be visible if drawn to a canvas.
	* This does not account for whether it would be visible within the boundaries of the stage.
	* NOTE: This method is mainly for internal use, though it may be useful for advanced uses.
	* @method isVisible
	* @return {Boolean} Boolean indicating whether the display object would be visible if drawn to a canvas
	**/
	override public function isVisible() : Bool;
	
// public methods:
	/** @private **/
	override public function draw( ctx : Dynamic, ignoreCache : Bool ) : Bool;
	
	/**
	* Adds a child to the top of the display list. You can also add multiple children, such as "addChild(child1, child2, ...);". 
	* Returns the child that was added, or the last child if multiple children were added.
	* @param child The display object to add.
	**/
	public function addChild( child : DisplayObject ) : DisplayObject;
	
	/**
	* Adds a child to the display list at the specified index, bumping children at equal or greater indexes up one, 
	* and setting its parent to this Container. You can also add multiple children, such as "addChildAt(child1, child2, ..., index);". 
	* The index must be between 0 and numChildren. For example, to add myShape under otherShape in the display list, you 
	* could use: container.addChildAt(myShape, container.getChildIndex(otherShape)). This would also bump otherShape's index 
	* up by one. Returns the last child that was added, or the last child if multiple children were added.
	* @param child The display object to add.
	* @param index The index to add the child at.
	**/
	public function addChildAt( child : DisplayObject, index : Int ) : DisplayObject;
	
	/**
	* Removes the specified child from the display list. Note that it is faster to use removeChildAt() if the index 
	* is already known. You can also remove multiple children, such as "removeChild(child1, child2, ...);". 
	* Returns true if the child (or children) was removed, or false if it was not in the display list.
	* @param child The child to remove.
	**/
	public function removeChild( child : DisplayObject ) : Bool;
	
	/**
	* Removes the child at the specified index from the display list, and sets its parent to null. You can also 
	* remove multiple children, such as "removeChildAt(2, 7, ...);". Returns true if the child (or children) was removed, 
	* or false if any index was out of range.
	* @param The index of the child to remove.
	**/
	public function removeChildAt( index : Int ) : Bool;
	
	/**
	* Removes all children from the display list.
	**/
	public function removeAllChildren() : Void;
	
	/**
	* Returns the child at the specified index.
	* @param index The index of the child to return.
	**/
	public function getChildAt( index : Int ) : DisplayObject;
	
	/**
	* Performs an array sort operation on the child list.
	* @sortFunction the function to use to sort the child list. See javascript's Array.sort documentation for details.
	**/
	public function sortChildren( sortFunction : DisplayObject -> DisplayObject -> Void ) : Void;
	
	/**
	* Returns the index of the specified child in the display list, or -1 if it is not in the display list.
	* @param The child to return the index of.
	**/
	public function getChildIndex( child : DisplayObject ) : Int;
	
	/**
	* Returns the number of children in the display list.
	**/
	public function getNumChildren() : Int;
	
	/**
	* Returns true if the specified display object either is this container or is a descendent.
	* (child, grandchild, etc) of this container.
	* @method contains
	* @param {DisplayObject} child The DisplayObject to be checked.
	* @return {Boolean} true if the specified display object either is this container or is a descendent.
	**/
	public function contains(child:DisplayObject) : Bool;
	
	/**
	* Tests whether the display object intersects the specified local point (ie. draws a pixel with alpha > 0 at the specified 
	* position). This ignores the alpha, shadow and compositeOperation of the display object, and all transform properties 
	* including regX/Y.
	* @method hitTest
	* @param x The x position to check in the display object's local coordinates.
	* @param y The y position to check in the display object's local coordinates.
	* @return {Boolean} A Boolean indicating whether there is a visible section of a DisplayObject that overlaps the specified 
	* coordinates.
	**/
	override public function hitTest(x:Float, y:Float) : Bool;
	
	/**
	* Returns an array of all display objects under the specified coordinates that are in this container's display list. 
	* This routine ignores any display objects with mouseEnabled set to false. The array will be sorted in order of visual 
	* depth, with the top-most display object at index 0. This uses shape based hit detection, and can be an expensive operation 
	* to run, so it is best to use it carefully. For example, if testing for objects under the mouse, test on tick (instead of on 
	* mousemove), and only if the mouse's position has changed.
	* @method getObjectsUnderPoint
	* @param {Number} x The x position in the container to test.
	* @param {Number} y The y position in the container to test.
	* @return {Array[DisplayObject]} An Array of DisplayObjects under the specified coordinates.
	**/
	public function getObjectsUnderPoint(x:Float, y:Float) : Array<DisplayObject>;

	/**
	* Similar to getObjectsUnderPoint(), but returns only the top-most display object. This runs significantly faster than 
	* getObjectsUnderPoint(), but is still an expensive operation. See getObjectsUnderPoint() for more information.
	* @method getObjectUnderPoint
	* @param {Number} x The x position in the container to test.
	* @param {Number} y The y position in the container to test.
	* @return {DisplayObject} The top-most display object under the specified coordinates.
	**/
	public function getObjectUnderPoint(x:Float, y:Float) : DisplayObject;
	
	override public function clone() : DisplayObject;
	
	override public function toString() : String;
	
}