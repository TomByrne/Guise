package guise.platform.nme.display;
import guise.core.AbsPosSizeAwareTrait;
import composure.injectors.Injector;
import composure.traitCheckers.TraitTypeChecker;
import nme.display.DisplayObjectContainer;
import nme.display.Sprite;

/**
 * ...
 * @author Tom Byrne
 */

class ContainerSkin extends DisplaySkin
{
	public var container(default, null):DisplayObjectContainer;
	public var sprite(default, null):Sprite;

	public function new(container:DisplayObjectContainer = null) {
		if (container != null)setContainer(container);
		super(container);
	}
	override private function assumeDisplayObject():Void {
		setContainer(new Sprite());
	}
	private function setContainer(container:DisplayObjectContainer):Void {
		this.container = container;
		if (Std.is(container, Sprite)) this.sprite = cast container;
		else sprite = null;
		setDisplayObject(container);
	}
}