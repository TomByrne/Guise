// from http://code.google.com/p/udraw/
/**
 * ...
 * @author Franco Ponticelli
 */

package js;

import js.Dom;

extern class CanvasRenderingContext2D
{
	// back-reference
	public var canvas(default, null) : DomCanvas;
	
	// state
	public function save() : Void;
	public function restore() : Void;
	
	// transformations
	public function scale(x : Float, y : Float) : Void;
	public function rotate(angle : Float) : Void;
	public function translate(x : Float, y : Float) : Void;
	public function transform(m11 : Float, m12 : Float, m21 : Float, m22 : Float, dx : Float, dy : Float) : Void;
	public function setTransform(m11 : Float, m12 : Float, m21 : Float, m22 : Float, dx : Float, dy : Float) : Void;
	
	// compositing
	public var globalAlpha : Float;
	public var globalCompositeOperation : String;
	
	// colors and styles
	public var strokeStyle : Dynamic;
	public var fillStyle : Dynamic;
	
	// line caps/joins
	public var lineWidth : Float; // (default 1)
	public var lineCap : String; // "butt", "round", "square" (default "butt")
	public var lineJoin : String; // "round", "bevel", "miter" (default "miter")
	public var miterLimit : Float; // (default 10)
	
	// line API
	public function beginPath() : Void;
	public function closePath() : Void;
	public function moveTo(x : Float, y : Float) : Void;
	public function lineTo(x : Float, y : Float) : Void;
	public function quadraticCurveTo(cpx : Float, cpy : Float, x : Float, y : Float) : Void;
	public function bezierCurveTo(cp1x : Float, cp1y : Float, cp2x : Float, cp2y : Float, x : Float, y : Float) : Void;
	public function arcTo(x1 : Float, y1 : Float, x2 : Float, y2 : Float, radius : Float) : Void;
	public function rect(x : Float, y : Float, w : Float, h : Float) : Void;
	public function arc(x : Float, y : Float, radius : Float, startAngle : Float, endAngle : Float, anticlockwise : Bool) : Void;
	public function fill() : Void;
	public function stroke() : Void;
	public function clip() : Void;
	public function isPointInPath(x : Float, y : Float) : Bool;
	
	// rects
  public function clearRect(x : Float, y : Float, w : Float, h : Float) : Void;
  public function fillRect(x : Float, y : Float, w : Float, h : Float) : Void;
  public function strokeRect(x : Float, y : Float, w : Float, h : Float) : Void;
}

/*
  // colors and styles
  CanvasGradient createLinearGradient(in float x0, in float y0, in float x1, in float y1);
  CanvasGradient createRadialGradient(in float x0, in float y0, in float r0, in float x1, in float y1, in float r1);
  CanvasPattern createPattern(in HTMLImageElement image, in DOMString repetition);
  CanvasPattern createPattern(in HTMLCanvasElement image, in DOMString repetition);
  CanvasPattern createPattern(in HTMLVideoElement image, in DOMString repetition);

  // shadows
           attribute float shadowOffsetX; // (default 0)
           attribute float shadowOffsetY; // (default 0)
           attribute float shadowBlur; // (default 0)
           attribute DOMString shadowColor; // (default transparent black)

  // rects
  void clearRect(in float x, in float y, in float w, in float h);
  void fillRect(in float x, in float y, in float w, in float h);
  void strokeRect(in float x, in float y, in float w, in float h);

  // focus management
  boolean drawFocusRing(in Element element, in float xCaret, in float yCaret, in optional boolean canDrawCustom);

  // text
           attribute DOMString font; // (default 10px sans-serif)
           attribute DOMString textAlign; // "start", "end", "left", "right", "center" (default: "start")
           attribute DOMString textBaseline; // "top", "hanging", "middle", "alphabetic", "ideographic", "bottom" (default: "alphabetic")
  void fillText(in DOMString text, in float x, in float y, in optional float maxWidth);
  void strokeText(in DOMString text, in float x, in float y, in optional float maxWidth);
  TextMetrics measureText(in DOMString text);

  // drawing images
  void drawImage(in HTMLImageElement image, in float dx, in float dy, in optional float dw, in float dh);
  void drawImage(in HTMLImageElement image, in float sx, in float sy, in float sw, in float sh, in float dx, in float dy, in float dw, in float dh);
  void drawImage(in HTMLCanvasElement image, in float dx, in float dy, in optional float dw, in float dh);
  void drawImage(in HTMLCanvasElement image, in float sx, in float sy, in float sw, in float sh, in float dx, in float dy, in float dw, in float dh);
  void drawImage(in HTMLVideoElement image, in float dx, in float dy, in optional float dw, in float dh);
  void drawImage(in HTMLVideoElement image, in float sx, in float sy, in float sw, in float sh, in float dx, in float dy, in float dw, in float dh);

  // pixel manipulation
  ImageData createImageData(in float sw, in float sh);
  ImageData createImageData(in ImageData imagedata);
  ImageData getImageData(in float sx, in float sy, in float sw, in float sh);
  void putImageData(in ImageData imagedata, in float dx, in float dy, in optional float dirtyX, in float dirtyY, in float dirtyWidth, in float dirtyHeight);
};

interface CanvasGradient {
  // opaque object
  void addColorStop(in float offset, in DOMString color);
};

interface CanvasPattern {
  // opaque object
};

interface TextMetrics {
  readonly attribute float width;
};

interface ImageData {
  readonly attribute unsigned long width;
  readonly attribute unsigned long height;
  readonly attribute CanvasPixelArray data;
};

interface CanvasPixelArray {
  readonly attribute unsigned long length;
  getter octet (in unsigned long index);
  setter void (in unsigned long index, in octet value);
};
*/