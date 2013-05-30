package ;
import composure.core.ComposeGroup;
import composure.core.ComposeRoot;
import guise.platform.native.NativePlatformAccess;
import org.tbyrne.logging.LoggerList;
import guise.test.TestControls;
import guise.core.CoreTags;


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
		
		NativePlatformAccess.install(window);
		TestControls.addControls(window, 0, 0);
	}
}