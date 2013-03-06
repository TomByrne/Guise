package guise.accessTypes;


interface ITextureAccess implements IVisualAccessType
{

	public function setTexture(style:TextureInfo):Void;
	
}

enum TextureInfo {
	tile(textureId:String);
	sprite(textureId:String, ?scale9:Bool);
	clip(textureId:String, ?fps:Int, ?scale9:Bool);
}