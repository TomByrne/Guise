package guise.platform.waxe.display;
import wx.Window;
import wx.Panel;


class ContainerTrait<T:Window> extends DisplayTrait<T>
{

	public function new(?creator:Window->T) {
		super(creator);
	}
	
}