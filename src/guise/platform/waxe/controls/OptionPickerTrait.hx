package guise.platform.waxe.controls;
import wx.clay.StyleFlags;
import wx.Window;
import wx.ComboBox;
import guise.platform.waxe.display.DisplayTrait;
import guise.controls.data.ITextLabel;

class OptionPickerTrait extends AbsListTrait<ComboBox>
{

	public function new() 
	{
		_allowSizing = true;
		super(function(parent:Window):ComboBox return ComboBox.create(parent, null, "", null, null, _items, StyleFlags.CB_READONLY));
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