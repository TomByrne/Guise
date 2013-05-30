package guise.skin.bitmap.utils;

import haxe.Resource;
import msignal.Signal;
import flash.display.BitmapData;
import flash.display.Loader;

@:build(LazyInst.check())
class TexturePack 
{
	@lazyInst
	public var changed:Signal1<TexturePack>;
	
	#if starling
	public var pack:starling.textures.TextureAtlas;
	#elseif tilelayer
	public var pack:aze.display.TilesheetEx;
	#elseif nme
	public var pack:guise.platform.nme.ext.TilesheetEx;
	#end
	
	
	private var _imagePath:String;
	private var _dataPath:String;
	private var _contextReady:Bool;

	public function new(?imagePath:String, dataPath:String) 
	{
		#if (nme && !starling)
		_contextReady = true;
		#end
		if (imagePath != null && dataPath != null) {
			setTexture(imagePath, dataPath);
		}
	}
	
	public function setTexture(imagePath:String, dataPath:String):Void {
		_imagePath = imagePath;
		_dataPath = dataPath;
		checkTexture();
	}
	
	public function contextReady():Void {
		_contextReady = true;
		checkTexture();
	}
	
	public function checkTexture():Void {
		if (_imagePath == null || _dataPath == null || !_contextReady) return;
		
		#if starling
		
			#if nme
				var bitmap = nme.Assets.getBitmapData(_imagePath);
				var xml = new flash.xml.XML(nme.Assets.getText(_dataPath));
			#else
				var loader:Loader = new Loader();
				loader.loadBytes(Resource.getBytes(_imagePath).getData());
				var bitmap:BitmapData = cast loader.content;
				var xml = new flash.xml.XML(Resource.getString(_dataPath));
			#end
		
		pack = new starling.textures.TextureAtlas(starling.textures.Texture.fromBitmapData(bitmap), xml);
		
		#elseif tilelayer
		pack = new aze.display.SparrowTilesheet(nme.Assets.getBitmapData(_imagePath), nme.Assets.getText(_dataPath));
		
		#elseif nme
		pack = new guise.platform.nme.ext.SparrowTilesheet(nme.Assets.getBitmapData(_imagePath), nme.Assets.getText(_dataPath));
		
		#end
		
		LazyInst.exec(changed.dispatch(this));
	}
}