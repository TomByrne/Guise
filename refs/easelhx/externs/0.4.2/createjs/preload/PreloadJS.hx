package createjs.preload;



/**
*	PreloadJS provides a consistent way to preload content for use in HTML applications.
*
*/
@:native ("PreloadJS")
extern class PreloadJS extends AbstractLoader {

	
	/**
	*	@type Boolean
	*	Ensure loaded scripts "complete" in the order they are specified.
	*
	*/
	public var maintainScriptOrder:Bool;
	
	/**
	*	@type Boolean
	*	Stop processing the current queue when an error is encountered.
	*
	*/
	public var stopOnError:Bool;
	
	/**
	*	@type Boolean
	*	Use XMLHttpRequest when possible.
	*
	*/
	public var useXHR:Bool;
	
	/**
	*	@type Number
	*	Time in millseconds to assume a load has failed.
	*
	*/
	public static var TIMEOUT_TIME:Float;
	
	/**
	*	@type PreloadJS
	*	The next preload queue to process when this one is complete.
	*
	*/
	public var next:PreloadJS;
	
	/**
	*	@type String
	*	The preload type for css files.
	*
	*/
	public static var CSS:String;
	
	/**
	*	@type String
	*	The preload type for image files, usually png, gif, or jpg/jpeg
	*
	*/
	public static var IMAGE:String;
	
	/**
	*	@type String
	*	The preload type for javascript files, usually with the "js" file extension.
	*
	*/
	public static var JAVASCRIPT:String;
	
	/**
	*	@type String
	*	The preload type for json files, usually with the "json" file extension.
	*
	*/
	public static var JSON:String;
	
	/**
	*	@type String
	*	The preload type for sound files, usually mp3, ogg, or wav.
	*
	*/
	public static var SOUND:String;
	
	/**
	*	@type String
	*	The preload type for text files, which is also the default file type if the type can not be determined.
	*
	*/
	public static var TEXT:String;
	
	/**
	*	@type String
	*	The preload type for xml files.
	*
	*/
	public static var XML:String;

	
	/**
	*	@method close
	*	Close the active queue. Closing a queue completely empties the queue, and prevents any remaining items from starting to
	*	download. Note that currently there any active loads will remain open, and events may be processed.<br/><br/>
	*	To stop and restart a queue, use the <b>setPaused(true|false)</b> method instead.
	*
	*/
	public function close ():Dynamic;
	
	/**
	*	@method determineCapabilities
	*	Determine the capabilities based on the current browser/version.
	*
	*/
	private function determineCapabilities ():Dynamic;
	
	/**
	*	@method getResult
	*	Lookup a loaded item using either the "id" or "src" that was specified when loading it.
	*	@param value (String)  The "id" or "src" of the loaded item.
	*
	*/
	public function getResult (value:String):Dynamic;
	
	/**
	*	@method initialize
	*	Initialize a PreloadJS instance
	*	@param useXHR (Dynamic)  Use XHR for loading (vs tag/script loading)
	*
	*/
	public function initialize (useXHR:Dynamic):Dynamic;
	
	/**
	*	@method installPlugin
	*	Register a plugin. Plugins can map to both load types (sound, image, etc), or can map to specific
	*	extensions (png, mp3, etc). Only one plugin can currently exist per suffix/type.
	*	Plugins must return an object containing:
	*	 * callback: The function to call
	*	 * types: An array of types to handle
	*	 * extensions: An array of extensions to handle. This is overriden by type handlers
	*	@param plugin (Function)  The plugin to install
	*
	*/
	public function installPlugin (plugin:Dynamic):Dynamic;
	
	/**
	*	@method isBinary
	*	Determine if a specific type should be loaded as a binary file
	*	@param type (Dynamic)  The type to check
	*
	*/
	private function isBinary (type:Dynamic):Dynamic;
	
	/**
	*	@method load
	*	Begin loading the queued items.
	*
	*/
	public function load ():Dynamic;
	
	/**
	*	@method loadFile
	*	Load a single file. Note that calling loadFile appends to the current queue, so it can be used multiple times to
	*	add files. Use <b>loadManifest()</b> to add multiple files at onces. To clear the queue first use the <b>close()</b> method.
	*	@param file (Object | String)  The file object or path to load. A file can be either
	*	<ol>
	*	    <li>a path to a resource (string). Note that this kind of load item will be
	*	    converted to an object (next item) in the background.</li>
	*	    <li>OR an object that contains:<ul>
	*	        <li>src: The source of the file that is being loaded. This property is <b>required</b>. The source can either be a string (recommended), or an HTML tag.</li>
	*	        <li>type: The type of file that will be loaded (image, sound, json, etc).
	*	        PreloadJS does auto-detection of types using the extension. Supported types are defined on PreloadJS, such as PreloadJS.IMAGE.
	*	        It is recommended that a type is specified when a non-standard file URI (such as a php script) us used.</li>
	*	        <li>id: A string indentifier which can be used to reference the loaded object.</li>
	*	        <li>data: An arbitrary data object, which is included with the loaded object</li>
	*	    </ul>
	*	</ol>
	*	@param loadNow (Boolean)  Kick off an immediate load (true) or wait for a load call (false). The default value is true. If the queue is paused, and this value
	*	is true, the queue will resume.
	*
	*/
	public function loadFile (file:Dynamic, loadNow:Bool):Dynamic;
	
	/**
	*	@method loadManifest
	*	Load a manifest. This is a shortcut method to load a group of files. To load a single file, use the loadFile method.
	*	Note that calling loadManifest appends to the current queue, so it can be used multiple times to add files. To clear
	*	the queue first, use the <b>close()</b> method.
	*	@param manifest (Array)  The list of files to load. Each file can be either
	*	<ol>
	*	    <li>a path to a resource (string). Note that this kind of load item will be
	*	    converted to an object (next item) in the background.</li>
	*	    <li>OR an object that contains:<ul>
	*	        <li>src: The source of the file that is being loaded. This property is <b>required</b>.
	*	        The source can either be a string (recommended), or an HTML tag. </li>
	*	        <li>type: The type of file that will be loaded (image, sound, json, etc).
	*	        PreloadJS does auto-detection of types using the extension. Supported types are defined on PreloadJS, such as PreloadJS.IMAGE.
	*	        It is recommended that a type is specified when a non-standard file URI (such as a php script) us used.</li>
	*	        <li>id: A string indentifier which can be used to reference the loaded object.</li>
	*	        <li>data: An arbitrary data object, which is included with the loaded object</li>
	*	    </ul>
	*	</ol>
	*	@param loadNow (Boolean)  Kick off an immediate load (true) or wait for a load call (false). The default value is true. If the queue is paused, and this value
	*	is true, the queue will resume.
	*
	*/
	public function loadManifest (manifest:Array <Dynamic>, loadNow:Bool):Dynamic;
	
	/**
	*	@method new
	*	PreloadJS provides a consistent way to preload content for use in HTML applications.
	*	@param Boolean (null)  
	*
	*/
	public function new (?boo:Bool):Void;
	
	/**
	*	@method proxy
	*	A function proxy for PreloadJS methods. By default, JavaScript methods do not maintain scope, so passing a
	*	method as a callback will result in the method getting called in the scope of the caller. Using a proxy
	*	ensures that the method gets called in the correct scope. All internal callbacks in PreloadJS use this approach.
	*	@param method (Function)  The function to call
	*	@param scope (Object)  The scope to call the method name on
	*
	*/
	private static function proxy (method:Dynamic, scope:Dynamic):Dynamic;
	
	/**
	*	@method setMaxConnections
	*	Set the maximum number of concurrent connections.
	*	@param value (Number)  The number of concurrent loads to allow. By default, only a single connection is open at any time.
	*	Note that browsers and servers may have a built-in maximum number of open connections
	*
	*/
	public function setMaxConnections (value:Float):Dynamic;
	
	/**
	*	@method setPaused
	*	Pause or resume the current load. The active item will not cancel, but the next
	*	items in the queue will not be processed.
	*	@param value (Boolean)  Whether the queue should be paused or not.
	*
	*/
	public function setPaused (value:Bool):Dynamic;

}