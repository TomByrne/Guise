package guise.platform.nme.ext;


import guise.platform.GeomApi;
import nme.display.DisplayObject;
import nme.display.MovieClip;

import nme.display.Bitmap;
import nme.display.Sprite;
import nme.display.BitmapData;

class TileSprite extends Sprite {
	
	private static var DUMMY_MATRIX:Matrix;
	
	/**
	 * The width of the image.
	 * 
	 * @private
	 * */
	private var mWidth:Float;
	
	/**
	 * The height of the image.
	 * 
	 * @private
	 * */
	private var mHeight:Float;
	
	private var _rows:Float;
	private var _cols:Float;
	private var _texture:BitmapData;
	
	public function new(?texture:BitmapData){
		super();
		setTextureStill(texture);
	}
	public function setTextureStill(texture:BitmapData):Void {
		_texture = texture;
		draw();
	}
	
	/**
	 * The width of the image.
	 * */
	public function setWidth(value:Float):Float {
		mWidth = value;
		draw();
		return value;
	}
	public function getWidth():Float {
		return mWidth;
	}
	
	/**
	 * The height of the image.
	 * */
	public function setHeight(value:Float):Float{
		mHeight = value;
		draw();
		return value;
	}
	public function getHeight():Float {
		return mHeight;
	}
	
	
	private function draw():Void {
		graphics.clear();
		if (_texture == null || Math.isNaN(mWidth) || Math.isNaN(mHeight)) {
			return;
		}
		graphics.beginBitmapFill(_texture);
		graphics.drawRect(0,0,mWidth, mHeight);
	}
}
