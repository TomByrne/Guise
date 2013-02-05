package guise.test;

import composure.core.ComposeGroup;
import composure.core.ComposeItem;
import guise.controls.data.TextLabel;
import guise.controls.logic.input.ClickToggleSelect;
import guise.core.CoreTags;
import guise.controls.ControlTags;
import guise.controls.data.ITextLabel;
import guise.controls.data.ISelected;
import guise.controls.data.IInputPrompt;
import guise.layout.BoxPos;


class TestControls 
{
	public static function addControls(parent:ComposeGroup, x:Float = 0, y:Float = 0 ):Void {
		
		var item:ComposeGroup = new ComposeGroup();
		item.addTraits([ContainerTag, new BoxPos(x, y,0,0)]);
		parent.addChild(item);
		
		addButton(item, "Test Button", 0, 0, 150, 30, false);
		addButton(item, "Selectable Button", 0, 40, 150, 30, true);
		addLabel(item, "Test Label", 0, 80, 150, 30);
		addTextInput(item, "Test Input", 0, 120, 150, 30);
		addToggleButton(item, "Test Toggle", 0, 155, 150, 30);
		addSlider(item, 0, 180, 150, 30, false);
	}
	public static function addButton(parent:ComposeGroup, text:String, x:Float, y:Float, w:Float, h:Float, selectable:Bool):Void {
		var item:ComposeItem = new ComposeItem();
		item.addTraits([TextButtonTag(selectable), new BoxPos(x, y, w, h), new TextLabel(text)]);
		parent.addChild(item);
	}
	public static function addLabel(parent:ComposeGroup, text:String, x:Float, y:Float, w:Float, h:Float):Void {
		var item:ComposeItem = new ComposeItem();
		item.addTraits([TextLabelTag, new BoxPos(x, y, w, h), new TextLabel(text)]);
		parent.addChild(item);
	}
	public static function addTextInput(parent:ComposeGroup, prompt:String, x:Float, y:Float, w:Float, h:Float):Void {
		var item:ComposeItem = new ComposeItem();
		item.addTraits([TextInputTag, new BoxPos(x, y, w, h), new TextLabel(), new InputPrompt(prompt) ]);
		parent.addChild(item);
	}
	public static function addToggleButton(parent:ComposeGroup, label:String, x:Float, y:Float, w:Float, h:Float):Void {
		var item:ComposeItem = new ComposeItem();
		item.addTraits([ToggleButtonTag, new BoxPos(x, y, w, h), new TextLabel(label)]);
		parent.addChild(item);
	}
	public static function addSlider(parent:ComposeGroup, x:Float, y:Float, w:Float, h:Float, vert:Bool):Void {
		var item:ComposeItem = new ComposeItem();
		item.addTraits([SliderTag(vert), new BoxPos(x, y, w, h)]);
		parent.addChild(item);
	}
	
}