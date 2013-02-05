package guise.platform.html5.display;

import js.Lib;


class StageTrait extends ContainerTrait
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
		super(Lib.document.body);
	}
	
}