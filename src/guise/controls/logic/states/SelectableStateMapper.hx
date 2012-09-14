package guise.controls.logic.states;
import composure.traits.AbstractTrait;
import guise.controls.data.ISelected;
import guise.traits.states.ControlStates;
import guise.traits.states.State;

/**
 * ...
 * @author Tom Byrne
 */

class SelectableStateMapper extends AbstractTrait
{
	@inject
	public var selected(default, set_selected):ISelected;
	private function set_selected(value:ISelected):ISelected {
		if (selected != null) {
			selected.selectedChanged.remove(onSelectedChanged);
		}
		this.selected = value;
		if (selected != null) {
			selectableState.set(SelectableState.SELECTABLE);
			selected.selectedChanged.add(onSelectedChanged);
			onSelectedChanged(selected);
		}else {
			selectableState.set(SelectableState.UNSELECTABLE);
			selectedState.set(SelectedState.UNSELECTED);
		}
		return value;
	}
	
	private var selectableState:State<SelectableState>;
	private var selectedState:State<SelectedState>;

	public function new() 
	{
		super();
		
		selectableState = new State();
		selectableState.set(SelectableState.UNSELECTABLE);
		addSiblingTrait(selectableState);
		
		selectedState = new State();
		selectedState.set(SelectedState.UNSELECTED);
		addSiblingTrait(selectedState);
	}
	private function onSelectedChanged(from:ISelected):Void {
		selectedState.set(from.selected?SelectedState.SELECTED:SelectedState.UNSELECTED);
	}
}