package guise.accessTypes;

import msignal.Signal;

interface IFocusableAccess implements IAccessType {
	public var focused(default, null):Bool ;
	public var focusedChanged(get_focusedChanged, null):Signal1 < IFocusableAccess > ;
}