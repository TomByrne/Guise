package guise.skin.bitmap;

import guise.accessTypes.IBoxPosAccess;
import guise.accessTypes.ITextureAccess;
import guise.skin.common.PositionedLayer;

class TextureLayer extends PositionedLayer<TextureStyle>
{
	
	@injectAdd
	private function onPosAdd(access:IBoxPosAccess):Void {
		if (layerName != null && access.layerName != layerName) return;
		
		_pos = access;
		invalidate();
	}
	@injectRemove
	private function onPosRemove(access:IBoxPosAccess):Void {
		if (access != _pos) return;
		
		_pos = null;
	}

	@inject
	@:isVar private var textureAccess(default, set_textureAccess):ITextureAccess;
	private function set_textureAccess(value:ITextureAccess):ITextureAccess {
		textureAccess = value;
		invalidate();
		return value;
	}
	
	private var _pos:IBoxPosAccess;

	public function new(?layerName:String, ?normalStyle:TextureStyle) 
	{
		super(layerName, normalStyle);
	}
	
	override private function _isReadyToDraw():Bool {
		return _pos!=null && textureAccess != null && super._isReadyToDraw();
	}

	override private function _drawStyle():Void {
		switch(currentStyle) {
			case norm(texture):
				textureAccess.setTexture(texture);
				_pos.set(x,y,w,h);
			case pad(texture, padT, padL, padB, padR):
				if (Math.isNaN(padT)) padT = 0;
				if (Math.isNaN(padL)) padL = 0;
				if (Math.isNaN(padB)) padB = 0;
				if (Math.isNaN(padR)) padR = 0;
				textureAccess.setTexture(texture);
				_pos.set(x+padL,y+padT,w-padL-padR,h-padT-padB);
		}
	}
	
}
enum TextureStyle {
	norm(texture:TextureInfo);
	pad(texture:TextureInfo, ?padT:Float, ?padL:Float, ?padB:Float, ?padR:Float);
}
