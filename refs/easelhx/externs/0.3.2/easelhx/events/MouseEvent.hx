/**
* MouseEvent by Grant Skinner. Dec 5, 2010
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
package easelhx.events;

@:native("MouseEvent")
class MouseEvent {
	
	public function new( type:String, stageX:Float, stageY:Float ) : Void;
	
	/**
	* The mouseX position on the stage.
	* @property stageX
	* @type Number
	*/
	public var stageX( default, default ) : Float;
	
	/**
	* The mouseY position on the stage.
	* @property stageY
	* @type Number
	**/
	public var stageY( default, default ) : Float;
	
	/**
	* The type of mouse event. This will be the same as the handler it maps to (onPress, 
	* onMouseDown, onMouseUp, onMouseMove, or onClick).
	* @property type
	* @type String
	**/
	public var type( default, default ) : String;
	
	/**
	* For events of type "onPress" and "onMouseDown" only you can assign a handler to the onMouseMove 
	* property. This handler will be called every time the mouse is moved until the mouse is released. 
	* This is useful for operations such as drag and drop.
	* @event onMouseMove
	* @param {MouseEvent} event A MouseEvent instance with information about the current mouse event.
	**/
	public var onMouseMove( default, default ) : MouseEvent;
	
	/**
	* For events of type "onPress" and "onMouseDown" only you can assign a handler to the onMouseUp 
	* property. This handler will be called every time the mouse is moved until the mouse is released. 
	* This is useful for operations such as drag and drop.
	* @event onMouseUp
	* @param {MouseEvent} event A Mouse
	*  Event instance with information about the current mouse event.
	*/
	public var onMouseUp( default, default ) : MouseEvent;
	
	/**
	* Returns a clone of the MouseEvent instance.
	* @method clone
	* @return {MouseEvent} a clone of the MouseEvent instance.
	**/
	public function clone() : MouseEvent;
	
	/**
	* Returns a string representation of this object.
	* @method toString
	* @return {String} a string representation of the instance.
	**/
	public function toString() : String;

}