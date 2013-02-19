package ;
import composure.core.ComposeGroup;
import composure.core.ComposeRoot;
import guise.skin.bitmap.utils.TexturePack;
import org.tbyrne.logging.LoggerList;
import guise.test.TestControls;
import guise.core.CoreTags;
import xmlTools.XmlToCode;



class TileLayerTest 
{
	public static function main() {
		new TileLayerTest();
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
		
		
		XmlToCode.path("/../Platforms/Starling.xml").install(stage);
		XmlToCode.path("/../Styles/Mani.xml").install(stage);
		TestControls.addControls(stage, 10, 10);
	}
}