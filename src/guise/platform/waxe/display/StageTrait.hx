package guise.platform.waxe.display;
import guise.platform.waxe.controls.PanelTrait;


class StageTrait extends PanelTrait
{
	private static var _inst:StageTrait;
	public static function inst():StageTrait {
		if (_inst == null) {
			_inst = new StageTrait();
		}
		return _inst;
	}

	public function new() 
	{
		super();
		_allowSizing = false;
	}
}