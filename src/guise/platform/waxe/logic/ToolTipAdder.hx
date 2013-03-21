package guise.platform.waxe.logic;
import composure.traits.AbstractTrait;
import guise.data.IControlInfo;
import guise.platform.waxe.display.DisplayTrait;
import wx.Window;
import wx.ToolTip;

class ToolTipAdder extends AbstractTrait
{
	
	@inject
	@:isVar public var displayTrait(default, set_displayTrait):DisplayTrait<Window>;
	private function set_displayTrait(value:DisplayTrait<Window>):DisplayTrait<Window> {
		if (displayTrait != null) {
			displayTrait.clear(this);
		}
		this.displayTrait = value;
		if (displayTrait != null) {
			displayTrait.on(this, function(window:Window):Void window.setToolTip(toolTip) , function(window:Window):Void window.setToolTip(null) );
		}
		return value;
	}
	
	private var controlInfo:IControlInfo;
	private var toolTip:ToolTip;

	public function new() 
	{
		super();
		toolTip = ToolTip.create("");
	}
	
	@injectAdd
	private function addControlInfo(controlInfo:IControlInfo):Void {
		if (this.controlInfo!=null || controlInfo.type != ControlInfoType.FocusTip) return;
		
		this.controlInfo = controlInfo;
		controlInfo.infoChanged.add(onInfoChanged);
		onInfoChanged(controlInfo);
		
	}
	@injectRemove
	private function removeControlInfo(controlInfo:IControlInfo):Void {
		if (controlInfo != this.controlInfo) return;
		
		toolTip.tip = "";
		controlInfo.infoChanged.remove(onInfoChanged);
		this.controlInfo = null;
	}
	
	
	private function onInfoChanged(controlInfo:IControlInfo):Void {
		toolTip.tip = controlInfo.info;
	}
}