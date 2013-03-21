package guise.platform.waxe.controls;
import wx.clay.StyleFlags;
import wx.Window;
import wx.ComboBox;
import guise.platform.waxe.display.DisplayTrait;
import guise.data.ITextLabel;

class OptionPickerTrait extends AbsListTrait<ComboBox>
{
	
	@:isVar public var editable(default, set_editable):Bool;
	private function set_editable(value:Bool):Bool {
		editable = value;
		rebuildWindow();
		return value;
	}

	public function new(editable:Bool=false) 
	{
		this.editable = editable;
		_allowSizing = true;
		super(function(parent:Window):ComboBox return ComboBox.create(parent, null, "", null, null, _items, (editable?null:StyleFlags.CB_READONLY)));
	}
	
	override private function onParentAdded(parent:DisplayTrait<Window>):Void {
		if (_items == null) return;
		
		super.onParentAdded(parent);
	}
	
	override private function compileItems():Void {
		super.compileItems();
		rebuildWindow();
	}
	override private function onTextChanged(from:ITextLabel):Void {
		super.onTextChanged(from);
		rebuildWindow();
	}
}