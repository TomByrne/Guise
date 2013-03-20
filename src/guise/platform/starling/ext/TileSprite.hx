package guise.platform.starling.ext;


import starling.display.DisplayObject;
import starling.display.MovieClip;

import starling.display.Image;
import starling.display.Sprite;
import starling.textures.Texture;

import flash.Vector;
import flash.geom.Point;

class TileSprite extends Sprite {
	
	private static var DUMMY_POINT:Point;
	
	private var slices:Array<Array<Image>>;
	
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
	private var _texture:Texture;
	
	/**
	 * Creates a new <code>Scale9Sprite</code> instance whose image
	 * is contained in <code>data</code> and whose center slice is
	 * <code>rect</code>.
	 * 
	 * @param data The image to display
	 * @param rect The center slice
	 * */
	public function new(?texture:Texture){
		super();
		if (DUMMY_POINT == null) {
			DUMMY_POINT = new Point();
		}
		slices = [[]];
		setTextureStill(texture);
		//addChild(new starling.display.Quad(100, 100, 0xff0000));
	}
	private function clearOld():Void {
		if (slices.length>0) {
			for (col in slices) {
				for (img in col) {
					removeChild(img);
				}
			}
			slices = [[]];
		}
	}
	/*public function setTexturesAnim(fps:Int, textures:Vector<Texture>):Void {
		clearOld();
		
		if(!Math.isNaN(mWidth))setWidth(mWidth);
		if(!Math.isNaN(mHeight))setHeight(mHeight);
	}*/
	public function setTextureStill(texture:Texture):Void {
		clearOld();
		_texture = texture;
		if(!Math.isNaN(mWidth))setWidth(mWidth);
		if (!Math.isNaN(mHeight)) setHeight(mHeight);
	}
	
	/**
	 * The width of the image.
	 * */
	public function setWidth(value:Float):Float {
		if (_texture != null) {
			_cols = value / _texture.width;
			var colsRound = Math.ceil(_cols);
			if (slices.length > colsRound) {
				for (i in colsRound...slices.length) {
					var col = slices[i];
					for (img in col) {
						removeChild(img);
					}
				}
			}else if (slices.length < colsRound) {
				if(slices.length>0)setColUv(slices[slices.length - 1], 1);
				for (i in slices.length...colsRound) {
					var col = [];
					slices[i] = col;
					for (j in 0...Math.ceil(_rows)) {
						col[j] = createImage(i,j);
					}
				}
			}
			if(slices.length>0)setColUv(slices[slices.length - 1], _cols % 1);
			if(slices[0].length>0)setRowUv(slices, slices[0].length - 1, _rows % 1);
		}
		mWidth = value;
		return value;
	}
	public function getWidth():Float {
		return mWidth;
	}
	
	/**
	 * The height of the image.
	 * */
	public function setHeight(value:Float):Float{
		if (_texture != null) {
			_rows = value / _texture.width;
			var rowsRound = Math.ceil(_rows);
			var currRows:Int = (slices.length>0?slices[0].length:0);
			if (currRows > rowsRound) {
				for (col in slices) {
					for (j in rowsRound...currRows) {
						removeChild(col[j]);
					}
				}
			}else if (currRows < rowsRound) {
				if(currRows>0)setRowUv(slices, currRows - 1, 1);
				for (i in 0...slices.length) {
					var col = slices[i];
					for (j in currRows...rowsRound) {
						col[j] = createImage(i,j);
					}
				}
			}
			if(slices.length>0)setColUv(slices[slices.length - 1], _cols % 1);
			if(rowsRound>0)setRowUv(slices, rowsRound - 1, _rows % 1);
			
		}
		mHeight = value;
		return value;
	}
	public function getHeight():Float {
		return mHeight;
	}
	
	
	
	private function setColUv(col:Array<Image>, fract:Float):Void {
		if (fract == 0) fract = 1;
		for (img in col) {
			img.width = _texture.width * fract;
			DUMMY_POINT.x = fract;
			DUMMY_POINT.y = 0.0;
			img.setTexCoords(1, DUMMY_POINT);
			var corner = img.getTexCoords(3, DUMMY_POINT);
			DUMMY_POINT.x = fract;
			img.setTexCoords(3, DUMMY_POINT);
		}
	}
	private function setRowUv(slices:Array<Array<Image>>, index:Int, fract:Float):Void {
		if (fract == 0) fract = 1;
		for (col in slices) {
			var img = col[index];
			img.height = _texture.height * fract;
			DUMMY_POINT.x = 0.0;
			DUMMY_POINT.y = fract;
			img.setTexCoords(2, DUMMY_POINT);
			var corner = img.getTexCoords(3, DUMMY_POINT);
			DUMMY_POINT.y = fract;
			img.setTexCoords(3, DUMMY_POINT);
		}
	}
	
	private function createImage(col:Int, row:Int):Image {
		var img = new Image(_texture);
		img.x = col * _texture.width;
		img.y = row * _texture.height;
		img.width = _texture.width;
		img.height = _texture.height;
		addChild(img);
		return img;
	}
}
