package guise.platform.waxe.controls;
import composure.core.ComposeItem;
import guise.controls.data.IListCollection;
import guise.controls.data.ITextLabel;
import wx.ListBox;
import wx.Window;
import guise.platform.waxe.display.DisplayTrait;

using Lambda;

class ListBoxTrait extends DisplayTrait<ListBox>
{
	private static var DUMMY_ITEM:ComposeItem;
	
	@inject
	@:isVar public var listCollection(default, set_listCollection):IListCollection<Dynamic>;
	private function set_listCollection(value:IListCollection<Dynamic>):IListCollection<Dynamic> {
		if (listCollection != null) {
			listCollection.listChanged.remove(onListChanged);
		}
		this.listCollection = value;
		if (listCollection != null) {
			listCollection.listChanged.add(onListChanged);
			onListChanged(listCollection);
		}
		return value;
	}
	
	private var _textLabels:Array<ITextLabel>;
	private var _items:Array<String>;

	public function new() 
	{
		_allowSizing = true;
		super(function(parent:Window):ListBox return ListBox.create(parent, null, null, null, _items));
	}
	
	private function onListChanged(from:IListCollection<Dynamic>):Void {
		if (_textLabels != null) {
			for (textLabel in _textLabels) {
				textLabel.textChanged.remove(onTextChanged);
			}
		}
		_textLabels = [];
		for (item in from.iterateFrom(0)) {
			var textLabel:ITextLabel;
			
			if (Std.is(item, ITextLabel)) {
				textLabel = cast item;
			}else {
				if (DUMMY_ITEM == null) {
					DUMMY_ITEM = new ComposeItem();
				}
				DUMMY_ITEM.addTrait(item);
				textLabel = DUMMY_ITEM.getTrait(ITextLabel);
				DUMMY_ITEM.removeTrait(item);
			}
			if (textLabel == null) {
				throw "Couldn't find ITextLabel for ListBox item";
			}else {
				_textLabels.push(textLabel);
				textLabel.textChanged.add(onTextChanged);
			}
		}
		compileItems();
	}
	private function compileItems():Void {
		_items = [];
		for (textLabel in _textLabels) {
			_items.push(textLabel.text);
		}
		if (window != null) {
			window.set(_items);
			checkMeas();
		}
	}
	private function onTextChanged(from:ITextLabel):Void {
		var index:Int = _textLabels.indexOf(from);
		_items[index] = from.text;
		if (window != null) {
			window.set(_items);
			checkMeas();
		}
	}
}