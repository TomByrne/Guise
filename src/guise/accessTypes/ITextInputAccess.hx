package guise.accessTypes;
import msignal.Signal;


interface ITextInputAccess implements IAccessType {
	public function getText():String ;
	public var textChanged(get_textChanged, null):Signal1 < ITextInputAccess > ;
	
	var inputEnabled(default, set_inputEnabled):Bool;
}


