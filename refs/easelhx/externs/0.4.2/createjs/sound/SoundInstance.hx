package createjs.sound;



/**
*	Sound Instances are created when any calls to SoundJS.play() are made.
*	The instances are returned by the active plugin for control by the user.
*	Users can control audio directly through the instance.
*
*/
@:native ("SoundInstance")
extern class SoundInstance {

	
	/**
	*	@type Boolean
	*	Determines if the audio is currently muted.
	*
	*/
	public var muted:Bool;
	
	/**
	*	@type Boolean
	*	Determines if the audio is currently paused. If the audio has not yet started playing,
	*	it will be true, unless the user pauses it.
	*
	*/
	public var paused:Bool;
	
	/**
	*	@type HTMLAudioPlugin
	*	The plugin that created the instance
	*
	*/
	public var owner:HTMLAudioPlugin;
	
	/**
	*	@type String
	*	The play state of the sound. Play states are defined as constants on SoundJS
	*
	*/
	public var playState:String;
	
	/**
	*	@type String
	*	The source of the sound.
	*
	*/
	public var src:String;
	
	/**
	*	@type String | Number
	*	The unique ID of the instance
	*
	*/
	public var uniqueId:Dynamic;

	
	/**
	*	@method getDuration
	*	Get the duration of the sound instance.
	*
	*/
	public function getDuration ():Float;
	
	/**
	*	@method getPan
	*	Get the pan of a sound instance. Note that this does not work in HTML audio.
	*
	*/
	public function getPan ():Float;
	
	/**
	*	@method getPosition
	*	Get the position of the playhead in the sound instance.
	*
	*/
	public function getPosition ():Float;
	
	/**
	*	@method getVolume
	*	Get the volume of the sound, not including how the master volume has affected it.
	*	@param value (Dynamic)  
	*
	*/
	public function getVolume (value:Dynamic):Dynamic;
	
	/**
	*	@method mute
	*	Mute the sound.
	*	@param isMuted (Boolean)  If the sound should be muted or not.
	*
	*/
	public function mute (isMuted:Bool):Bool;
	
	/**
	*	@method new
	*	Sound Instances are created when any calls to SoundJS.play() are made.
	*	The instances are returned by the active plugin for control by the user.
	*	Users can control audio directly through the instance.
	*	@param src (String)  
	*
	*/
	public function new (src:String):Void;
	
	/**
	*	@method pause
	*	Pause the instance.
	*
	*/
	public function pause ():Bool;
	
	/**
	*	@method play
	*	Play an instance. This API is only used to play an instance after it has been stopped
	*	or interrupted.`
	*	@param interrupt (String)  How this sound interrupts other instances with the same source. Interrupt values are defined as constants on SoundJS.
	*	@param delay (Number)  The delay in milliseconds before the sound starts
	*	@param offset (Number)  How far into the sound to begin playback.
	*	@param loop (Number)  The number of times to loop the audio. Use -1 for infinite loops.
	*	@param volume (Number)  The volume of the sound between 0 and 1.
	*	@param pan (Number)  The pan of the sound between -1 and 1. Note that pan does not work for HTML Audio.
	*
	*/
	public function play (interrupt:String, delay:Float, offset:Float, loop:Float, volume:Float, pan:Float):Dynamic;
	
	/**
	*	@method resume
	*	Resume a sound instance that has been paused.
	*
	*/
	public function resume ():Bool;
	
	/**
	*	@method setPan
	*	Set the pan of a sound instance. Note that this does not work in HTML audio.
	*	@param value (Number)  The pan value between -1 (left) and 1 (right).
	*
	*/
	public function setPan (value:Float):Float;
	
	/**
	*	@method setPosition
	*	Set the position of the playhead in the sound instance.
	*	@param value (Number)  The position of the playhead in milliseconds.
	*
	*/
	public function setPosition (value:Float):Dynamic;
	
	/**
	*	@method setVolume
	*	Set the volume of the sound instance.
	*	@param value (Dynamic)  
	*
	*/
	public function setVolume (value:Dynamic):Bool;
	
	/**
	*	@method stop
	*	Stop a sound instance.
	*
	*/
	public function stop ():Bool;

}