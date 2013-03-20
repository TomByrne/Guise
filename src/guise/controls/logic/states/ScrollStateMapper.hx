package guise.controls.logic.states;
import composure.traits.AbstractTrait;
import guise.controls.scroll.IScrollMetrics;
import guise.states.State;
import guise.states.ControlStates;

class ScrollStateMapper extends AbstractTrait
{
	@inject
	@:isVar private var hScrollMetrics(default, set_hScrollMetrics):IHScrollMetrics;
	private function set_hScrollMetrics(value:IHScrollMetrics):IHScrollMetrics {
		if (hScrollMetrics != null) {
			hScrollMetrics.scrollChanged.remove(onHScrollChanged);
		}
		this.hScrollMetrics = value;
		if (hScrollMetrics != null) {
			hScrollMetrics.scrollChanged.add(onHScrollChanged);
			onHScrollChanged(hScrollMetrics);
		}
		return value;
	}
	
	@inject
	@:isVar private var vScrollMetrics(default, set_vScrollMetrics):IVScrollMetrics;
	private function set_vScrollMetrics(value:IVScrollMetrics):IVScrollMetrics {
		if (vScrollMetrics != null) {
			vScrollMetrics.scrollChanged.remove(onVScrollChanged);
		}
		this.vScrollMetrics = value;
		if (vScrollMetrics != null) {
			vScrollMetrics.scrollChanged.add(onVScrollChanged);
			onVScrollChanged(vScrollMetrics);
		}
		return value;
	}
	
	private var _hScrollState:State<HScrollState>;
	private var _vScrollState:State<VScrollState>;

	public function new() 
	{
		super();
		
		_hScrollState = new State();
		_hScrollState.set(HScrollState.INACTIVE);
		addSiblingTrait(_hScrollState);
		
		_vScrollState = new State();
		_vScrollState.set(VScrollState.INACTIVE);
		addSiblingTrait(_vScrollState);
	}
	
	private function onHScrollChanged(from:IHScrollMetrics):Void {
		_hScrollState.set((from.max-from.min)>from.pageSize?HScrollState.ACTIVE:HScrollState.INACTIVE);
	}
	private function onVScrollChanged(from:IVScrollMetrics):Void {
		_vScrollState.set((from.max-from.min)>from.pageSize?VScrollState.ACTIVE:VScrollState.INACTIVE);
	}
}