package guise.platform.tilelayer.accessTypes;
import aze.display.TileClip;
import aze.display.TileLayer;
import guise.accessTypes.ITextureAccess;
import guise.platform.tilelayer.addTypes.ITileBaseType;


class TextureAccess implements ITextureAccess, implements ITileBaseType
{
	
	private var _tile:TileClip;

	public function new() 
	{
		_tile = new TileClip("");
	}
	
	public function setTexture(value:TextureInfo):Void {
		switch(value) {
			case sprite(textureId):
				_tile.tile = textureId;
				_tile.fps = 0;
			case clip(textureId, fps):
				_tile.tile = textureId;
				_tile.fps = fps;
		}
	}
	
	public function getTileBase():TileBase {
		return _tile;
	}
}