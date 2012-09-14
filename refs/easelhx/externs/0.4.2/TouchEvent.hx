package ;

import js.Dom;

/** From http://www.w3.org/TR/touch-events/ */
@:native("Touch") extern class Touch 
{
	var identifier(default,null) : Int;
	var target(default,null) : EventTarget;
	var screenX(default,null) : Int;
	var screenY(default,null) : Int;
	var clientX(default,null) : Int;
	var clientY(default,null) : Int;
	var pageX(default,null) : Int;
	var pageY(default,null) : Int;
}

/** From http://www.w3.org/TR/touch-events/ */
@:native("TouchList") extern class TouchList implements ArrayAccess<Touch> 
{
	var length(default,null) : Int;
	function identifiedTouch( identifier : Int ) : Touch;
}

/** From http://www.w3.org/TR/touch-events/ */
@:native("TouchEvent") extern class TouchEvent extends UIEvent 
{
	var touches(default,null) : TouchList;
	var targetTouches(default,null) : TouchList;
	var changedTouches(default,null) : TouchList;
	var altKey(default,null) : Bool;
	var metaKey(default,null) : Bool;
	var ctrlKey(default,null) : Bool;
	var shiftKey(default,null) : Bool;
}

/** From http://www.w3.org/TR/DOM-Level-3-Events/ */
@:native("UIEvent") extern class UIEvent extends Event {
	var view(default,null) : AbstractView;
	var detail(default,null) : Int;
	@:overload( function( typeArg : String, canBubbleArg : Bool, cancelableArg : Bool, viewArg : AbstractView, detailArg : Int ) : Void {})
	function initUIEvent( typeArg : String, canBubbleArg : Bool, cancelableArg : Bool, viewArg : AbstractView, detailArg : Int ) : Void;

}

/** From http://www.w3.org/TR/dom/ */
@:native("Event") extern class Event {
	function new( type : String, ?eventInitDict : EventInit ) : Void;

	var type(default,null) : String;
	var target(default,null) : Null<EventTarget>;
	var currentTarget(default,null) : Null<EventTarget>;
	static inline var CAPTURING_PHASE : Int = 1;
	static inline var AT_TARGET : Int = 2;
	static inline var BUBBLING_PHASE : Int = 3;
	var eventPhase(default,null) : Int;
	@:overload( function(  ) : Void {})
	@:overload( function(  ) : Void {})
	function stopPropagation() : Void;
	@:overload( function(  ) : Void {})
	@:overload( function(  ) : Void {})
	function stopImmediatePropagation() : Void;
	var bubbles(default,null) : Bool;
	var cancelable(default,null) : Bool;
	@:overload( function(  ) : Void {})
	@:overload( function(  ) : Void {})
	function preventDefault() : Void;
	var defaultPrevented(default,null) : Bool;
	var isTrusted(default,null) : Bool;
	var timeStamp(default,null) : Float;
	@:overload( function( eventTypeArg : String, canBubbleArg : Bool, cancelableArg : Bool ) : Void {})
	@:overload( function( eventTypeArg : String, canBubbleArg : Bool, cancelableArg : Bool ) : Void {})
	function initEvent( type : String, bubbles : Bool, cancelable : Bool ) : Void;
}

/** From http://www.w3.org/TR/dom/ */
@:native("EventInit") extern class EventInit {
	var bubbles : Bool;
	var cancelable : Bool;
}

/** From http://www.w3.org/TR/DOM-Level-2-Views/idl/views.idl */
@:native("AbstractView") extern class AbstractView {
	var document(default,null) : DocumentView;
}

/** From http://www.w3.org/TR/DOM-Level-2-Views/idl/views.idl */
@:native("DocumentView") extern class DocumentView {
	var defaultView(default,null) : AbstractView;
}


/** From http://www.w3.org/TR/dom/ */
@:native("EventTarget") extern class EventTarget 
{
	@:overload( function( type : String, listener : Event -> Void, ?useCapture : Bool ) : Void {})
	@:overload( function( type : String, listener : Event -> Void, useCapture : Bool ) : Void {})
	function addEventListener( type : String, callback_ : Null<Event -> Void>, ?capture : Bool ) : Void;
	@:overload( function( type : String, listener : Event -> Void, ?useCapture : Bool ) : Void {})
	@:overload( function( type : String, listener : Event -> Void, useCapture : Bool ) : Void {})
	function removeEventListener( type : String, callback_ : Null<Event -> Void>, ?capture : Bool ) : Void;
	@:overload( function( evt : Event ) : Bool {})
	@:overload( function( evt : Event ) : Bool {})
	function dispatchEvent( event : Event ) : Bool;
}