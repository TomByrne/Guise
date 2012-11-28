package guise.layer;
import composure.injectors.Injector;
import composure.traits.AbstractTrait;
import guise.controls.ControlLayers;
import guise.platform.types.DisplayAccessTypes;
import org.tbyrne.collections.UniqueList;

import msignal.Signal;
import composure.traitCheckers.TraitTypeChecker;
import guise.platform.PlatformAccessor;
/**
 * ...
 * @author Tom Byrne
 */

class LayerOrderer extends AbstractTrait
{
	public var sorting(default,set_sorting):Array<String>;
	private function set_sorting(value:Array<String>):Array<String> {
		sorting = value;
		if (sorting != null && _layerOrderAccess!=null) {
			checkDepths();
		}
		return value;
	}

	private var _layerOrderAccess:ILayerOrderAccess;
	
	public function new(?sorting:Array<String>, childMode:Bool=true) 
	{
		super();
		
		this.sorting = sorting;
		
		addSiblingTrait(new PlatformAccessor(ILayerOrderAccess, null, onLayeringAdd, onLayeringRemove));
	}
	
	public function onLayeringAdd(access:ILayerOrderAccess):Void {
		_layerOrderAccess = access;
		_layerOrderAccess.layeringChanged.add(onLayeringChanged);
		if (sorting != null) {
			checkDepths();
		}
	}
	private function onLayeringChanged(from:ILayerOrderAccess):Void {
		if (sorting != null )checkDepths();
	}
	public function onLayeringRemove(access:ILayerOrderAccess):Void {
		_layerOrderAccess.layeringChanged.remove(onLayeringChanged);
		_layerOrderAccess = null;
	}
	
	private function checkDepths():Void {
		var layers = _layerOrderAccess.layers;
		var depth1:Int = 0;
		while (depth1 < layers.length - 1) {
			var layer1 = layers[depth1];
			var index1 = Lambda.indexOf(sorting, layer1);
			if (index1 != -1) {
				var depth2:Int = depth1 + 1;
				while(depth2 < layers.length){
					var layer2 = layers[depth2];
					var index2 = Lambda.indexOf(sorting, layer2);
					
					if (index2 != -1 && index1 > index2) {
						_layerOrderAccess.swapDepths(layer1, layer2);
					}
					
					++depth2;
				}
			}
			++depth1;
		}
	}
	/*private function onSortingChanged(from:LayerSorting):Void {
		checkDepths();
	}*/
}