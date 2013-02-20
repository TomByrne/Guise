package guise.skin.bitmap;

import guise.accessTypes.IBoxPosAccess;
import guise.accessTypes.ITextureAccess;
import guise.platform.cross.IAccessRequest;
import guise.skin.common.PositionedLayer;

class TextureLayer extends PositionedLayer<TextureStyle>, implements IAccessRequest
{
	private static var ACCESS_TYPES:Array<Class<Dynamic>> = [ITextureAccess, IBoxPosAccess];
	
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

	@injectAdd
	private function onTextureAdd(access:ITextureAccess):Void {
		if (layerName != null && access.layerName != layerName) return;
		
		_textureAccess = access;
		invalidate();
	}
	@injectRemove
	private function onTextureRemove(access:ITextureAccess):Void {
		if (access != _textureAccess) return;
		
		_textureAccess = null;
	}
	
	private var _pos:IBoxPosAccess;
	private var _textureAccess:ITextureAccess;

	public function new(?layerName:String, ?normalStyle:TextureStyle) 
	{
		super(layerName, normalStyle);
	}
	public function getAccessTypes():Array<Class<Dynamic>> {
		return ACCESS_TYPES;
	}
	
	override private function _isReadyToDraw():Bool {
		return _pos!=null && _textureAccess != null && super._isReadyToDraw();
	}

	override private function _drawStyle():Void {
		switch(currentStyle) {
			case norm(texture):
				_textureAccess.setTexture(texture);
				_pos.set(x,y,w,h);
			case pad(texture, padT, padL, padB, padR):
				if (Math.isNaN(padT)) padT = 0;
				if (Math.isNaN(padL)) padL = 0;
				if (Math.isNaN(padB)) padB = 0;
				if (Math.isNaN(padR)) padR = 0;
				_textureAccess.setTexture(texture);
				_pos.set(x+padL,y+padT,w-padL-padR,h-padT-padB);
		}
	}
	
}
enum TextureStyle {
	norm(texture:TextureInfo);
	pad(texture:TextureInfo, ?padT:Float, ?padL:Float, ?padB:Float, ?padR:Float);
}
