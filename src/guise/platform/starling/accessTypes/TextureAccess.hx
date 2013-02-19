package guise.platform.starling.accessTypes;
import composure.traits.AbstractTrait;
import guise.accessTypes.ITextureAccess;
import guise.platform.starling.addTypes.IDisplayObjectType;
import guise.platform.starling.ext.Scale9Sprite;
import starling.display.Image;
import guise.skin.bitmap.utils.TexturePack;
import starling.display.DisplayObject;
import starling.display.MovieClip;
import starling.display.Sprite;
import starling.textures.Texture;

class TextureAccess extends AbstractTrait, implements ITextureAccess, implements IDisplayObjectType
{
	@inject( { asc : true } )
	private var texturePack(default, set_texturePack):TexturePack;
	private function set_texturePack(value:TexturePack):TexturePack {
		if (texturePack != null) {
			texturePack.changed.remove(onPackChanged);
		}
		texturePack = value;
		if (texturePack != null) {
			texturePack.changed.add(onPackChanged);
			checkTexture();
		}
		return value;
	}
	
	private var _sprite:Sprite;
	private var _textureInfo:TextureInfo;
	private var _width:Float;
	private var _height:Float;

	public function new() 
	{
		super();
		_sprite = new Sprite();
	}
	
	public function setSize(width:Float, height:Float):Void {
		_width = width;
		_height = height;
		for (i in 0..._sprite.numChildren) {
			var child = _sprite.getChildAt(i);
			sizeChild(child);
		}
	}
	public function setTexture(value:TextureInfo):Void {
		if (_textureInfo == value) return;
		_textureInfo = value;
		checkTexture();
	}
	private function onPackChanged(from:TexturePack):Void {
		checkTexture();
	}
	public function checkTexture():Void {
		if (texturePack == null || texturePack.pack==null || _textureInfo == null) return;
		
		while (_sprite.numChildren>0) {
			_sprite.removeChildAt(0);
		}
		
		switch(_textureInfo) {
			case sprite(textureId, scale9):
				var getTexture = texturePack.pack.getTexture;
				if (scale9) {
					var scale9 = new Scale9Sprite();
					
					scale9.setTexturesStill(getTexture(textureId + "-tl"), getTexture(textureId + "-tc"), getTexture(textureId + "-tr"),
											getTexture(textureId + "-ml"), getTexture(textureId + "-mc"), getTexture(textureId + "-mr"),
											getTexture(textureId + "-bl"), getTexture(textureId + "-bc"), getTexture(textureId + "-br"));
					_sprite.addChild(scale9);
					sizeChild(scale9);
				}else {
					var img = new Image(getTexture(textureId));
					_sprite.addChild(img);
					sizeChild(img);
				}
			case clip(textureId, fps, scale9):
				var getTextures = texturePack.pack.getTextures;
				if (scale9) {
					var scale9 = new Scale9Sprite();
					
					scale9.setTexturesAnim(fps, getTextures(textureId + "-tl"), getTextures(textureId + "-tc"), getTextures(textureId + "-tr"),
												getTextures(textureId + "-ml"), getTextures(textureId + "-mc"), getTextures(textureId + "-mr"),
												getTextures(textureId + "-bl"), getTextures(textureId + "-bc"), getTextures(textureId + "-br"));
					_sprite.addChild(scale9);
					sizeChild(scale9);
				}else {
					var clip = new MovieClip(getTextures(textureId), fps);
					_sprite.addChild(clip);
					sizeChild(clip);
				}
		}
	}
	
	private function sizeChild(child:DisplayObject):Void {
		if (Std.is(child, Scale9Sprite)) {
			var scale9 = cast child;
			scale9.setWidth(_width);
			scale9.setHeight(_height);
		}else {
			child.width = _width;
			child.height = _height;
		}
	}
	public function getDisplayObject():DisplayObject{
		return _sprite;
	}
}