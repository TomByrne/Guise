package guise.layer;

import msignal.Signal;

interface ILayerContainer 
{
	public var layeringChanged(get_layeringChanged, null):Signal1<ILayerContainer>;
	public function getLayers():Array<String>;
	public function swapDepths(layer1:String, layer2:String):Void;
}