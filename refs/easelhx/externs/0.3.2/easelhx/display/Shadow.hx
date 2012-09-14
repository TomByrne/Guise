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

@:native("Shadow")
extern class Shadow {

// static public properties:
	/**
	* An identity shadow object (all properties are set to 0). Read-only.
	* @static
	**/
	public static var identity : Shadow;
	
// public properties:
	/** The blur of the shadow. **/
	public var blur( default, default ) : Float;
	
	/** The color of the shadow. **/
	public var color( default, default ) : Int;
	
	/** The x offset of the shadow. **/
	public var offsetX( default, default ) : Float;
	
	/** The y offset of the shadow. **/
	public var offsetY( default, default ) : Float;
	
// constructor:
	/**
	* Constructs a new Shadow object.
	* @param color The color of the shadow.
	* @param offsetX The x offset of the shadow.
	* @param offsetY The y offset of the shadow.
	* @param blur The blur of the shadow.
	* @class Encapsulates the properties required to define a shadow to apply to a DisplayObject via it's .shadow property.
	**/
	public function new( color : Int, offsetX : Float, offsetY : Float, blur : Float ) : Void;
	
// public methods:
	/**
	* Returns a string representation of this object.
	**/
	public function toString() : String;
	
	/**
	* Returns a clone of this object.
	**/
	public function clone() : Shadow;
	
}
