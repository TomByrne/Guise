package guise.platform.html5.display;

import js.Browser;


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
		super(Browser.document.body);
		trace("StageTrait: "+domElement+" "+Browser.document.body);
	}
	
}