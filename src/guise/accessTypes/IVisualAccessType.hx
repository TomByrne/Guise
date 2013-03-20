package guise.accessTypes;

import msignal.Signal;

interface IVisualAccessType implements IAccessType
{
	public var idealDepth(default, set_idealDepth):Int;
	public var idealDepthChanged(get_idealDepthChanged, null):Signal1<IVisualAccessType>;
}