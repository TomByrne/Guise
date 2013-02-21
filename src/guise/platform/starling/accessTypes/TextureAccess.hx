package guise.platform.starling.accessTypes;
import composure.traits.AbstractTrait;
import guise.accessTypes.IBoxPosAccess;
import guise.accessTypes.ITextureAccess;
import guise.platform.starling.addTypes.IDisplayObjectType;
import guise.platform.starling.ext.Scale9Sprite;
import guise.platform.starling.ext.TileSprite;
import starling.display.Image;
import guise.skin.bitmap.utils.TexturePack;
import starling.display.DisplayObject;
import starling.display.MovieClip;
import starling.display.Sprite;
import starling.textures.Texture;

class TextureAccess extends AbstractTrait, implements ITextureAccess, implements IDisplayObjectType, implements IBoxPosAccess
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
	
	public var layerName(default, set_layerName):String;
	private function set_layerName(value:String):String {
		this.layerName = value;
		_sprite.name = value == null?"":value;
		return value;
	}
	
	private var _sprite:Sprite;
	private var _textureInfo:TextureInfo;
	private var _width:Float;
	private var _height:Float;

	public function new(?layerName:String) 
	{
		super();
		_sprite = new Sprite();
		this.layerName = layerName;
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
		var getTexture = texturePack.pack.getTexture;
		var getTextures = texturePack.pack.getTextures;
		
		switch(_textureInfo) {
			case tile(textureId):
				var tileSprite:TileSprite = new TileSprite(getTexture(textureId));
				sizeChild(tileSprite);
				_sprite.addChild(tileSprite);
				
			case sprite(textureId, scale9):
				if (scale9) {
					var scale9 = new Scale9Sprite();
					
					scale9.setTextureStill(getTexture(textureId + "-tl"), getTexture(textureId + "-tc"), getTexture(textureId + "-tr"),
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
	public function setPos(x:Float, y:Float):Void {
		_sprite.x = x;
		_sprite.y = y;
	}
	public function set(x:Float, y:Float, w:Float, h:Float):Void {
		_sprite.x = x;
		_sprite.y = y;
		setSize(w,h);
	}
	public function setSize(width:Float, height:Float):Void {
		_width = width;
		_height = height;
		for (i in 0..._sprite.numChildren) {
			var child = _sprite.getChildAt(i);
			sizeChild(child);
		}
	}
	
	private function sizeChild(child:DisplayObject):Void {
		if (Math.isNaN(_width) || Math.isNaN(_height)) return;
		
		if (Std.is(child, TileSprite)) {
			var tileSprite:TileSprite = cast child;
			tileSprite.setWidth(_width);
			tileSprite.setHeight(_height);
		}else if (Std.is(child, Scale9Sprite)) {
			var scale9:Scale9Sprite = cast child;
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