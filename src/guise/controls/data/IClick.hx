package guise.controls.data;

import msignal.Signal;

/**
 * ...
 * @author Tom Byrne
 */

interface IClick 
{
	public var clicked(get_clicked, null):Signal1<IClick>;
}