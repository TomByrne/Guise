package guise.accessTypes;
import msignal.Signal;


interface ITextInputAccess extends IAccessType {
	public function getText():String ;
	public var textChanged(get, null):Signal1 < ITextInputAccess > ;
	
	var inputEnabled(default, set):Bool;
}


