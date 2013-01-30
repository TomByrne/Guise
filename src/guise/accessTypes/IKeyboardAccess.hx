package guise.accessTypes;
import msignal.Signal;

interface IKeyboardAccess implements IAccessType
{

	function keyDown(keyInfo:KeyInfo):Signal2<IKeyboardAccess, KeyInfo>;
	function keyUp(keyInfo:KeyInfo):Signal2<IKeyboardAccess, KeyInfo>;
	
	function isDown(keyInfo:KeyInfo):Bool;
	
}
enum KeyInfo {
	Key(keyCode:Int, ?modKeys:Array<ModKeys>);
	Char(charCode:Int, ?modKeys:Array<ModKeys>);
}
enum ModKeys {
	Ctrl;
	Alt;
	Shift;
}