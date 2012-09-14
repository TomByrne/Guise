package guise.platform.nme.display;
import guise.core.AbsPosSizeAwareTrait;
import nme.display.GradientType;
import nme.display.Shape;
import nme.display.Stage;
import nme.display.StageAlign;
import nme.display.StageScaleMode;
import nme.geom.Matrix;
import guise.platform.nme.display.ContainerSkin;
import guise.platform.nme.core.FrameTicker;

/**
 * @author Tom Byrne
 */

class StageSkin extends AbsPosSizeAwareTrait
{
	public var stage(get_stage, null):Stage;
	private function get_stage():Stage {
		return _stage;
	}
	
	private var _stage:Stage;

	public function new() 
	{
		super();
		
		_stage = nme.Lib.stage;
		_stage.align = StageAlign.TOP_LEFT;
		_stage.scaleMode = StageScaleMode.NO_SCALE;
		
		addSiblingTrait(new ContainerSkin(_stage));
		
		/*var ref = new Shape();
		ref.x = ref.y = 60;
		var mat:Matrix = new Matrix(1, 0, 0, 1, 0, 0);
		mat.createGradientBox(100, 30, Math.PI/2, 0, 0);
		ref.graphics.beginGradientFill(GradientType.LINEAR, [0, 0xffffff], [1, 1], [0, 0xff], mat);
		ref.graphics.drawRect(0, 0, 100, 100);
		_stage.addChild(ref);*/
		
	}
	
	override private function posChanged():Void {
		// ContainerSkin will handle this
	}
	/*override private function sizeChanged():Void {
		// this doesn't work yet (just scales contents)
		_stage.stageWidth = size.width;
		_stage.stageHeight = size.height;
	}*/
}