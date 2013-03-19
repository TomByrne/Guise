package guise.controls.data;

import msignal.Signal;

interface IListCollection<T>
{
	public var listChanged(get_listChanged, null):Signal1<IListCollection<T>>;
	function getTotalItems():Int;
	function iterateFrom(i:Int) : Iterator<T>;
	
}

@:build(LazyInst.check())
class ListCollection<T> implements IListCollection<T> {
	
	@lazyInst public var listChanged:Signal1<IListCollection<T>>;
	
	private var list:List<T>;
	
	public function new(?list:List<T>) {
		this.list = list;
	}
	
	
	public function getTotalItems():Int {
		return list.length;
	}
	
	public function iterateFrom(i:Int) : Iterator<T> {
		var ret:Iterator<T> = list.iterator();
		// TODO: this can obviously be optimised
		while (i > 0) {
			ret.next();
		}
		return ret;
	}
	
	public function setList(list:List<T>) : Void {
		if (this.list == list) return;
		this.list = list;
		LazyInst.exec(listChanged.dispatch(this));
	}
	
	public function add(item:T):Void {
		if (list == null) list = new List<T>();
		list.add(item);
		LazyInst.exec(listChanged.dispatch(this));
	}
	public function remove(item:T):Bool {
		if (list == null) return false;
		var ret = list.remove(item);
		LazyInst.exec(listChanged.dispatch(this));
		return ret;
	}
}