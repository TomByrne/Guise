package guise.test;

import composure.core.ComposeGroup;
import composure.core.ComposeItem;
import guise.data.IListCollection;
import guise.logic.input.ClickToggleSelect;
import guise.logic.input.TextInputPrompt;
import guise.core.CoreTags;
import guise.ControlTags;
import guise.data.ITextLabel;
import guise.data.ISelected;
import guise.data.IInputPrompt;
import guise.layout.IBoxPos;
import guise.layout.simple.VStackLayout;
import guise.layout.SizeByMeas;
import guise.meas.IMeasurement;
import guise.layout.simple.StackLayout;

class TestControls 
{
	public static function addControls(parent:ComposeGroup, x:Float = 0, y:Float = 0 ):Void {
		
		var item:ComposeGroup = new ComposeGroup();
		item.addTraits([/*PanelTag, */new SizeByMeas(x,y), new VStackLayout(10,10,10, 10, 10)]);
		parent.addChild(item);
		
		addButton(item, "Test Button", false);
		addButton(item, "Selectable Button", true);
		addLabel(item, "Test Label");
		addTextInput(item, "Test Input");
		addToggleButton(item, "Test Toggle");
		addSlider(item, false);
		addScrollPanel(item, "Scrollable Panel");
		addListBox(item);
		addOptionPicker(item, false, "Option Picker");
		addOptionPicker(item, true, "Editable Option Picker");
	}
	public static function addButton(parent:ComposeGroup, text:String, selectable:Bool):Void {
		parent.addChild(new ComposeItem([new TextButtonTag(selectable, text), new VStackLayoutInfo()]));
	}
	public static function addLabel(parent:ComposeGroup, text:String):Void {
		parent.addChild(new ComposeItem([new TextLabelTag(text), new VStackLayoutInfo()]));
	}
	public static function addTextInput(parent:ComposeGroup, prompt:String):Void {
		parent.addChild(new ComposeItem([new TextInputTag(prompt), new VStackLayoutInfo() ]));
	}
	public static function addToggleButton(parent:ComposeGroup, label:String):Void {
		parent.addChild(new ComposeItem([new ToggleButtonTag(label), new VStackLayoutInfo()]));
	}
	public static function addSlider(parent:ComposeGroup, vert:Bool):Void {
		parent.addChild(new ComposeItem([new SliderTag(vert), new VStackLayoutInfo()]));
	}
	public static function addScrollPanel(parent:ComposeGroup, label:String):Void {
		var panel = new ComposeGroup([PanelTag, new VStackLayoutInfo(-1,StackSizePolicy.Size(150),StackSizePolicy.Size(75)), new SimpleMeas(200, 100)]);
		panel.addChild(new ComposeItem([new TextLabelTag(label), new BoxPos(0,0,200,100)]));
		parent.addChild(panel);
	}
	public static function addListBox(parent:ComposeGroup):Void {
		var list:List<TextLabel> = new List<TextLabel>();
		for (i in 0...12) list.add(new TextLabel("Item " + i));
		parent.addChild(new ComposeItem([ListBoxTag, new ListCollection(list), new VStackLayoutInfo()]));
	}
	public static function addOptionPicker(parent:ComposeGroup, editable:Bool, prompt:String):Void {
		var list:List<TextLabel> = new List<TextLabel>();
		for (i in 0...12) list.add(new TextLabel("Item " + i));
		parent.addChild(new ComposeItem([OptionPickerTag(editable), new ListCollection(list), new VStackLayoutInfo(), new InputPrompt(prompt)]));
	}
	
}