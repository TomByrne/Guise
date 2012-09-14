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
package easelhx.geom;
import easelhx.display.Shadow;

@:native("Matrix2D")
extern class Matrix2D {

// static public properties:
	/**
	* An identity matrix, representing a null transformation. Read-only.
	* @static
	**/
	//TODO: haXe issue: can't have property and method with the same name - request JS change
	//public static var identity : Matrix2D;
	
	public static var DEG_TO_RAD:Float;
	
// public properties:
	/** Position 0,0 in an affine transformation Matrix. Maps roughly to scaleX, but is also involved in rotation. **/
	public var a( default, default ) : Float;
	
	/** Position 0,1 in an affine transformation Matrix. Used in rotation (also skewing, but not supported in Easel). **/
	public var b( default, default ) : Float;
	
	/** Position 1,0 in an affine transformation Matrix. Used in rotation (also skewing, but not supported in Easel). **/
	public var c( default, default ) : Float;
	
	/** Position 1,1 in an affine transformation Matrix. Maps roughly to scaleY, but is also involved in rotation. **/
	public var d( default, default ) : Float;
	
	/** Position 2,0 in an affine transformation Matrix. Translation along the x axis. **/
	public var tx( default, default ) : Float;
	
	/** Position 2,1 in an affine transformation Matrix. Translation along the y axis **/
	public var ty( default, default ) : Float;
	
	/**
	* Property representing the alpha that will be applied to a display object. This is not part of matrix 
	* operations, but is used for operations like getConcatenatedMatrix to provide concatenated alpha values.
	* @property alpha
	* @type Number
	**/
	public var alpha( default, default ) : Float;
	
	/**
	* Property representing the shadow that will be applied to a display object. This is not part of matrix
	* operations, but is used for operations like getConcatenatedMatrix to provide concatenated shadow values.
	* @property shadow
	* @type Shadow
	**/
	public var shadow( default, default ) : Shadow;
	
	/**
	* Property representing the compositeOperation that will be applied to a display object. This is not part of
	* matrix operations, but is used for operations like getConcatenatedMatrix to provide concatenated 
	* compositeOperation values. You can find a list of valid composite operations at:
	* <a href="https://developer.mozilla.org/en/Canvas_tutorial/Compositing">https://developer.mozilla.org/en/Canvas_tutorial/Compositing</a>
	* @property compositeOperation
	* @type String
	**/
	public var compositeOperation( default, default ) : String;
	
// constructor:
	/**
	* Constructs a new Matrix2D instance.
	* @param a Specifies the a property for the new matrix.
	* @param b Specifies the b property for the new matrix.
	* @param c Specifies the c property for the new matrix.
	* @param d Specifies the d property for the new matrix.
	* @param tx Specifies the tx property for the new matrix.
	* @param ty Specifies the ty property for the new matrix.
	* @class Represents an affine tranformation matrix, and provides tools for constructing and concatenating matrixes.
	**/
	public function new( ?a : Float, ?b : Float, ?c : Float, ?d : Float, ?tx : Float, ?ty : Float ) : Void;
	
// public methods:

	/**
	* Concatenates the specified matrix properties with this matrix. All parameters are required.
	* @method prepend
	* @param {Number} a
	* @param {Number} b
	* @param {Number} c
	* @param {Number} d
	* @param {Number} tx
	* @param {Number} ty
	**/
	public function prepend(a:Float, b:Float, c:Float, d:Float, tx:Float, ty:Float ) : Void;

	/**
	* Appends the specified matrix properties with this matrix. All parameters are required.
	* @method append
	* @param {Number} a
	* @param {Number} b
	* @param {Number} c
	* @param {Number} d
	* @param {Number} tx
	* @param {Number} ty
	**/
	public function append(a:Float, b:Float, c:Float, d:Float, tx:Float, ty:Float ) : Void;
	
	/**
	* Prepends the specified matrix with this matrix.
	* @method prependMatrix
	* @param {Matrix2D} matrix
	**/
	public function prependMatrix( matrix : Matrix2D ) : Void;
	
	/**
	* Appends the specified matrix with this matrix.
	* @method appendMatrix
	* @param {Matrix2D} matrix
	**/
	public function appendMatrix( matrix : Matrix2D ) : Void;
	
	/**
	* Generates matrix properties from the specified display object transform properties, and prepends them with this matrix.
	* For example, you can use this to generate a matrix from a display object: var mtx = new Matrix2D(); 
	* mtx.prependTransform(o.x, o.y, o.scaleX, o.scaleY, o.rotation);
	* @method prependTransform
	* @param {Number} x
	* @param {Number} y
	* @param {Number} scaleX
	* @param {Number} scaleY
	* @param {Number} rotation
	* @param {Number} skewX
	* @param {Number} skewY
	* @param {Number} regX Optional.
	* @param {Number} regY Optional.
	**/
	public function prependTransform(x:Float, y:Float, scaleX:Float, scaleY:Float, rotation:Float, skewX:Float, skewY:Float, regX:Float, regY:Float) : Void;

	/**
	* Generates matrix properties from the specified display object transform properties, and appends them with this matrix.
	* For example, you can use this to generate a matrix from a display object: var mtx = new Matrix2D(); 
	* mtx.appendTransform(o.x, o.y, o.scaleX, o.scaleY, o.rotation);
	* @method appendTransform
	* @param {Number} x
	* @param {Number} y
	* @param {Number} scaleX
	* @param {Number} scaleY
	* @param {Number} rotation
	* @param {Number} skewX
	* @param {Number} skewY
	* @param {Number} regX Optional.
	* @param {Number} regY Optional.
	**/
	public function appendTransform(x:Float, y:Float, scaleX:Float, scaleY:Float, rotation:Float, skewX:Float, skewY:Float, regX:Float, regY:Float) : Void;
	
	/**
	* Applies a skew transformation to the matrix.
	* @method skew
	* @param {Number} skewX The amount to skew horizontally in degrees.
	* @param {Number} skewY The amount to skew vertically in degrees.
	*/
	public function skew(skewX:Float, skewY:Float):Void;
	
	/**
	* Applies a scale transformation to the matrix.
	* @method scale
	* @param {Number} x
	* @param {Number} y
	**/
	public function scale(x:Float, y:Float):Void;
	
	/**
	* Translates the matrix on the x and y axes.
	* @method translate
	* @param {Number} x
	* @param {Number} y
	**/
	public function translate(x:Float, y:Float):Void;
	
	/**
	* Concatenates the specified matrix properties with this matrix. You must provide values for all of the parameters.
	**/
//	public function concat( a : Float, b : Float, c : Float, d : Float, tx : Float, ty : Float ) : Void;
	
	/**
	* Concatenates the specified matrix with this matrix.
	**/
//	public function concatMatrix( matrix : Matrix2D ) : Void;
	// TODO: this returns concat, but concat is Void ??
	//{
	//	return this.concat(matrix.a, matrix.b, matrix.c, matrix.d, matrix.tx, matrix.ty);
	//}
	
	/**
	* Generates matrix properties from the specified display object transform properties, and concatenates them with this matrix.
	* For example, you can use this to generate a matrix from a display object: var mtx = new Matrix2D(); 
	* mtx.concatTransform(o.x, o.y, o.scaleX, o.scaleY, o.rotation);
	* @param x
	* @param y
	* @param scaleX
	* @param scaleY
	* @param rotation
	* @param regX Optional.
	* @param regY Optional.
	**/
//	public function concatTransform( x : Float, y : Float, scaleX : Float, scaleY : Float, rotation : Float, 
//		?regX : Float, ?regY : Float ) : Void;
	
	/**
	* Applies a rotation transformation to the matrix.
	**/
	public function rotate( angle : Float ) : Void;
	
	
	/**
	* Sets the properties of the matrix to those of an identity matrix (one that applies a null transformation).
	**/
	public function identity() : Void;
	
	/**
	* Inverts the matrix, causing it to perform the opposite transformation.
	**/
	public function invert() : Void;
	
	/**
	* Decomposes the matrix into transform properties (x, y, scaleX, scaleY, and rotation). Note that this these values
	* may not match the transform properties you used to generate the matrix, though they will produce the same visual
	* results.
	* @method decompose
	* @param {Object} target The object to apply the transform properties to. If null, then a new object will be returned.
	*/
	public function decompose(target:Dynamic) : Void;
	
	/**
	* Appends the specified visual properties to the current matrix.
	* @method appendProperties
	* @param {Number} alpha desired alpha value
	* @param {Shadow} shadow desired shadow value
	* @param {String} compositeOperation desired composite operation value
	*/
	public function appendProperties(alpha:Float, shadow:Shadow, compositeOperation:String) : Void;
	
	/**
	 * Prepends the specified visual properties to the current matrix.
	* @method prependProperties
	* @param {Number} alpha desired alpha value
	* @param {Shadow} shadow desired shadow value
	* @param {String} compositeOperation desired composite operation value
	*/
	public function prependProperties(alpha:Float, shadow:Shadow, compositeOperation:String) : Void;
	
	/**
	* Returns a clone of this Matrix.
	**/
	public function clone() : Matrix2D;

	/**
	* Returns a string representation of this object.
	**/
	public function toString() : String;
	
}