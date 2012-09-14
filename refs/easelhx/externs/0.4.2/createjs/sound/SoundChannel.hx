package createjs.sound;



/**
*	SoundChannel manages the number of active instances
*
*/
@:native ("SoundChannel")
extern class SoundChannel {

	
	/**
	*	@type null
	*	A hash of channel instances by src.
	*
	*/
	public static var channels:Dynamic;
	
	/**
	*	@type null
	*	The current number of active instances.
	*
	*/
	private var length:Dynamic;
	
	/**
	*	@type null
	*	The maximum number of instances in this channel
	*
	*/
	private var max:Dynamic;
	
	/**
	*	@type null
	*	The src of the channel
	*
	*/
	private var src:Dynamic;

	
	/**
	*	@method add
	*	Add a new instance
	*	@param instance (SoundInstance)  The instance to add.
	*
	*/
	//private function add (instance:SoundInstance):Dynamic;
	
	/**
	*	@method add
	*	Add an instance to a sound channel.
	*	@param instance (SoundInstance)  The instance to add to the channel
	*	@param interrupt (String)  The interrupt value to use
	*
	*/
	private static function add (instance:SoundInstance, interrupt:String):Dynamic;
	
	/**
	*	@method create
	*	Create a sound channel.
	*	@param src (String)  The source for the channel
	*	@param max (Number)  The maximum amount this channel holds.
	*
	*/
	private static function create (src:String, max:Float):Dynamic;
	
	/**
	*	@method get
	*	Get a channel instance by its src.
	*	@param src (String)  The src to use to look up the channel
	*
	*/
	private static function get (src:String):Dynamic;
	
	/**
	*	@method get
	*	Get an instance by index
	*	@param index (Number)  The index to return.
	*
	*/
	//private function get (index:Float):Dynamic;
	
	/**
	*	@method getSlot
	*	Get an available slot
	*	@param interrupt (String)  The interrupt value to use.
	*	@param instance (SoundInstance)  The sound instance the will go in the channel if successful.
	*
	*/
	private function getSlot (interrupt:String, instance:SoundInstance):Dynamic;
	
	/**
	*	@method init
	*	Initialize the channel
	*	@param src (String)  The source of the channel
	*	@param max (Number)  The maximum number of instances in the channel
	*
	*/
	private function init (src:String, max:Float):Dynamic;
	
	/**
	*	@method remove
	*	Remove an instace from its channel.
	*	@param instance (SoundInstance)  The instance to remove from the channel
	*
	*/
	private static function remove (instance:SoundInstance):Dynamic;
	
	/**
	*	@method remove
	*	Remove an instance
	*	@param instance (SoundInstance)  The instance to remove
	*
	*/
	//private function remove (instance:SoundInstance):Dynamic;

}