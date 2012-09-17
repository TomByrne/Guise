package ;
import composure.core.ComposeGroup;
import composure.core.ComposeItem;
import composure.core.ComposeRoot;
import guise.controls.ControlLayers;
import guise.controls.data.IInputPrompt;
import guise.core.GuiseItem;
import guise.Guise;
import composure.utilTraits.Furnisher;
import guise.layout.Position;
import guise.layout.PositionManager;
import guise.controls.logic.input.ClickToggleSelect;
import guise.platform.native.NativePlatformAccess;
import guise.traits.tags.CoreTags;
import guise.traits.tags.ControlTags;
import guise.utils.Closures;
import guiseSkins.styled.BoxLayer;
import guiseSkins.styled.FilterLayer;
import guiseSkins.trans.ColorEaser;
import guiseSkins.trans.StyleTransitioner;
import guiseSkins.trans.TransStyle;
import nme.Lib;
import guise.traits.states.ControlStates;
import org.tbyrne.logging.LoggerList;
import guiseSkins.styled.styles.ChutzpahStyle;
import guise.platform.nme.NmePlatformAccess;
import guise.controls.data.ITextLabel;
import guise.controls.data.ISelected;

/**
 * ...
 * @author Tom Byrne
 */

class GraphicsComparisonTest 
{
	public static function main() {
		new GraphicsComparisonTest();
	}
	
	private var root:ComposeRoot;
	private var window:GuiseItem;

	public function new() 
	{
		LoggerList.install();
		
		var root:ComposeRoot = new ComposeRoot();
		root.addTrait(new PositionManager());
		
		window = new GuiseItem();
		window.addTrait(new WindowTag());
		root.addChild(window);
		
		// NME
		var nmeStage = new ComposeGroup();
		nmeStage.addTrait(new StageTag());
		window.addChild(nmeStage);
		NmePlatformAccess.install(nmeStage);
		ChutzpahStyle.install(nmeStage);
		addControls(10, nmeStage);
		
		// Native
		var nativeStage = new ComposeGroup();
		nativeStage.addTrait(new StageTag());
		window.addChild(nativeStage);
		NativePlatformAccess.install(nativeStage);
		addControls(170, nativeStage);
	}
	public function addControls(x:Float, parent:ComposeGroup):Void{
		
		addButton(parent, "Test Button", x,10,150,30,false);
		addButton(parent, "Selectable Button", x,50,150,30,true);
		addLabel(parent, "Test Label", x,90,150,30);
		addTextInput(parent, "Test Input", x,130,150,30);
	}
	private function addButton(parent:ComposeGroup, text:String, x:Float, y:Float, w:Float, h:Float, selectable:Bool):Void {
		var item:ComposeItem = new ComposeItem();
		item.addTraits([TextButtonTag, new Position(x, y, w, h), new TextLabel(text)]);
		if(selectable)item.addTraits([new ClickToggleSelect(), new Selected()]);
		parent.addChild(item);
	}
	private function addLabel(parent:ComposeGroup, text:String, x:Float, y:Float, w:Float, h:Float):Void {
		var item:ComposeItem = new ComposeItem();
		item.addTraits([TextLabelTag, new Position(x, y, w, h), new TextLabel(text)]);
		parent.addChild(item);
	}
	private function addTextInput(parent:ComposeGroup, prompt:String, x:Float, y:Float, w:Float, h:Float):Void {
		var item:ComposeItem = new ComposeItem();
		item.addTraits([TextInputTag, new Position(x, y, w, h), new TextLabel(), new InputPrompt(prompt) ]);
		parent.addChild(item);
	}
}