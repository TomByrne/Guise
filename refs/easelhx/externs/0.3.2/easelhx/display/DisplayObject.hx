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
import easelhx.geom.Matrix2D;
import easelhx.geom.Point;

import js.CanvasRenderingContext2D;

@:native("DisplayObject")
extern class DisplayObject {
	
// public properties:
	/** The alpha (transparency) for this display object. 0 is fully transparent, 1 is fully opaque. **/
	public var alpha( default, default ) : Float;
	
	/** If a cache is active, this returns the canvas that holds the cached version of this display object. 
	* See cache() for more information. READ-ONLY. **/
	public var cacheCanvas( default, default ) : CanvasRenderingContext2D;
	
	/** Unique ID for this display object. Makes display objects easier for some uses. **/
	public var id( default, default ) : Int;
	
	/** Indicates whether to include this object when running Stage.getObjectsUnderPoint(). Setting this 
	* to true for Sprites will cause the Sprite to be returned (not its children) regardless of whether it's 
	* mouseChildren property is true. **/
	public var mouseEnabled( default, default ) : Bool;
	
	/** An optional name for this display object. Included in toString(). Useful for debugging. **/
	public var name( default, default ) : String;
	
	/** A reference to the Sprite or Stage object that contains this display object, or null if it has not 
	* been added to one. READ-ONLY. **/
	public var parent( default, null ) : DisplayObject;
	
	/** The x offset for this display object's registration point. For example, to make a 100x100px 
	* Bitmap rotate around it's center, you would set regX and regY to 50. **/
	public var regX( default, default ) : Float;
	
	/** The y offset for this display object's registration point. For example, to make a 100x100px 
	* Bitmap rotate around it's center, you would set regX and regY to 50. **/
	public var regY( default, default ) : Float;
	
	/** The rotation in degrees for this display object. **/
	public var rotation( default, default ) : Float;
	
	/** The factor to stretch this display object horizontally. For example, setting scaleX to 2 will 
	* stretch the display object to twice it's nominal width. **/
	public var scaleX( default, default ) : Float;
	
	/** The factor to stretch this display object vertically. For example, setting scaleY to 0.5 will 
	* stretch the display object to half it's nominal height. **/
	public var scaleY( default, default ) : Float;
	
	/**
	* The factor to skew this display object horizontally.
	* @property skewX
	* @type Number
	* @default 0
	**/
	public var skewX( default, default ) : Float;
	
	/**
	* The factor to skew this display object vertically.
	* @property skewY
	* @type Number
	* @default 0
	**/
	public var skewY( default, default ) : Float;
	
	/** A shadow object that defines the shadow to render on this display object. Set to null to remove 
	* a shadow. Note that nested shadows can result in unexpected behaviour (ex. if both a child and a parent 
	* have a shadow set). **/
	public var shadow( default, default ) : Shadow;
	
	/** Indicates whether this display object should be rendered to the canvas and included when running 
	Stage.getObjectsUnderPoint(). **/
	public var visible( default, default ) : Bool;
	
	/** The x (horizontal) position of the display object, relative to its parent. **/
	public var x( default, default ) : Float;
	
	/** The y (vertical) position of the display object, relative to its parent. **/
	public var y( default, default ) : Float;
	
	/**
	* The composite operation indicates how the pixels of this display object will be composited with the elements 
	* behind it. If null, this property is inherited from the parent container. For more information, read the 
	* <a href="http://www.whatwg.org/specs/web-apps/current-work/multipage/the-canvas-element.html#compositing">
	* whatwg spec on compositing</a>.
	* @property compositeOperation
	* @type String
	* @default null
	**/
	public var compositeOperation( default, default ) : String;
	
	/**
	* Indicates whether the display object should have it's x & y position rounded prior to drawing it to stage. 
	* This only applies if the enclosing stage has snapPixelsEnabled set to true, and the display object's composite 
	* transform does not include any scaling, rotation, or skewing. The snapToPixel property is true by default for 
	* Bitmap and BitmapSequence instances, and false for all other display objects.
	* @property snapToPixel
	* @type Boolean
	* @default false
	**/
	public var snapToPixel( default, default ) : Bool;
	
	/**
	* The onPress callback is called when the user presses down on their mouse over this display object. The handler 
	* is passed a single param containing the corresponding MouseEvent instance. You can subscribe to the onMouseMove
	* and onMouseUp callbacks of the event object to receive these events until the user releases the mouse button. 
	* If an onPress handler is set on a container, it will receive the event if any of its children are clicked.
	* @event onPress
	* @param {MouseEvent} event MouseEvent with information about the event.
	**/
	public var onPress( default, default ) : Dynamic;
//	p.onPress = null;
	
	/**
	* The onClick callback is called when the user presses down on and then releases the mouse button over this 
	* display object. The handler is passed a single param containing the corresponding MouseEvent instance. If an 
	* onClick handler is set on a container, it will receive the event if any of its children are clicked.
	* @event onClick
	* @param {MouseEvent} event MouseEvent with information about the event.
	**/
	public var onClick( default, default ) : Dynamic;
//	p.onClick = null;
	
	/**
	* The onMouseOver callback is called when the user rolls over the display object. You must enable this event using 
	* stage.enableMouseOver(). The handler is passed a single param containing the corresponding MouseEvent instance.
	* @event onMouseOver
	* @param {MouseEvent} event MouseEvent with information about the event.
	**/
	public var onMouseOver( default, default ) : Dynamic;
//	p.onMouseOver = null;
	
	/**
	* The onMouseOut callback is called when the user rolls off of the display object. You must enable this event using
	* stage.enableMouseOver(). The handler is passed a single param containing the corresponding MouseEvent instance.
	* @event onMouseOut
	* @param {MouseEvent} event MouseEvent with information about the event.
	**/
	public var onMouseOut( default, default ) : Dynamic;
//	p.onMouseOut = null;
		
// constructor:
	/**
	* DisplayObject is an abstract class that should not be constructed directly. Instead construct subclasses 
	* such as Sprite, Bitmap, and Shape.
	* @class DisplayObject is the base class for all display classes in the CanvasDisplay library. It defines the 
	* core properties and methods that are shared between all display objects. It should not be instantiated directly.
	**/
	public function new() : Void;
	
	/**
	* Returns true or false indicating whether the display object would be visible if drawn to a canvas.
	* This does not account for whether it would be visible within the boundaries of the stage.
	* NOTE: This method is mainly for internal use, though it may be useful for advanced uses.
	* @method isVisible
	* @return {Boolean} Boolean indicating whether the display object would be visible if drawn to a canvas
	**/
	public function isVisible() : Bool;
	
// public methods:
	/**
	* NOTE: This method is mainly for internal use, though it may be useful for advanced developers extending the 
	* capabilities of the CanvasDisplay library.
	* Updates the specified context based on this display object's properties.
	* @param ctx The canvas 2D context object to update.
	* @param ignoreShadows Indicates whether the shadow property should be applied. Passing false will ignore the shadow, 
	* resulting in faster rendering for uses like hit testing.
	**/
//	public function updateContext( ctx : Dynamic, ignoreShadows : Bool ) : Bool;
	
	/**
	* NOTE: This method is mainly for internal use, though it may be useful for advanced developers extending the 
	* capabilities of the CanvasDisplay library.
	* Draws the display object into the specified context if it is visible.
	* @param ctx The canvas 2D context object to draw into.
	* @param ignoreCache Indicates whether the draw operation should ignore any current cache. For example, used for drawing 
	* the cache (to prevent it from simply drawing an existing cache back into itself).
	**/
	public function draw( ctx : Dynamic, ignoreCache : Bool ) : Bool;
	
	/**
	* NOTE: This method is mainly for internal use, though it may be useful for advanced developers extending the 
	* capabilities of the CanvasDisplay library.
	* Reverts the last context that was updated with updateContext(), restoring it to the state it was in prior to the update.
	**/
	public function revertContext() : Void;
	
	/**
	* Draws the display object into a new canvas, which is then used for subsequent draws. For complex content that does 
	* not change frequently (ex. a Sprite with many children that do not move, or a complex vector Shape), this can provide 
	* for much faster rendering because the content does not need to be rerendered each tick. The cached display object 
	* can be moved, rotated, faded, etc freely, however if it's content changes, you must manually update the cache by calling 
	* cache() again. Do not call uncache before the subsequent cache call. You must specify the cache area via the x, y, w, 
	* and h parameters. This defines the rectangle that will be rendered and cached using this display object's coordinates. 
	* For example if you defined a Shape that drew a circle at 0,0 with a radius of 25, you could call myShape.cache(-25,-25,50,50) 
	* to cache the full shape.
	* @param x
	* @param y
	* @param width
	* @param height
	**/
	public function cache( x : Float, y : Float, w : Float, h : Float ) : Void;
	
	/**
	* Redraws the display object to its cache. Calling updateCache without an active cache will throw an error.
	* If compositeOperation is null the current cache will be cleared prior to drawing. Otherwise the display object
	* will be drawn over the existing cache using the specified compositeOperation.
	* @method updateCache
	* @param {String} compositeOperation The compositeOperation to use, or null to clear the cache and redraw it. 
	**/
	public function updateCache( compositeOperation:String ) : Void;
	
	
	/**
	* Clears the current cache. See cache() for more information.
	**/
	public function uncache() : Void;
	
	/**
	* Returns the stage that this display object will be rendered on, or null if it has not been added to one.
	**/
	public function getStage() : DisplayObject;
	
	/**
	* Transforms the specified x and y position from the coordinate space of the display object
	* to the global (stage) coordinate space. For example, this could be used to position an HTML label
	* over a specific point on a nested display object. Returns a Point instance with x and y properties
	* correlating to the transformed coordinates on the stage.
	* @method localToGlobal
	* @param {Number} x The x position in the source display object to transform.
	* @param {Number} y The y position in the source display object to transform.
	* @return {Point} A Point instance with x and y properties correlating to the transformed coordinates 
	* on the stage.
	**/
	public function localToGlobal(x:Float, y:Float) : Point;

	/**
	* Transforms the specified x and y position from the global (stage) coordinate space to the
	* coordinate space of the display object. For example, this could be used to determine
	* the current mouse position within the display object. Returns a Point instance with x and y properties
	* correlating to the transformed position in the display object's coordinate space.
	* @method globalToLocal
	* @param {Number} x The x position on the stage to transform.
	* @param {Number} y The y position on the stage to transform.
	* @return {Point} A Point instance with x and y properties correlating to the transformed position in the
	* display object's coordinate space.
	**/
	public function globalToLocal(x:Float, y:Float) : Point;

	/**
	* Transforms the specified x and y position from the coordinate space of this display object to the
	* coordinate space of the target display object. Returns a Point instance with x and y properties
	* correlating to the transformed position in the target's coordinate space. Effectively the same as calling
	* var pt = this.localToGlobal(x, y); pt = target.globalToLocal(pt.x, pt.y);
	* @method localToLocal
	* @param {Number} x The x position in the source display object to transform.
	* @param {Number} y The y position on the stage to transform.
	* @param {DisplayObject} target The target display object to which the coordinates will be transformed.
	* @return {Point} Returns a Point instance with x and y properties correlating to the transformed position 
	* in the target's coordinate space.
	**/
	public function localToLocal(x:Float, y:Float) : Point;

	/**
	* Generates a concatenated Matrix2D object representing the combined transform of
	* the display object and all of its parent Containers up to the highest level ancestor
	* (usually the stage). This can be used to transform positions between coordinate spaces,
	* such as with localToGlobal and globalToLocal.
	* @method getConcatenatedMatrix
	* @param {Matrix2D} mtx Optional. A Matrix2D object to populate with the calculated values. If null, a new 
	* Matrix object is returned.
	* @return {Matrix2D} a concatenated Matrix2D object representing the combined transform of
	* the display object and all of its parent Containers up to the highest level ancestor (usually the stage).
	**/
	public function getConcatenatedMatrix(mtx:Matrix2D) : Matrix2D;

	/**
	* Tests whether the display object intersects the specified local point (ie. draws a pixel with alpha > 0 at 
	* the specified position). This ignores the alpha, shadow and compositeOperation of the display object, and all 
	* transform properties including regX/Y.
	* @method hitTest
	* @param {Number} x The x position to check in the display object's local coordinates.
	* @param {Number} y The y position to check in the display object's local coordinates.
	* @return {Boolean} A Boolean indicting whether a visible portion of the DisplayObject intersect the specified 
	* local Point.
	*/
	public function hitTest(x:Float, y:Float) : Bool;
	
	/**
	* Returns a clone of this DisplayObject. Some properties that are specific to this instance's current context are reverted 
	* to their defaults (for example .parent).
	**/
	public function clone() : DisplayObject;
	
	/**
	* Returns a string representation of this object.
	**/
	public function toString() : String;
	
}