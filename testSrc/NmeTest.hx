package ;
import composure.core.ComposeGroup;
import composure.core.ComposeRoot;
import guise.skin.drawn.utils.ChutzpahStyle;
import org.tbyrne.logging.LoggerList;
import guise.test.TestControls;
import guise.core.CoreTags;
import xmlTools.CodeGenMacro;



class NmeTest 
{
	public static function main() {
		new NmeTest();
	}
	
	private var root:ComposeRoot;
	private var window:ComposeGroup;

	public function new() 
	{
		LoggerList.install();
		
		var root:ComposeRoot = new ComposeRoot();
		
		window = new ComposeGroup();
		window.addTrait(WindowTag);
		root.addChild(window);
		
		var stage = new ComposeGroup();
		stage.addTrait(StageTag);
		window.addChild(stage);
		CodeGenMacro.path("/../Platforms/NME.xml").install(stage);
		ChutzpahStyle.install(stage);
		TestControls.addControls(stage, 10, 10);
	}
}