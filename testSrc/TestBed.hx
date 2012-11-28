package ;
import guise.Guise;
import guise.controls.TextButton;
import composure.utilTraits.Furnisher;
import guise.core.CoreTags;
import guise.controls.ControlTags;
import guiseSkins.styled.controls.TextButtonSkin;

/**
 * ...
 * @author Tom Byrne
 */

class TestBed 
{
	public static function main() {
		new TestBed();
	}
	
	private var guise:Guise;

	public function new() 
	{
		trace("TestBed");
		guise = new Guise();
		
		var button:TextButton = new TextButton();
		button.position.set(10, 10);
		button.size.set(100, 20);
		
		guise.stage.addChild(button);
		
		#if js
		guise.root.addTrait(new Furnisher(WindowTag, [TType(guiseDisplay.html.core.WindowSkin)]));
		guise.root.addTrait(new Furnisher(StageTag, [TType(guiseDisplay.easeljs.core.StageSkin)]));
		guise.root.addTrait(new Furnisher(TextButtonTag, [TType(guiseDisplay.easeljs.core.ShapeSkin),TType(guiseDisplay.easeljs.core.ContainerSkin),TType(guiseDisplay.easeljs.input.MouseInteractions,guiseDisplay.easeljs.core.GraphicsSkin)]));
		#end
		
		#if flash
		
		#end
		
		guise.root.addTrait(new Furnisher(TextButtonTag, [TType(TextButtonSkin)]));
	}
	
}