package guise.platform.waxe.controls;
import guise.platform.waxe.display.DisplayTrait;
import wx.Panel;
import wx.Window;


class PanelTrait extends DisplayTrait<Panel>
{
	public function new() 
	{
		_allowSizing = true;
		super(function(parent:Window):Panel return Panel.create(parent));
	}
}