package guise.platform.html5.logic;
import composure.traits.AbstractTrait;
import guise.data.IControlInfo;
import guise.platform.html5.display.DisplayTrait;

class ToolTipAdder extends AbstractTrait
{
	
	@inject
	@:isVar public var displayTrait(default, set_displayTrait):DisplayTrait;
	private function set_displayTrait(value:DisplayTrait):DisplayTrait {
		if (displayTrait != null) {
			displayTrait.domElement.title = null;
		}
		this.displayTrait = value;
		if (displayTrait != null) {
			if (controlInfo != null) {
				onInfoChanged(controlInfo);
			}
		}
		return value;
	}
	
	private var controlInfo:IControlInfo;

	public function new() 
	{
		super();
	}
	
	@injectAdd
	private function addControlInfo(controlInfo:IControlInfo):Void {
		if (this.controlInfo!=null || controlInfo.type != ControlInfoType.FocusTip) return;
		
		this.controlInfo = controlInfo;
		controlInfo.infoChanged.add(onInfoChanged);
		if (displayTrait != null) {
			onInfoChanged(controlInfo);
		}
	}
	@injectRemove
	private function removeControlInfo(controlInfo:IControlInfo):Void {
		if (controlInfo != this.controlInfo) return;
		
		if (displayTrait != null) {
			displayTrait.domElement.title = null;
		}
		controlInfo.infoChanged.remove(onInfoChanged);
		this.controlInfo = null;
	}
	
	
	private function onInfoChanged(controlInfo:IControlInfo):Void {
		displayTrait.domElement.title = controlInfo.info;
	}
}