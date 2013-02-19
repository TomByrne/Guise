package guise.platform.cross;

import guise.accessTypes.ITextOutputAccess;

class FontRegistry 
{
	public static function getFont(path:String, otherwise:Typeface):Typeface {
		#if nme
			var font = nme.Assets.getFont(path);
			return (font==null?otherwise:Tf(font.fontName));
		#else
			return otherwise;
		#end
	}
	public static function getBitmapFont(path:String, otherwise:Typeface):Typeface {
		#if (starling && nme)
			
			var data:String = nme.Assets.getText(path);
			if (data == null) return otherwise;
			var xml = new flash.xml.XML(data);
			
			// there isn't a clean way to check if Starling has inited yet.
			try {
				if (starling.core.Starling.current.root != null) {
					registerBitmapFont(xml, path);
				}else {
					throw "Bla"; // this is in case they fix the root getter
				}
			}catch (e:Dynamic) {
				if (_pendingFonts == null) {
					_pendingFonts = [xml];
					_pendingPaths = [path];
					starling.core.Starling.current.addEventListener(starling.events.Event.ROOT_CREATED, onRootCreated);
				}else {
					_pendingFonts.push(xml);
					_pendingPaths.push(path);
				}
			}
			var fontName:String = untyped xml.info.attribute("face");
			return Tf(fontName);
		#else
			return otherwise;
		#end
	}
	#if (starling && nme)
	private static var _pendingFonts:Array<flash.xml.XML>;
	private static var _pendingPaths:Array<String>;
	public static function onRootCreated(e:starling.events.Event):Void {
		for (i in 0... _pendingFonts.length) {
			registerBitmapFont(_pendingFonts[i], _pendingPaths[i]);
		}
		_pendingFonts = null;
		_pendingPaths = null;
	}
	public static function registerBitmapFont(xml:flash.xml.XML, path:String):Void {
		var texturePath = untyped xml.pages.page.attribute("file");
		var slashIndex:Int = path.lastIndexOf("/");
		if (slashIndex == -1) {
			slashIndex = path.lastIndexOf("\\");
		}
		if (slashIndex != -1) {
			texturePath = path.substr(0, slashIndex + 1) + texturePath;
		}
		var texture = starling.textures.Texture.fromBitmapData(nme.Assets.getBitmapData(texturePath));
		var font = new starling.text.BitmapFont(texture, xml);
		starling.text.TextField.registerBitmapFont(font);
		
		if (_changed != null) {
			_changed.dispatch();
		}
	}
	
	private static var _changed:msignal.Signal.Signal0;
	public static function getChanged():msignal.Signal.Signal0 {
		if (_changed == null)_changed = new msignal.Signal.Signal0();
		return _changed;
	}
	
	#end
	
}