package ;
import composure.core.ComposeGroup;
import composure.core.ComposeRoot;
import org.tbyrne.logging.LoggerList;
import guise.test.TestControls;
import guise.core.CoreTags;
import xmlTools.XmlToCode;



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
		
		XmlToCode.path("/../Platforms/NME.xml").install(window);
		XmlToCode.path("/../Styles/Chutzpah.xml").install(window);
		TestControls.addControls(window, 10, 10);
	}
}