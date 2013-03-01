package guise.test;

import composure.core.ComposeGroup;
import composure.core.ComposeItem;
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
		//item.addTraits([PanelTag, new SizeByMeas(x,y), new VStackLayout(10,10,10, 10, 10)]);
		parent.addChild(item);
		
		/*addButton(item, "Test Button", false);
		addButton(item, "Selectable Button", true);
		addLabel(item, "Test Label");
		addTextInput(item, "Test Input");
		addToggleButton(item, "Test Toggle");
		addSlider(item, false);*/
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
	
}