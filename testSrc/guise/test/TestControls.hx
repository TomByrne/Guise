package guise.test;

import composure.core.ComposeGroup;
import composure.core.ComposeItem;
import guise.controls.logic.input.ClickToggleSelect;
import guise.controls.ControlTags;
import guise.controls.data.ITextLabel;
import guise.controls.data.ISelected;
import guise.controls.data.IInputPrompt;
import guise.layout.IDisplayPosition;

/**
 * ...
 * @author Tom Byrne
 */

class TestControls 
{
	public static function addControls(parent:ComposeGroup, x:Float = 0, y:Float = 0 ):Void {
		
		addButton(parent, "Test Button", x, y, 150, 30, false);
		addButton(parent, "Selectable Button", x, y + 40, 150, 30, true);
		addLabel(parent, "Test Label", x, y + 80, 150, 30);
		addTextInput(parent, "Test Input", x, y + 120, 150, 30);
		addToggleButton(parent, x, y + 155, 150, 30);
		addSlider(parent, x, y + 180, 150, 30, false);
	}
	public static function addButton(parent:ComposeGroup, text:String, x:Float, y:Float, w:Float, h:Float, selectable:Bool):Void {
		var item:ComposeItem = new ComposeItem();
		item.addTraits([TextButtonTag(selectable), new Pos(x, y, w, h), new TextLabel(text)]);
		parent.addChild(item);
	}
	public static function addLabel(parent:ComposeGroup, text:String, x:Float, y:Float, w:Float, h:Float):Void {
		var item:ComposeItem = new ComposeItem();
		item.addTraits([TextLabelTag, new Pos(x, y, w, h), new TextLabel(text)]);
		parent.addChild(item);
	}
	public static function addTextInput(parent:ComposeGroup, prompt:String, x:Float, y:Float, w:Float, h:Float):Void {
		var item:ComposeItem = new ComposeItem();
		item.addTraits([TextInputTag, new Pos(x, y, w, h), new TextLabel(), new InputPrompt(prompt) ]);
		parent.addChild(item);
	}
	public static function addToggleButton(parent:ComposeGroup, x:Float, y:Float, w:Float, h:Float):Void {
		var item:ComposeItem = new ComposeItem();
		item.addTraits([ToggleButtonTag, new Pos(x, y, w, h)]);
		parent.addChild(item);
	}
	public static function addSlider(parent:ComposeGroup, x:Float, y:Float, w:Float, h:Float, vert:Bool):Void {
		var item:ComposeItem = new ComposeItem();
		item.addTraits([SliderTag(vert), new Pos(x, y, w, h)]);
		parent.addChild(item);
	}
	
}