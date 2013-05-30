package guise.logic.popout;
import guise.ControlTags;
import guise.data.IControlInfo;



class BoxLabeller extends AbsPopoutTrait
{
	private var type:ControlInfoType;
	private var controlInfo:IControlInfo;
	private var textLabel:ToolTipTag;

	public function new(?type:ControlInfoType) 
	{
		super();
		this.type = (type==null?ControlInfoType.FocusTip:type);
		textLabel = new ToolTipTag();
		popoutItem.addTrait(textLabel);
	}
	
	
	@injectAdd
	private function addControlInfo(controlInfo:IControlInfo):Void {
		if (this.controlInfo!=null || controlInfo.type != type) return;
		
		this.controlInfo = controlInfo;
		controlInfo.infoChanged.add(onInfoChanged);
		onInfoChanged(controlInfo);
		invalidate();
	}
	@injectRemove
	private function removeControlInfo(controlInfo:IControlInfo):Void {
		if (controlInfo != this.controlInfo) return;
		
		textLabel.setText(null);
		controlInfo.infoChanged.remove(onInfoChanged);
		this.controlInfo = null;
	}
	
	override private function _isReadyToDraw():Bool {
		return super._isReadyToDraw() && controlInfo!=null;
	}
	
	private function onInfoChanged(controlInfo:IControlInfo):Void {
		textLabel.setText(controlInfo.info);
	}
}