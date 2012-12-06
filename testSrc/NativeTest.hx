package ;
import composure.core.ComposeGroup;
import composure.core.ComposeRoot;
import guise.platform.native.NativePlatformAccess;
import guiseSkins.styled.styles.ChutzpahStyle;
import org.tbyrne.logging.LoggerList;
import guise.test.TestControls;
import guise.core.CoreTags;

/**
 * ...
 * @author Tom Byrne
 */

class NativeTest 
{
	public static function main() {
		new NativeTest();
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
		NativePlatformAccess.install(stage);
		TestControls.addControls(stage, 10, 10);
	}
}