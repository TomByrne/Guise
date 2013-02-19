package guise.accessTypes;


interface ITextureAccess 
{

	public function setTexture(style:TextureInfo):Void;
	
}

enum TextureInfo {
	sprite(textureId:String, ?scale9:Bool);
	clip(textureId:String, ?fps:Int, ?scale9:Bool);
}