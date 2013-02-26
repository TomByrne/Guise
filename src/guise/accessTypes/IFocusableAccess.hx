package guise.accessTypes;

import msignal.Signal;

interface IFocusableAccess extends IAccessType {
	@:isVar public var focused(default, null):Bool ;
	public var focusedChanged(get, null):Signal1 < IFocusableAccess > ;
}