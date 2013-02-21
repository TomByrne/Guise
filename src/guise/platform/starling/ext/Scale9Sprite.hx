package guise.platform.starling.ext;


// Copyright (C) 2012 Blue Pichu
//	
// Permission is hereby granted, free of charge, to any person obtaining a copy 
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is furnished
// to do so, subject to the following conditions:	
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//	
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
// INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
// PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
// FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
// OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
// DEALINGS IN THE SOFTWARE.
//
// Last edited Aug 21 2012

import nme.display.BitmapData;
import nme.geom.Point;
import nme.geom.Rectangle;
import starling.display.DisplayObject;
import starling.display.MovieClip;

import starling.display.Image;
import starling.display.Sprite;
import starling.textures.Texture;

import flash.Vector;

/**
 * The <code>Scale9Sprte</code> class allows for an image
 * to be scaled without scaling the corners; this is helpful
 * when scaling rounded rectangles in order to keep the radius
 * on the corners square and constant size.
 * */
class Scale9Sprite extends Sprite{
	/**
	 * An array of <code>DisplayObject</code> objects that are the
	 * nine slices of the image.
	 * 
	 * @private
	 * */
	private var slices:Array<DisplayObject>;
	
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
	
	private var minWidth:Float;
	private var minHeight:Float;
	private var topHeight:Float;
	private var leftWidth:Float;
	
	/**
	 * Creates a new <code>Scale9Sprite</code> instance whose image
	 * is contained in <code>data</code> and whose center slice is
	 * <code>rect</code>.
	 * 
	 * @param data The image to display
	 * @param rect The center slice
	 * */
	public function new(){
		super();
		//addChild(new starling.display.Quad(100, 100, 0xff0000));
	}
	private function clearOld():Void {
		if (slices != null) {
			for (img in slices) {
				removeChild(img);
			}
			slices = null;
		}
	}
	public function setTexturesAnim(fps:Int, tl:Vector<Texture>, tc:Vector<Texture>, tr:Vector<Texture>,
											 ml:Vector<Texture>, mc:Vector<Texture>, mr:Vector<Texture>,
											 bl:Vector<Texture>, bc:Vector<Texture>, br:Vector<Texture>):Void {
		clearOld();
		
		setMetrics(tl[0], tc[0], tr[0], ml[0], mc[0], mr[0], bl[0], bc[0], br[0]);
		
		var textures = [tl,tc,tr,ml,mc,mr,bl,bc,br];
		slices = new Array();
		for(i in 0...9){
			var img = new MovieClip(textures[i], fps);
			slices[i] = img;
			this.addChild(img);
		}
		initPos();
		
		if(!Math.isNaN(mWidth))setWidth(mWidth);
		if(!Math.isNaN(mHeight))setHeight(mHeight);
	}
	public function setTextureStill(tl:Texture, tc:Texture, tr:Texture,
									 ml:Texture, mc:Texture, mr:Texture,
									 bl:Texture, bc:Texture, br:Texture):Void {
		clearOld();
		
		
		setMetrics(tl, tc, tr, ml, mc, mr, bl, bc, br);
		
		var textures = [tl,tc,tr,ml,mc,mr,bl,bc,br];
		slices = new Array();
		for(i in 0...9){
			var img = new Image(textures[i]);
			slices[i] = img;
			this.addChild(img);
		}
		initPos();
		
		if(!Math.isNaN(mWidth))setWidth(mWidth);
		if(!Math.isNaN(mHeight))setHeight(mHeight);
	}
	public function setMetrics(  tl:Texture, tc:Texture, tr:Texture,
								 ml:Texture, mc:Texture, mr:Texture,
								 bl:Texture, bc:Texture, br:Texture):Void {
		
		//set initial width and height
		mWidth = tl.width + tc.width + tr.width;
		mHeight = tl.height + ml.height + bl.height;
		leftWidth = tl.width;
		topHeight = tl.height;
		minWidth = mWidth - mc.width;
		minHeight = mHeight - mc.height;
		
	}
	public function initPos():Void {
		
		slices[1].x = slices[4].x = slices[7].x = leftWidth;
		slices[3].y = slices[4].y = slices[5].y = topHeight;
	}
	
	/**
	 * The width of the image.
	 * */
	public function setWidth(value:Float):Float {
		if(slices!=null){
			if(value < minWidth){
				slices[1].visible = slices[4].visible = slices[7].visible = false;
				slices[0].width = slices[3].width = slices[6].width = (leftWidth/minWidth)*value;
				slices[2].width = slices[5].width = slices[8].width = (1-(leftWidth/minWidth))*value;
			}else{
				slices[4].visible = (mHeight > minHeight);
				slices[1].visible = slices[7].visible = true;
				slices[0].width = slices[3].width = slices[6].width = leftWidth;
				slices[2].width = slices[5].width = slices[8].width = minWidth-leftWidth;
				
				slices[1].width = slices[4].width = slices[7].width = value - slices[0].width - slices[2].width + 1;
			}
			slices[2].x = slices[5].x = slices[8].x = value - slices[2].width;
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
		if(slices!=null){
			if(value < minHeight){
				slices[3].visible = slices[4].visible = slices[5].visible = false;
				slices[0].height = slices[1].height = slices[2].height = (topHeight/minHeight)*value;
				slices[6].height = slices[7].height = slices[8].height = (1-(topHeight/minHeight))*value;
			}else {
				slices[4].visible = (mWidth > minWidth);
				slices[3].visible = slices[5].visible = true;
				slices[0].height = slices[1].height = slices[2].height = topHeight;
				slices[6].height = slices[7].height = slices[8].height = minHeight-topHeight;
				
				slices[3].height = slices[4].height = slices[5].height = value - slices[0].height - slices[6].height + 2;
			}
			slices[6].y = slices[7].y = slices[8].y = value - slices[6].height;
		}
		mHeight = value;
		return value;
	}
	public function getHeight():Float {
		return mHeight;
	}
}
