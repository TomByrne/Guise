package guise.platform.basisApple.controls;
import guise.controls.data.ISelected;
import guise.controls.data.ITextLabel;
import guise.layout.IBoxPos;
import guise.platform.basisApple.display.DisplayTrait;
import apple.ui.*;


class TextButtonTrait extends DisplayTrait<UIButton>
{
	@inject
	@:isVar public var textLabel(default, set):ITextLabel;
	private function set_textLabel(value:ITextLabel):ITextLabel {
		if (textLabel!=null) {
			textLabel.textChanged.remove(onTextChanged);
		}
		textLabel = value;
		if (textLabel!=null) {
			textLabel.textChanged.add(onTextChanged);
			if(view!=null)onTextChanged(textLabel);
		}
		return value;
	}
	@inject
	@:isVar public var selected(default, set):ISelected;
	private function set_selected(value:ISelected):ISelected {
		if (selected!=null) {
			selected.selectedChanged.remove(onSelectedChanged);
		}
		selected = value;
		if (selected != null) {
			
			selected.selectedChanged.add(onSelectedChanged);
			onSelectedChanged(selected);
		}
		return value;
	}

	public function new() 
	{
		_allowSizing = true;
		super(UIButton.buttonWithType(UIButton.UIButtonTypeRoundedRect));
	}
	override private function onParentAdded(parent:DisplayTrait<UIView>):Void {
		super.onParentAdded(parent);
		if (textLabel != null) onTextChanged();
	}
	
	private function onTextChanged(from:ITextLabel=null):Void {
		var text:String = textLabel.text;
		view.setTitleForState(text, UIControl.UIControlStateNormal);
		checkMeas();
	}
	
	private function onSelectedChanged(from:ISelected):Void {
		//_checkbox.checked = selected.selected;
	}
	/*private function onCheckboxClick(e:Event):Void {
		onSelectedChanged(selected);
	}*/
}