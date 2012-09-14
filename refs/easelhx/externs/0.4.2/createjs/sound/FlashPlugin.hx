package createjs.sound;



/**
*	Play sounds using a Flash instance. This plugin requires swfObject.as
*	as well as the FlashAudioPlugin.swf. Ensure that FlashPlugin.BASE_PATH
*	is set when using this plugin, so that the script can find the swf.
*
*/
@:native ("FlashPlugin")
extern class FlashPlugin {

	
	/**
	*	@type Object
	*	The capabilities of the plugin.
	*
	*/
	public static var capabilities:Dynamic;
	
	/**
	*	@type String
	*	The path relative to the HTML page that the FlashAudioPlugin.swf resides.
	*	If this is not correct, this plugin will not work.
	*
	*/
	public static var BASE_PATH:String;

	
	/**
	*	@method create
	*	Create a sound instance.
	*	@param src (String)  The source to use.
	*
	*/
	public function create (src:String):SoundInstance;
	
	/**
	*	@method generateCapabiities
	*	Determine the capabilities of the plugin.
	*
	*/
	public static function generateCapabiities ():Dynamic;
	
	/**
	*	@method isSupported
	*	Determine if the plugin can be used.
	*
	*/
	public static function isSupported ():Bool;
	
	/**
	*	@method new
	*	Play sounds using a Flash instance. This plugin requires swfObject.as
	*	as well as the FlashAudioPlugin.swf. Ensure that FlashPlugin.BASE_PATH
	*	is set when using this plugin, so that the script can find the swf.
	*
	*/
	public function new ():Void;

}