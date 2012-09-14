package guise.platform;

import msignal.Signal;
import composure.core.ComposeItem;
/**
 * ...
 * @author Tom Byrne
 */

interface IPlatformAccess 
{
	function accessTypeSupported(layerAccess:Bool, accessType:Class<IAccessType>):Bool;
	function requestAccess<AccessType : IAccessType>(context:ComposeItem, accessType:Class<AccessType>, ?layerName:String):AccessType;
	function returnAccess(access:IAccessType):Void;
	
}

interface IAccessType {
	
}


interface IFocusableAccess implements IAccessType {
	public var focused(default, null):Bool ;
	public var focusedChanged(get_focusedChanged, null):Signal1 < IFocusableAccess > ;
}