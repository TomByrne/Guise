package createjs.sound;



/**
*	Play sounds using HTML <audio> tags in the browser.
*
*/
@:native ("HTMLAudioPlugin")
extern class HTMLAudioPlugin {

	
	/**
	*	@type Number
	*	The maximum number of instances that can be played. This is a browser limitation.
	*
	*/
	public static var MAX_INSTANCES:Float;
	
	/**
	*	@type Object
	*	The capabilities of the plugin.
	*
	*/
	public static var capabilities:Dynamic;

	
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
	*	Play sounds using HTML <audio> tags in the browser.
	*
	*/
	public function new ():Void;
	
	/**
	*	@method register
	*	Pre-register a sound instance when preloading/setup.
	*	@param src (String)  The source of the audio
	*	@param instances (Number)  The number of concurrently playing instances to allow for the channel at any time.
	*
	*/
	public function register (src:String, instances:Float):Dynamic;

}