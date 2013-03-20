package guise.platform.html5.controls;

class ListBoxTrait extends DropDownTrait
{

	public function new() 
	{
		super();
	}
	override private function compileItems():Void {
		_select.setAttribute("size", Std.string(_textLabels.length));
		super.compileItems();
	}
}