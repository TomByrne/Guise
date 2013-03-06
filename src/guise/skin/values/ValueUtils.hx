package guise.skin.values;
import composure.core.ComposeItem;
import msignal.Signal;

class ValueUtils
{

	public static inline function update(value:IValue, item:ComposeItem, signalArray:Array<AnySignal>, changeHandler:Dynamic->Dynamic->Void, doRemoveListeners:Bool) 
	{
		var newSignals:Array<AnySignal> = value.update(item);
		if (newSignals != null) {
			var i:Int = 0;
			if(doRemoveListeners){
				while(i<signalArray.length) {
					var signal = signalArray[i];
					if (!Lambda.has(newSignals, signal)) {
						signalArray.remove(signal);
						signal.remove(changeHandler);
					}else {
						i++;
					}
				}
			}
			for (signal in newSignals) {
				if (!Lambda.has(signalArray, signal)) {
					signalArray.push(signal);
					signal.add(changeHandler);
				}
			}
		}else if(doRemoveListeners){
			while (signalArray.length>0) {
				var signal = signalArray[0];
				signalArray.remove(signal);
				signal.remove(changeHandler);
			}
		}
	}
	

	public static inline function clear(signalArray:Array<AnySignal>, changeHandler:Dynamic->Dynamic->Void) 
	{
		while (signalArray.length>0) {
			var signal = signalArray[0];
			signalArray.remove(signal);
			signal.remove(changeHandler);
		}
	}
}