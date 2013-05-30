package guise;


enum ControlTags {
	PanelTag;
	ListBoxTag;
	OptionPickerTag(editable:Bool);
	HScrollBarTag;
	VScrollBarTag;
}

import guise.data.IInputPrompt;
import guise.data.IListCollection;
import guise.data.ISelected;
import guise.data.ITextLabel;
import msignal.Signal;


class TextButtonTag extends TextLabel
{
	public var selectable(default, null):Bool;

	public function new(selectable:Bool=false, ?label:String) 
	{
		this.selectable = selectable;
		super(label);
	}
}


@:build(LazyInst.check())
class TextInputTag extends TextLabel, implements IInputPrompt
{
	@lazyInst public var promptChanged:Signal1<IInputPrompt>;
	
	@change("promptChanged")
	public var prompt(default, null):String;

	public function new(?prompt:String, ?text:String) 
	{
		super(text);
		setPrompt(prompt);
	}
	
	public function setPrompt(prompt:String):Void {
		if (this.prompt == prompt) return;
		
		this.prompt = prompt;
		LazyInst.exec(promptChanged.dispatch(this));
	}
	
}

class TextLabelTag extends TextLabel
{
	public function new(?text:String) 
	{
		super(text);
	}
}

class ToolTipTag extends TextLabel
{
	public function new(?text:String) 
	{
		super(text);
	}
}


@:build(LazyInst.check())
class ToggleButtonTag extends TextLabel, implements ISelected
{
	@lazyInst public var selectedChanged:Signal1<ISelected>;
	
	@change("selectedChanged")
	public var selected(default, null):Bool;

	public function new(?label:String, ?selected:Bool) 
	{
		super(label);
		setSelected(selected);
	}
	
	public function setSelected(selected:Bool):Void {
		if (this.selected == selected) return;
		
		this.selected = selected;
		LazyInst.exec(selectedChanged.dispatch(this));
	}
}


class SliderTag
{
	public var vert(default, null):Bool;

	public function new(vert:Bool=false) 
	{
		this.vert = vert;
	}
}