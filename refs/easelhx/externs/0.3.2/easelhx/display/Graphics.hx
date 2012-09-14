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

@:native("Graphics")
extern class Graphics {

// static public methods:
	/**
	* Returns a CSS compatible color string based on the specified RGB numeric color values in the format "rgba(255,255,255,1.0)", 
	* or if alpha is null then in the format "rgb(255,255,255)". For example,
	* Graphics.getRGB(50,100,150,0.5) will return "rgba(50,100,150,0.5)".
	* @param r The red component for the color, between 0 and 0xFF (255).
	* @param g The green component for the color, between 0 and 0xFF (255).
	* @param b The blue component for the color, between 0 and 0xFF (255).
	* @param alpha Optional. The alpha component for the color where 0 is fully transparent and 1 is fully opaque.
	* @static
	**/
	public static function getRGB( r : Int, g : Int, b : Int, ?alpha : Float ) : String;
	
	/**
	* Returns a CSS compatible color string based on the specified HSL numeric color values in the format "hsla(360,100,100,1.0)", 
	* or if alpha is null then in the format "hsl(360,100,100)". For example,
	* Graphics.getHSL(150,100,70) will return "hsl(150,100,70)".
	* @param hue The hue component for the color, between 0 and 360.
	* @param saturation The saturation component for the color, between 0 and 100.
	* @param lightness The lightness component for the color, between 0 and 100.
	* @param alpha Optional. The alpha component for the color where 0 is fully transparent and 1 is fully opaque.
	* @static
	**/
	public static function getHSL( hue : Int, saturation : Int, lightness : Int, ?alpha : Float ) : String;
	
	/**
	* Maps numeric values for the caps parameter of setStrokeStyle to corresponding string values.
	* This is primarily for use with the tiny API. The mappings are as follows: 0 to "butt",
	* 1 to "round", and 2 to "square".
	* For example, myGraphics.ss(16, 2) would set the line caps to "square".
	* @property STROKE_CAPS_MAP
	* @static
	* @final
	* @type Array[String]
	**/
	public static var STROKE_CAPS_MAP : Array<String>;
	
	/**
	* Maps numeric values for the joints parameter of setStrokeStyle to corresponding string values.
	* This is primarily for use with the tiny API. The mappings are as follows: 0 to "miter",
	* 1 to "round", and 2 to "bevel".
	* For example, myGraphics.ss(16, 0, 2) would set the line joints to "bevel".
	* @property STROKE_JOINTS_MAP
	* @static
	* @final
	* @type Array[String]
	**/
	public static var STROKE_JOINTS_MAP : Array<String>;
	
	//public static var _canvas : DomCanvas;
	public static var _ctx : Dynamic;
	
	public static var beginCmd : Command;
	public static var fillCmd : Command;
	public static var strokeCmd : Command;
	
// public properties:

	/**
	* @property _strokeInstructions
	* @protected
	* @type Array[Command]
	**/
	public var _strokeInstructions:Array<Command>;

	/**
	* @property _strokeStyleInstructions
	* @protected
	* @type Array[Command]
	**/
	public var _strokeStyleInstructions:Array<Command>;
	
	/**
	* @property _fillInstructions
	* @protected
	* @type Array[Command]
	**/
	public var _fillInstructions:Array<Command>;
	
	/**
	* @property _instructions
	* @protected
	* @type Array[Command]
	**/
	public var _instructions:Array<Command>;
	
	/**
	* @property _oldInstructions
	* @protected
	* @type Array[Command]
	**/
	public var _oldInstructions:Array<Command>;
	
	/**
	* @property _activeInstructions
	* @protected
	* @type Array[Command]
	**/
	public var _activeInstructions:Array<Command>;
	
	/**
	* @property _active
	* @protected
	* @type Boolean
	* @default false
	**/
	public var _active:Bool;
	
	/**
	* @property _dirty
	* @protected
	* @type Boolean
	* @default false
	**/
	public var _dirty:Bool;
	
	
// constructor:
	/**
	* Constructs a new Graphics instance.
	* @param instructions Optional. This is a string that will be eval'ed in the scope of this Graphics object. This provides a 
	* mechanism for generating a vector shape from a serialized string. Ex. "beginFill('#F00');drawRect(0,0,10,10);"
	* @class The Graphics class exposes an easy to use API for generating vector drawing instructions and drawing them to a specified context.
	* Note that you can use Graphics without any dependency on the Easel framework by calling draw() directly,
	* or it can be used with the Shape object to draw vector graphics within the context of an Easel display list.<br/><br/>
	* Note that all drawing methods in Graphics return the Graphics instance, so they can be chained together. For example, the 
	* following line of code would generate the instructions to draw a rectangle with a red stroke and blue fill, then render it to the 
	* specified context2D:<br/>
	* myGraphics.beginStroke("#F00").beginFill("#00F").drawRect(20, 20, 100, 50).draw(myContext2D);
	**/
	public function new( instructions : String ) : Void;
	
// public methods:
	public function draw( ctx : Dynamic ) : Void;
	
// public methods that map directly to context 2D calls:
	/**
	* Moves the drawing point to the specified position.
	* @param x
	* @param y
	**/
	public function moveTo( x : Float, y : Float ) : Graphics;
	
	/**
	* Draws a line from the current drawing point to the specified position, which become the new current drawing point. For detailed 
	* information, read the <a href="http://www.whatwg.org/specs/web-apps/current-work/multipage/the-canvas-element.html#complex-shapes-(paths)">whatwg spec</a>.
	* @param x
	* @param y
	**/
	public function lineTo( x : Float, y : Float ) : Graphics;
	
	/**
	* Draws an arc with the specified control points and radius.  For detailed information, read the 
	* <a href="http://www.whatwg.org/specs/web-apps/current-work/multipage/the-canvas-element.html#complex-shapes-(paths)">whatwg spec</a>.
	* @param x1
	* @param y1
	* @param x2
	* @param y2
	* @param radius
	**/
	public function arcTo( x1 : Float, y1 : Float, x2 : Float, y2 : Float, radius : Float ) : Graphics;
	
	/**
	* Draws an arc defined by the radius, startAngle and endAngle arguments, centered at the position (x,y). 
	* For example arc(100,100,20,0,Math.PI*2) would draw a full circle with a radius of 20 centered at 100,100. For detailed information, 
	* read the <a href="http://www.whatwg.org/specs/web-apps/current-work/multipage/the-canvas-element.html#complex-shapes-(paths)">whatwg spec</a>.
	* @param x
	* @param y
	* @param radius
	* @param startAngle
	* @param endAngle
	* @param anticlockwise
	**/
	public function arc( x : Float, y : Float, radius : Float, startAngle : Float, endAngle : Float, ?anticlockwise : Bool ) : Graphics;
	
	/**
	* Draws a quadratic curve from the current drawing point to (x,y) using the control point (cpx,cpy). For detailed information, read the 
	* <a href="http://www.whatwg.org/specs/web-apps/current-work/multipage/the-canvas-element.html#complex-shapes-(paths)">whatwg spec</a>.
	* @param cpx
	* @param cpy
	* @param x
	* @param y
	**/
	public function quadraticCurveTo( cpx : Float, cpy : Float, x : Float, y : Float ) : Graphics;
	
	/**
	* Draws a bezier curve from the current drawing point to (x,y) using the control points (cp1x,cp1y) and (cp2x,cp2y). For detailed 
	* information, read the <a href="http://www.whatwg.org/specs/web-apps/current-work/multipage/the-canvas-element.html#complex-shapes-(paths)">whatwg spec</a>.
	* @param cp1x
	* @param cp1y
	* @param cp2x
	* @param cp2y
	* @param x
	* @param y
	**/
	public function bezierCurveTo( cp1x : Float, cp1y : Float, cp2x : Float, cp2y : Float, x : Float, y : Float ) : Graphics;
	
	/**
	* Draws a rectangle at (x,y) with the specified width and height using the current fill and/or stroke. For detailed information, read the 
	* <a href="http://www.whatwg.org/specs/web-apps/current-work/multipage/the-canvas-element.html#complex-shapes-(paths)">whatwg spec</a>.
	* @param cpx
	* @param cpy
	* @param x
	* @param y
	**/
	public function rect( x : Float, y : Float, w : Float, h : Float ) : Graphics;
	
	/**
	* Closes the current path, effectively drawing a line from the current drawing point to the first drawing point 
	* specified since the fill or stroke was last set.
	**/
	public function closePath() : Graphics;
	
// public methods that roughly map to Flash graphics APIs:
	/**
	* Clears all drawing instructions, effectively reseting this Graphics instance.
	**/
	public function clear() : Graphics;
	
	/**
	* Begins a fill with the specified color. This ends the current subpath.
	* @param color A CSS compatible color value (ex. "#FF0000" or "rgba(255,0,0,0.5)"). Setting to null will result in no fill.
	**/
	public function beginFill( color : String ) : Graphics;
	
	/**
	* Begins a linear gradient fill defined by the line (x0,y0) to (x1,y1). This ends the current subpath. For example, the 
	* following code defines a black to white vertical gradient ranging from 20px to 120px, and draws a square to display it:<br/>
	* myGraphics.beginLinearGradientFill(["#000","#FFF"], [0,1], 0, 20, 0, 120).drawRect(20,20,120,120);
	* @param colors An array of CSS compatible color values. For example, ["#F00","#00F"] would define a gradient drawing from red to blue.
	* @param ratios An array of gradient positions which correspond to the colors. For example, [0.1,0.9] would draw the first 
	* color to 10% then interpolating to the second color at 90%.
	* @param x0 The position of the first point defining the line that defines the gradient direction and size.
	* @param y0 The position of the first point defining the line that defines the gradient direction and size.
	* @param x1 The position of the second point defining the line that defines the gradient direction and size.
	* @param y1 The position of the second point defining the line that defines the gradient direction and size.
	**/
	public function beginLinearGradientFill( colors : Array<String>, ratios : Array<Float>, x0 : Float, y0 : Float, 
		x1 : Float, y1 : Float ) : Graphics;
	
	/**
	* Begins a radial gradient fill. This ends the current subpath. For example, the following code defines a red to blue radial 
	* gradient centered at (100,100), with a radius of 50, and draws a circle to display it:<br/>
	* myGraphics.beginRadialGradientFill(["#F00","#00F"], [0,1], 100, 100, 0, 100, 100, 50).drawCircle(100, 100, 50);
	* @param colors An array of CSS compatible color values. For example, ["#F00","#00F"] would define a gradient drawing from red to blue.
	* @param ratios An array of gradient positions which correspond to the colors. For example, [0.1,0.9] would draw the first 
	* color to 10% then interpolating to the second color at 90%.
	* @param x0 Center position of the inner circle that defines the gradient.
	* @param y0 Center position of the inner circle that defines the gradient.
	* @param r0 Radius of the inner circle that defines the gradient.
	* @param x1 Center position of the outer circle that defines the gradient.
	* @param y1 Center position of the outer circle that defines the gradient.
	* @param r1 Radius of the outer circle that defines the gradient.
	**/
	public function beginRadialGradientFill( colors : Array<String>, ratios : Array<Float>, x0 : Float, y0 : Float, r0 : Float, 
		x1 : Float, y1 : Float, r1 : Float ) : Graphics;
	
	/**
	* Begins a pattern fill using the specified image. This ends the current subpath.
	* @param image The Image, Canvas, or Video object to use as the pattern.
	* @param repetition Optional. Indicates whether to repeat the image in the fill area. One of repeat, repeat-x, 
	* repeat-y, or no-repeat. Defaults to "repeat".
	**/
	public function beginBitmapFill( image : Dynamic, ?repetition : String ) : Graphics;
	
	/**
	* Ends the current subpath, and begins a new one with no fill. Functionally identical to beginFill(null).
	**/
	public function endFill() : Graphics;
	
	/**
	* Sets the stroke style for the current subpath. Like all drawing methods, this can be chained, so you can define the 
	* stroke style and color in a single line of code like so:
	* myGraphics.setStrokeStyle(8,"round").beginStroke("#F00");
	* @param thickness The width of the stroke.
	* @param caps Optional. Indicates the type of caps to use at the end of lines. One of butt, round, or square. Defaults to "butt".
	* @param joints Optional. Specifies the type of joints that should be used where two lines meet. One of bevel, round, or miter. 
	* Defaults to "miter".
	* @param miter Optional. If joints is set to "miter", then you can specify a miter limit ratio which controls at what point a 
	* mitered joint will be clipped.
	**/
	public function setStrokeStyle( thickness : Float, ?caps : String, ?joints : String, ?miterLimit : Float ) : Graphics;
	
	/**
	* Begins a stroke with the specified color. This ends the current subpath.
	* @param color A CSS compatible color value (ex. "#FF0000" or "rgba(255,0,0,0.5)"). Setting to null will result in no stroke.
	**/
	public function beginStroke( color : String ) : Graphics;
	
	/**
	* Begins a linear gradient stroke defined by the line (x0,y0) to (x1,y1). This ends the current subpath. For example, the 
	* following code defines a black to white vertical gradient ranging from 20px to 120px, and draws a square to display it:<br/>
	* myGraphics.setStrokeStyle(10).beginLinearGradientStroke(["#000","#FFF"], [0,1], 0, 20, 0, 120).drawRect(20,20,120,120);
	* @param colors An array of CSS compatible color values. For example, ["#F00","#00F"] would define a gradient drawing from red to blue.
	* @param ratios An array of gradient positions which correspond to the colors. For example, [0.1,0.9] would draw the first 
	* color to 10% then interpolating to the second color at 90%.
	* @param x0 The position of the first point defining the line that defines the gradient direction and size.
	* @param y0 The position of the first point defining the line that defines the gradient direction and size.
	* @param x1 The position of the second point defining the line that defines the gradient direction and size.
	* @param y1 The position of the second point defining the line that defines the gradient direction and size.
	**/
	public function beginLinearGradientStroke( colors : Array<String>, ratios : Array<Float>, x0 : Float, y0 : Float, 
		x1 : Float, y1 : Float ) : Graphics;
	
	/**
	* Begins a radial gradient stroke. This ends the current subpath. For example, the following code defines a red to blue radial 
	* gradient centered at (100,100), with a radius of 50, and draws a rectangle to display it:<br/>
	* myGraphics.setStrokeStyle(10).beginRadialGradientStroke(["#F00","#00F"], [0,1], 100, 100, 0, 100, 100, 50).drawRect(50,90,150,110);
	* @param colors An array of CSS compatible color values. For example, ["#F00","#00F"] would define a gradient drawing from red to blue.
	* @param ratios An array of gradient positions which correspond to the colors. For example, [0.1,0.9] would draw the first color 
	* to 10% then interpolating to the second color at 90%, then draw the second color to 100%.
	* @param x0 Center position of the inner circle that defines the gradient.
	* @param y0 Center position of the inner circle that defines the gradient.
	* @param r0 Radius of the inner circle that defines the gradient.
	* @param x1 Center position of the outer circle that defines the gradient.
	* @param y1 Center position of the outer circle that defines the gradient.
	* @param r1 Radius of the outer circle that defines the gradient.
	**/
	public function beginRadialGradientStroke( colors : Array<String>, ratios : Array<Float>, x0 : Float, y0 : Float, 
		r0 : Float, x1 : Float, y1 : Float, r1 : Float ) : Graphics;
	
	/**
	* Begins a pattern fill using the specified image. This ends the current subpath.
	* @param image The Image, Canvas, or Video object to use as the pattern.
	* @param repetition Optional. Indicates whether to repeat the image in the fill area. One of repeat, repeat-x, repeat-y, or 
	* no-repeat. Defaults to "repeat".
	**/
	public function beginBitmapStroke( image : Dynamic, ?repetition : String ) : Graphics;
	
	/**
	* Ends the current subpath, and begins a new one with no stroke. Functionally identical to beginStroke(null).
	**/
	public function endStroke() : Graphics;
	
	/**
	* Maps the familiar ActionScript curveTo() method to the functionally similar quatraticCurveTo() method.
	**/
	public function curveTo( cpx : Float, cpy : Float, x : Float, y : Float ) : Graphics;
	
	/**
	* Maps the familiar ActionScript drawRect() method to the functionally similar rect() method.
	**/
	public function drawRect( x : Float, y : Float, w : Float, h : Float ) : Graphics;
	
	/**
	* Draws a rounded rectangle with all corners with the specified radius.
	* @param x
	* @param y
	* @param w
	* @param h
	* @param radius Corner radius.
	**/
	public function drawRoundRect( x : Float, y : Float, w : Float, h : Float, radius : Float ) : Graphics;
	
	/**
	* Draws a rounded rectangle with different corner radiuses.
	* @param x
	* @param y
	* @param w
	* @param h
	* @param radiusTL Top left corner radius.
	* @param radiusTR Top right corner radius.
	* @param radiusBR Bottom right corner radius.
	* @param radiusBL Bottom left corner radius.
	**/
	public function drawRoundRectComplex( x : Float, y : Float, w : Float, h : Float, 
		radiusTL : Float, radiusTR : Float, radiusBR : Float, radiusBL : Float ) : Graphics;
	
	/**
	* Draws a circle with the specified radius at (x,y).
	* @param x
	* @param y
	* @param radius
	**/
	public function drawCircle( x : Float, y : Float, radius : Float ) : Graphics;
	
	/**
	* Draws an ellipse (oval).
	* @param x
	* @param y
	* @param w
	* @param h
	**/
	public function drawEllipse( x : Float, y : Float, w : Float, h : Float ) : Graphics;
	
	/**
	* Draws a star if pointSize is greater than 0 or a regular polygon if pointSize is 0 with the specified number of points.
	* For example, the following code will draw a familiar 5 pointed star shape centered at 100,100 and with a radius of 50:
	* myGraphics.beginFill("#FF0").drawPolyStar(100, 100, 50, 5, 0.6, -90); // -90 makes the first point vertical
	* @param x Position of the center of the shape.
	* @param y Position of the center of the shape.
	* @param radius The outer radius of the shape.
	* @param sides The number of points on the star or sides on the polygon.
	* @param pointSize The depth or "pointy-ness" of the star points. A pointSize of 0 will draw a regular polygon (no points), a 
	* pointSize of 1 will draw nothing because the points are infinitely pointy.
	* @param angle The angle of the first point / corner. For example a value of 0 will draw the first point directly to the right 
	* of the center.
	**/
	public function drawPolyStar( x : Float, y : Float, radius : Float, sides : Float, pointSize : Float, angle : Float ) : Graphics;
	
	public function clone() : Graphics;
		
	public function toString() : String;
	
	// tiny API:
		/** Shortcut to moveTo.
		* @property mt
		* @protected
		* type Function
		**/
	public function mt( x : Float, y : Float ) : Graphics;

		/** Shortcut to lineTo.
		* @property lt
		* @protected
		* type Function
		**/
	public function lt( x : Float, y : Float ) : Graphics;

		/** Shortcut to arcTo.
		* @property at
		* @protected
		* type Function
		**/
	public function at( x1 : Float, y1 : Float, x2 : Float, y2 : Float, radius : Float ) : Graphics;

		/** Shortcut to bezierCurveTo.
		* @property bt
		* @protected
		* type Function
		**/
	public function bt( cp1x : Float, cp1y : Float, cp2x : Float, cp2y : Float, x : Float, y : Float ) : Graphics;

		/** Shortcut to quadraticCurveTo / curveTo.
		* @property qt
		* @protected
		* type Function
		**/
	public function qt( cpx : Float, cpy : Float, x : Float, y : Float ) : Graphics;

		/** Shortcut to arc.
		* @property a
		* @protected
		* type Function
		**/
	public function a( x : Float, y : Float, radius : Float, startAngle : Float, endAngle : Float, ?anticlockwise : Bool ) : Graphics;
	

		/** Shortcut to rect.
		* @property r
		* @protected
		* type Function
		**/
	public function r( x : Float, y : Float, w : Float, h : Float ) : Graphics;

		/** Shortcut to closePath.
		* @property cp
		* @protected
		* type Function
		**/
	public function cp() : Graphics;

		/** Shortcut to clear.
		* @property c
		* @protected
		* type Function
		**/
	public function c() : Graphics;

		/** Shortcut to beginFill.
		* @property f
		* @protected
		* type Function
		**/
	public function f( color : String ) : Graphics;

		/** Shortcut to beginLinearGradientFill.
		* @property lf
		* @protected
		* type Function
		**/
	public function lf( colors : Array<String>, ratios : Array<Float>, x0 : Float, y0 : Float, 
		x1 : Float, y1 : Float ) : Graphics;

		/** Shortcut to beginRadialGradientFill.
		* @property rf
		* @protected
		* type Function
		**/
	public function rf( colors : Array<String>, ratios : Array<Float>, x0 : Float, y0 : Float, r0 : Float, 
		x1 : Float, y1 : Float, r1 : Float ) : Graphics;

		/** Shortcut to beginBitmapFill.
		* @property bf
		* @protected
		* type Function
		**/
	public function bf( image : Dynamic, ?repetition : String ) : Graphics;

		/** Shortcut to endFill.
		* @property ef
		* @protected
		* type Function
		**/
	public function ef() : Graphics;

		/** Shortcut to setStrokeStyle.
		* @property ss
		* @protected
		* type Function
		**/
	public function ss( thickness : Float, ?caps : String, ?joints : String, ?miterLimit : Float ) : Graphics;
	

		/** Shortcut to beginStroke.
		* @property s
		* @protected
		* type Function
		**/
	public function s( color : String ) : Graphics;

		/** Shortcut to beginLinearGradientStroke.
		* @property ls
		* @protected
		* type Function
		**/
	public function ls( colors : Array<String>, ratios : Array<Float>, x0 : Float, y0 : Float, 
		x1 : Float, y1 : Float ) : Graphics;

		/** Shortcut to beginRadialGradientStroke.
		* @property rs
		* @protected
		* type Function
		**/
	public function rs( colors : Array<String>, ratios : Array<Float>, x0 : Float, y0 : Float, 
		r0 : Float, x1 : Float, y1 : Float, r1 : Float ) : Graphics;

		/** Shortcut to beginBitmapStroke.
		* @property bs
		* @protected
		* type Function
		**/
	public function bs( image : Dynamic, ?repetition : String ) : Graphics;

		/** Shortcut to endStroke.
		* @property es
		* @protected
		* type Function
		**/
	public function es() : Graphics;

		/** Shortcut to drawRect.
		* @property dr
		* @protected
		* type Function
		**/
	public function dr( x : Float, y : Float, w : Float, h : Float ) : Graphics;

		/** Shortcut to drawRoundRect.
		* @property rr
		* @protected
		* type Function
		**/
	public function rr( x : Float, y : Float, w : Float, h : Float, radius : Float ) : Graphics;

		/** Shortcut to drawRoundRectComplex.
		* @property rc
		* @protected
		* type Function
		**/
	public function rc( x : Float, y : Float, w : Float, h : Float, 
		radiusTL : Float, radiusTR : Float, radiusBR : Float, radiusBL : Float ) : Graphics;

		/** Shortcut to drawCircle.
		* @property dc
		* @protected
		* type Function
		**/
	public function dc( x : Float, y : Float, radius : Float ) : Graphics;

		/** Shortcut to drawEllipse.
		* @property de
		* @protected
		* type Function
		**/
	public function de( x : Float, y : Float, w : Float, h : Float ) : Graphics;

		/** Shortcut to drawPolyStar.
		* @property dp
		* @protected
		* type Function
		**/
	public function dp( x : Float, y : Float, radius : Float, sides : Float, pointSize : Float, angle : Float ) : Graphics;
	
	
// GDS: clip?, isPointInPath?
	
}

extern class Command {
	
	public function new( f : String -> Dynamic -> Void, params : Array<Dynamic> ) : Void;
	
	public function exec( scope : Dynamic ) : Void;
	
}
