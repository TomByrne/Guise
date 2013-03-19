package guise.platform.html5.controls;

class ListBoxTrait extends OptionPickerTrait
{

	public function new() 
	{
		super();
	}
	override private function compileItems():Void {
		_element.setAttribute("size", Std.string(_textLabels.length));
		super.compileItems();
	}
}