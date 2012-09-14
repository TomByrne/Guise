package createjs.sound;



/**
*	The public API for creating sounds, and controlling the overall sound levels,
*	and affecting multiple sounds at once. All SoundJS APIs are static.
*	
*	SoundJS can also be used as a PreloadJS plugin to help preload audio properly.
*
*/
@:native ("SoundJS")
extern class SoundJS {

	
	/**
	*	@type Number
	*	The duration in milliseconds to determine a timeout.
	*
	*/
	public static var AUDIO_TIMEOUT:Float;
	
	/**
	*	@type Object
	*	The currently active plugin. If this is null, then no plugin could be initialized.
	*	If no plugin was specified, only the HTMLAudioPlugin is tested.
	*
	*/
	public static var activePlugin:Dynamic;
	
	/**
	*	@type String
	*	Defines the playState of an instance that completed playback.
	*
	*/
	public static var PLAY_FINISHED:String;
	
	/**
	*	@type String
	*	Defines the playState of an instance that failed to play. This is usually caused by a lack of available channels
	*	when the interrupt mode was "INTERRUPT_NONE", the playback stalled, or the sound could not be found.
	*
	*/
	public static var PLAY_FAILED:String;
	
	/**
	*	@type String
	*	Defines the playState of an instance that is currently playing or paused.
	*
	*/
	public static var PLAY_SUCCEEDED:String;
	
	/**
	*	@type String
	*	Defines the playState of an instance that is still initializing.
	*
	*/
	public static var PLAY_INITED:String;
	
	/**
	*	@type String
	*	Defines the playState of an instance that was interrupted by another instance.
	*
	*/
	public static var PLAY_INTERRUPTED:String;
	
	/**
	*	@type String
	*	Determine how audio is split, when multiple paths are specified in a source.
	*
	*/
	public static var DELIMITER:String;
	
	/**
	*	@type String
	*	The interrupt value to use to interrupt any currently playing instance with the same source.
	*
	*/
	public static var INTERRUPT_ANY:String;
	
	/**
	*	@type String
	*	The interrupt value to use to interrupt no currently playing instances with the same source.
	*
	*/
	public static var INTERRUPT_NONE:String;
	
	/**
	*	@type String
	*	The interrupt value to use to interrupt the earliest currently playing instance with the same source.
	*
	*/
	public static var INTERRUPT_EARLY:String;
	
	/**
	*	@type String
	*	The interrupt value to use to interrupt the latest currently playing instance with the same source.
	*
	*/
	public static var INTERRUPT_LATE:String;

	
	/**
	*	@method getCapabilities
	*	Get the active plugin's capabilities, which help determine if a plugin can be
	*	used in the current environment, or if the plugin supports a specific feature.
	*	Capabilities include:
	*	<ul>
	*	    <li><b>panning:</b> If the plugin can pan audio from left to right</li>
	*	    <li><b>volume;</b> If the plugin can control audio volume.</li>
	*	    <li><b>mp3:</b> If MP3 audio is supported.</li>
	*	    <li><b>ogg:</b> If OGG audio is supported.</li>
	*	    <li><b>mpeg:</b> If MPEG audio is supported.</li>
	*	    <li><b>channels:</b> The maximum number of audio channels that can be created.</li>
	*
	*/
	public static function getCapabilities ():Dynamic;
	
	/**
	*	@method getCapability
	*	Get a specific capability of the active plugin. See the <b>getCapabilities</b> for a full list
	*	of capabilities.
	*	@param key (String)  The capability to retrieve
	*
	*/
	public static function getCapability (key:String):Dynamic;
	
	/**
	*	@method getInstanceById
	*	Get a SoundInstance by a unique id. It is often useful to store audio
	*	instances by id (in form elements for example), so this method provides
	*	a useful way to access the instances via their IDs.
	*	@param uniqueId (Dynamic)  The id to use as lookup.
	*
	*/
	public static function getInstanceById (uniqueId:Dynamic):SoundInstance;
	
	/**
	*	@method getMasterVolume
	*	Get the master volume. All sounds multiply their current volume against the master volume.
	*
	*/
	public static function getMasterVolume ():Float;
	
	/**
	*	@method getSrcFromId
	*	Get the source of a sound via the ID passed in with the manifest. If no ID is found
	*	the value is passed back.
	*	@param value (Dynamic)  The name or src of a sound.
	*
	*/
	public static function getSrcFromId (value:Dynamic):String;
	
	/**
	*	@method initLoad
	*	Process manifest items from PreloadJS.
	*	@param value (String | Object)  The src or object to load
	*	@param type (String)  The optional type of object. Will likely be "sound".
	*	@param id (String)  An optional id
	*	@param data (Number | String | Boolean | Object)  Optional data associated with the item
	*
	*/
	private function initLoad (value:Dynamic, type:String, id:String, data:Dynamic):Dynamic;
	
	/**
	*	@method isReady
	*	Determines if SoundJS has been initialized, and a plugin has been activated.
	*
	*/
	public static function isReady ():Bool;
	
	/**
	*	@method new
	*	The public API for creating sounds, and controlling the overall sound levels,
	*	and affecting multiple sounds at once. All SoundJS APIs are static.
	*	
	*	SoundJS can also be used as a PreloadJS plugin to help preload audio properly.
	*
	*/
	public function new ():Void;
	
	/**
	*	@method parsePath
	*	Parse the path of a manifest item
	*	@param value (String | Object)  
	*	@param type (String)  
	*	@param id (String)  
	*	@param data (Number | String | Boolean | Object)  
	*
	*/
	private function parsePath (value:Dynamic, type:String, id:String, data:Dynamic):Dynamic;
	
	/**
	*	@method pause
	*	Pause all instances.
	*	@param id (Dynamic)  The specific sound ID (set) to target.
	*
	*/
	public static function pause (id:Dynamic):Dynamic;
	
	/**
	*	@method play
	*	Play a sound, receive an instance to control
	*	@param value (String)  The src or ID of the audio.
	*	@param interrupt (String)  How to interrupt other instances of audio. Values are defined as constants on SoundJS.
	*	@param delay (Number)  The amount of time to delay the start of the audio. Delay is in milliseconds.
	*	@param offset (Number)  The point to start the audio. Offset is in milliseconds.
	*	@param loop (Number)  Determines how many times the audio loops when it reaches the end of a sound. Default is 0 (no loops). Set to -1 for infinite.
	*	@param volume (Number)  The volume of the sound, between 0 and 1
	*	@param pan (Number)  The left-right pan of the sound (if supported), between -1 (left) and 1 (right)
	*
	*/
	public static function play (value:String, interrupt:String, ?delay:Float, ?offset:Float, ?loop:Float, ?volume:Float, ?pan:Float):SoundInstance;
	
	/**
	*	@method playFinished
	*	A sound has completed playback, been interrupted, failed, or been stopped.
	*	Remove instance management. It will be added again, if the sound re-plays.
	*	Note that this method is called from the instances.
	*	@param instance (SoundInstance)  The instance that finished playback.
	*
	*/
	private function playFinished (instance:SoundInstance):Dynamic;
	
	/**
	*	@method proxy
	*	A function proxy for SoundJS methods. By default, JavaScript methods do not maintain scope, so passing a
	*	method as a callback will result in the method getting called in the scope of the caller. Using a proxy
	*	ensures that the method gets called in the correct scope. All internal callbacks in SoundJS use this approach.
	*	@param method (Function)  The function to call
	*	@param scope (Object)  The scope to call the method name on
	*
	*/
	private static function proxy (method:Dynamic, scope:Dynamic):Dynamic;
	
	/**
	*	@method registerPlugin
	*	Register a SoundJS plugin. Plugins handle the actual playing
	*	of audio. By default the HTMLAudio plugin will be installed if
	*	no other plugins are present when the user starts playback.
	*	@param plugin (Object)  The plugin class to install.
	*
	*/
	public static function registerPlugin (plugin:Dynamic):Bool;
	
	/**
	*	@method registerPlugins
	*	Register a list of plugins, in order of precedence.
	*	@param plugins (Array)  An array of plugins to install.
	*
	*/
	public static function registerPlugins (plugins:Array <Dynamic>):Bool;
	
	public static function checkPlugin (initializeDefault:Bool):Bool;
	
	/**
	*	@method resume
	*	Resume all instances. Note that the pause/resume methods do not work independantly
	*	of each instance's paused state. If one instance is already paused when the SoundJS.pause
	*	method is called, then it will resume when this method is called.
	*	@param id (Dynamic)  The specific sound ID (set) to target.
	*
	*/
	public static function resume (id:Dynamic):Dynamic;
	
	/**
	*	@method setMasterVolume
	*	To set the volume of all instances at once, use the setVolume() method.
	*	@param value (Number)  The master volume to set.
	*
	*/
	public static function setMasterVolume (value:Float):Bool;
	
	/**
	*	@method setMute
	*	Mute/Unmute all audio. Note that muted audio still plays at 0 volume, and that
	*	this method just sets the mute value of each instance, and not a "global mute".
	*	@param isMuted (Boolean)  Whether the audio should be muted or not.
	*	@param id (String)  The specific sound ID (set) to target.
	*
	*/
	public static function setMute (isMuted:Bool, id:String):Bool;
	
	/**
	*	@method setVolume
	*	Set the volume of all sounds. This sets the volume value of all audio, and
	*	is not a "master volume". Use setMasterVolume() instead.
	*	@param The (Number)  volume to set on all sounds. The acceptable range is 0-1.
	*	@param id (String)  Optional, the specific sound ID to target.
	*
	*/
	public static function setVolume (The:Float, id:String):Bool;
	
	/**
	*	@method stop
	*	Stop all audio (Global stop).
	*	@param id (Dynamic)  The specific sound ID (set) to target.
	*
	*/
	public static function stop (?id:Dynamic):Dynamic;

}