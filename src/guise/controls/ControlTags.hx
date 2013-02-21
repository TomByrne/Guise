package guise.controls;

/**
 * ...
 * @author Tom Byrne
 */

enum ControlTags {
	PanelTag;
	TextButtonTag(selectable:Bool);
	TextLabelTag;
	TextInputTag;
	ToggleButtonTag;
	SliderTag(vert:Bool);
}