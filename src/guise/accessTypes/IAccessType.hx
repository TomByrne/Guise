package guise.accessTypes;

import msignal.Signal;
import composure.core.ComposeItem;
/**
 * ...
 * @author Tom Byrne
 */

/*interface IPlatformAccess 
{
	function accessTypeSupported(layerAccess:Bool, accessType:Class<IAccessType>):Bool;
	function requestAccess<AccessType : IAccessType>(context:ComposeItem, accessType:Class<AccessType>, ?layerName:String):AccessType;
	function returnAccess(access:IAccessType):Void;
	
}*/

interface IAccessType {
	public var layerName:String;
}
