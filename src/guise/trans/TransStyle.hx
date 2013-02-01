package guise.trans;

import guise.trans.StyleTransitioner;

/**
 * ...
 * @author Tom Byrne
 */

class TransStyle {
	public var time:Float;
	public var easing:Easing;
	
	public function new(time:Float, easing:Easing) {
		this.time = time;
		this.easing = easing;
	}
}