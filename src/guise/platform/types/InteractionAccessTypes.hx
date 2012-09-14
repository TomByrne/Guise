package guise.platform.types;

import msignal.Signal;
import guise.platform.IPlatformAccess;
/**
 * @author Tom Byrne
 */

class InteractionAccessTypes 
{}

interface IMouseInteractions implements IAccessType
{
	public var pressed(get_pressed, null):Signal1<MouseInfo>;
	public var released(get_released, null):Signal1<MouseInfo>;
	
	public var rolledOver(get_rolledOver, null):Signal1<MouseInfo>;
	public var rolledOut(get_rolledOut, null):Signal1<MouseInfo>;
	
	public var moved(get_moved, null):Signal1<MouseInfo>;
}
class MouseInfo {
	public var mouseX:Float;
	public var mouseY:Float;
	
	public function new() {
		
	}
}

interface IMouseClickable implements IAccessType
{
	public var clicked(get_clicked, null):Signal1<ClickInfo>;
	public var doubleClicked(get_doubleClicked, null):Signal1<ClickInfo>;
	
}
class ClickInfo {
	public var left:Bool;
	public var altHeld:Bool;
	public var ctrlHeld:Bool;
	public var shiftHeld:Bool;
	
	public function new() {
		
	}
}

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