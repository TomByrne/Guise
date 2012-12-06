package guise.styledLayers;

/**
 * ...
 * @author Tom Byrne
 */

interface IDisplayLayer 
{

	public var layerName(default, null):String;
	public function setPosition(x:Float, y:Float, w:Float, h:Float):Void;
}