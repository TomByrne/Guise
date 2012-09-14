package guise.platform.types;
import guise.traits.core.IPosition;
import guise.traits.core.ISize;
import guise.platform.IPlatformAccess;
import msignal.Signal;
/**
 * ...
 * @author Tom Byrne
 */

class DisplayAccessTypes 
{}

interface IScreenInfo 
{
	public var availSizeChanged(default, null):Signal1<IScreenInfo>;
	
	public var availWidth(default, null):Int;
	public var availHeight(default, null):Int;
	
}

interface ISizableDisplayAccess implements IAccessType {
	public var measChanged(get_measChanged, null):Signal1<ISizableDisplayAccess>;
	
	public function getMeasWidth():Float;
	public function getMeasHeight():Float;
	
	public function setPos(value:IPosition):Void;
	public function setSize(value:ISize):Void;
}

interface ILayerOrderAccess implements IAccessType {
	public var layeringChanged(get_layeringChanged, null):Signal1<ILayerOrderAccess>;
	public var layers(default, null):Array<String>;
	public function swapDepths(layer1:String, layer2:String):Void;
}

interface IFilterableAccess implements IAccessType {
	function setFilters(?filters:Array<FilterType>):Void;
	
}
enum FilterType {
	DropShadow(distance:Float, angle:Float, size:Float, color:Int, alpha:Float, ?inner:Bool);
	Glow(size:Float, color:Int, alpha:Float, ?inner:Bool);
}
