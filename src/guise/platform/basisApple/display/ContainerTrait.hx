package guise.platform.basisApple.display;

import apple.ui.UIView;

class ContainerTrait extends DisplayTrait<UIView>
{

	public function new(){
		trace("ContainerTrait");
		super(new UIView());
	}	

}