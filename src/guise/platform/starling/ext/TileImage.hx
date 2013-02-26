// =================================================================================================
//
//	Starling Framework
//	Copyright 2011 Gamua OG. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package guise.platform.starling.ext;

import flash.display.Bitmap;
import flash.geom.Point;
import flash.geom.Rectangle;
import starling.display.Quad;

import starling.core.RenderSupport;
import starling.textures.Texture;
import starling.textures.TextureSmoothing;
import starling.utils.VertexData;

class TileImage extends Quad
{
	private var mTexture:Texture;
	private var mSmoothing:String;
	
	private var mVertexDataCache:VertexData;
	private var mVertexDataCacheInvalid:Bool;
	
	public function new(texture:Texture)
	{
		if (texture!=null)
		{
			var frame:Rectangle = texture.frame;
			var width:Float  = frame!=null ? frame.width  : texture.width;
			var height:Float = frame!=null ? frame.height : texture.height;
			var pma:Bool = texture.premultipliedAlpha;
			
			super(width, height, 0xffffff, pma);
			
			mVertexData.setTexCoords(0, 0.0, 0.0);
			mVertexData.setTexCoords(1, 1.0, 0.0);
			mVertexData.setTexCoords(2, 0.0, 1.0);
			mVertexData.setTexCoords(3, 1.0, 1.0);
			
			mTexture = texture;
			mSmoothing = TextureSmoothing.BILINEAR;
			mVertexDataCache = new VertexData(4, pma);
			mVertexDataCacheInvalid = true;
		}
		else
		{
			throw "Texture cannot be null";
		}
	}
	
	/** Creates an Image with a texture that is created from a bitmap object. */
	public static function fromBitmap(bitmap:Bitmap, generateMipMaps:Bool=true, 
									  scale:Float=1):TileImage
	{
		return new TileImage(Texture.fromBitmap(bitmap, generateMipMaps, false, scale));
	}
	
	/** @inheritDoc */
	private override function onVertexDataChanged():Void
	{
		mVertexDataCacheInvalid = true;
	}
	
	/** Readjusts the dimensions of the image according to its current texture. Call this method 
	 *  to synchronize image and texture size after assigning a texture with a different size.*/
	public function readjustSize():Void
	{
		var frame:Rectangle = texture.frame;
		var width:Float  = frame ? frame.width  : texture.width;
		var height:Float = frame ? frame.height : texture.height;
		
		mVertexData.setPosition(0, 0.0, 0.0);
		mVertexData.setPosition(1, width, 0.0);
		mVertexData.setPosition(2, 0.0, height);
		mVertexData.setPosition(3, width, height); 
		
		onVertexDataChanged();
	}
	
	/** Sets the texture coordinates of a vertex. Coordinates are in the range [0, 1]. */
	public function setTexCoords(vertexID:Int, coords:Point):Void
	{
		mVertexData.setTexCoords(vertexID, coords.x, coords.y);
		onVertexDataChanged();
	}
	
	/** Gets the texture coordinates of a vertex. Coordinates are in the range [0, 1]. 
	 *  If you pass a 'resultPoint', the result will be stored in this point instead of 
	 *  creating a new object.*/
	public function getTexCoords(vertexID:Int, resultPoint:Point=null):Point
	{
		if (resultPoint == null) resultPoint = new Point();
		mVertexData.getTexCoords(vertexID, resultPoint);
		return resultPoint;
	}
	
	/** Copies the raw vertex data to a VertexData instance.
	 *  The texture coordinates are already in the format required for rendering. */ 
	public override function copyVertexDataTo(targetData:VertexData, targetVertexID:Int=0):Void
	{
		if (mVertexDataCacheInvalid)
		{
			mVertexDataCacheInvalid = false;
			mVertexData.copyTo(mVertexDataCache);
			mTexture.adjustVertexData(mVertexDataCache, 0, 4);
		}
		
		mVertexDataCache.copyTo(targetData, targetVertexID);
	}
	
	/** The texture that is displayed on the quad. */
	@:isVar public var texture(default, set):Texture;
	private function set_texture(value:Texture):Texture 
	{ 
		if (value == null)
		{
			throw "Texture cannot be null";
		}
		else if (value != mTexture)
		{
			mTexture = value;
			mVertexData.setPremultipliedAlpha(mTexture.premultipliedAlpha);
			onVertexDataChanged();
		}
		return value;
	}
	
	/** The smoothing filter that is used for the texture. 
	*   @default bilinear
	*   @see starling.textures.TextureSmoothing */ 
	@:isVar public var smoothing(default, set):String;
	private function set_smoothing(value:String):String 
	{
		if (TextureSmoothing.isValid(value))
			mSmoothing = value;
		else
			throw "Invalid smoothing mode: " + value;
		return value;
	}
	
	/** @inheritDoc */
	public override function render(support:RenderSupport, parentAlpha:Float):Void
	{
		support.batchQuad(this, parentAlpha, mTexture, mSmoothing);
	}
}