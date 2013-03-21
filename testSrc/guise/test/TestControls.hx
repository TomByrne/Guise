package guise.test;

import composure.core.ComposeGroup;
import composure.core.ComposeItem;
import guise.data.IControlInfo;
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
		
		addButton(item, "Test Button", "This is a test button", false);
		addButton(item, "Selectable Button", "This is a button is togglable", true);
		addLabel(item, "Test Label", "Here's a text label");
		addTextInput(item, "Test Input", "Type something in me");
		addToggleButton(item, "Test Toggle", "Mo' Selecta");
		addSlider(item, false, "Slider tip");
		addScrollPanel(item, "Scrollable Panel");
		addListBox(item, "List Tip");
		addOptionPicker(item, false, "Option Picker", "Drop Down");
		addOptionPicker(item, true, "Editable Option Picker", "Combo Box");
	}
	public static function addButton(parent:ComposeGroup, text:String, tip:String, selectable:Bool):Void {
		parent.addChild(new ComposeItem([new TextButtonTag(selectable, text), new VStackLayoutInfo(), new ControlInfo(ControlInfoType.FocusTip, tip)]));
	}
	public static function addLabel(parent:ComposeGroup, text:String, tip:String):Void {
		parent.addChild(new ComposeItem([new TextLabelTag(text), new VStackLayoutInfo(), new ControlInfo(ControlInfoType.FocusTip, tip)]));
	}
	public static function addTextInput(parent:ComposeGroup, prompt:String, tip:String):Void {
		parent.addChild(new ComposeItem([new TextInputTag(prompt), new VStackLayoutInfo(), new ControlInfo(ControlInfoType.FocusTip, tip) ]));
	}
	public static function addToggleButton(parent:ComposeGroup, label:String, tip:String):Void {
		parent.addChild(new ComposeItem([new ToggleButtonTag(label), new VStackLayoutInfo(), new ControlInfo(ControlInfoType.FocusTip, tip)]));
	}
	public static function addSlider(parent:ComposeGroup, vert:Bool, tip:String):Void {
		parent.addChild(new ComposeItem([new SliderTag(vert), new VStackLayoutInfo(), new ControlInfo(ControlInfoType.FocusTip, tip)]));
	}
	public static function addScrollPanel(parent:ComposeGroup, label:String):Void {
		var panel = new ComposeGroup([PanelTag, new VStackLayoutInfo(-1,StackSizePolicy.Size(150),StackSizePolicy.Size(75)), new SimpleMeas(200, 100)]);
		panel.addChild(new ComposeItem([new TextLabelTag(label), new BoxPos(0,0,200,100)]));
		parent.addChild(panel);
	}
	public static function addListBox(parent:ComposeGroup, tip:String):Void {
		var list:List<TextLabel> = new List<TextLabel>();
		for (i in 0...12) list.add(new TextLabel("Item " + i));
		parent.addChild(new ComposeItem([ListBoxTag, new ListCollection(list), new VStackLayoutInfo(), new ControlInfo(ControlInfoType.FocusTip, tip)]));
	}
	public static function addOptionPicker(parent:ComposeGroup, editable:Bool, prompt:String, tip:String):Void {
		var list:List<TextLabel> = new List<TextLabel>();
		for (i in 0...12) list.add(new TextLabel("Item " + i));
		parent.addChild(new ComposeItem([OptionPickerTag(editable), new ListCollection(list), new VStackLayoutInfo(), new InputPrompt(prompt), new ControlInfo(ControlInfoType.FocusTip, tip)]));
	}
	
}