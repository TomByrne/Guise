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
import guise.layout.IBoxPos;
import guise.layout.simple.VStackLayout;
import guise.layout.SizeByMeas;


class TestControls 
{
	public static function addControls(parent:ComposeGroup, x:Float = 0, y:Float = 0 ):Void {
		
		var item:ComposeGroup = new ComposeGroup();
		item.addTraits([PanelTag, new SizeByMeas(x,y), new VStackLayout(10,10,10, 10, 10)]);
		parent.addChild(item);
		
		addButton(item, "Test Button", false);
		addButton(item, "Selectable Button", true);
		addLabel(item, "Test Label");
		addTextInput(item, "Test Input");
		addToggleButton(item, "Test Toggle");
		addSlider(item, false);
	}
	public static function addButton(parent:ComposeGroup, text:String, selectable:Bool):Void {
		var item:ComposeItem = new ComposeItem();
		item.addTraits([TextButtonTag(selectable), new VStackLayoutInfo(), new TextLabel(text)]);
		parent.addChild(item);
	}
	public static function addLabel(parent:ComposeGroup, text:String):Void {
		var item:ComposeItem = new ComposeItem();
		item.addTraits([TextLabelTag, new VStackLayoutInfo(), new TextLabel(text)]);
		parent.addChild(item);
	}
	public static function addTextInput(parent:ComposeGroup, prompt:String):Void {
		var item:ComposeItem = new ComposeItem();
		item.addTraits([TextInputTag, new VStackLayoutInfo(), new TextLabel(), new InputPrompt(prompt) ]);
		parent.addChild(item);
	}
	public static function addToggleButton(parent:ComposeGroup, label:String):Void {
		var item:ComposeItem = new ComposeItem();
		item.addTraits([ToggleButtonTag, new VStackLayoutInfo(), new TextLabel(label)]);
		parent.addChild(item);
	}
	public static function addSlider(parent:ComposeGroup, vert:Bool):Void {
		var item:ComposeItem = new ComposeItem();
		item.addTraits([SliderTag(vert), new VStackLayoutInfo()]);
		parent.addChild(item);
	}
	
}