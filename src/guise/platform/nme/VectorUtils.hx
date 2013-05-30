package guise.platform.nme;
import nme.Vector;

class VectorUtils
{

	inline static public function fromArray<T>(arr:Array<T>):Vector<T> 
	{
		var ret:Vector<T> = new Vector<T>();
		for (elem in arr) ret.push(elem);
		return ret;
	}
	
}