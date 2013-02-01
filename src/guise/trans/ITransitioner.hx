package guise.trans;

/**
 * ...
 * @author Tom Byrne
 */

interface ITransitioner 
{

	function doTrans(from:Dynamic, to:Dynamic, subject:Dynamic, ?prop:String, ?update:Dynamic->Void, ?finish:Dynamic->Void):ITransTracker;
	
}
interface ITransTracker {
	function setUpdateHandler(handler:Dynamic->Void):Void;
	function setFinishHandler(handler:Dynamic->Void):Void;
	//dynamic function update(curr:Dynamic):Void; // doesn't compile in cpp yet (http://code.google.com/p/haxe/issues/detail?id=1148)
	//dynamic function finish(curr:Dynamic):Void;
	function stopTrans(gotoEnd:Bool):Void;
}