package guise.platform.html5.controls;

import composure.core.ComposeItem;
import guise.controls.data.IListCollection;
import guise.controls.data.ITextLabel;
import guise.platform.html5.display.DisplayTrait;
import js.Dom;
import js.Lib;

using Lambda;

class ListBoxTrait extends DisplayTrait
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
	
	private var _element:Select;

	public function new() 
	{
		_allowSizing = true;
		_element = cast Lib.document.createElement("select");
		super(_element);
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
		_element.setAttribute("size", Std.string(_textLabels.length));
		compileItems();
	}
	private function compileItems():Void {
		while (_element.options.length>0) {
			_element.removeChild(_element.options[0]);
		}
		for (textLabel in _textLabels) {
			var option = cast Lib.document.createElement("option");
			option.text = textLabel.text;
			_element.appendChild(option);
		}
		checkMeas();
	}
	private function onTextChanged(from:ITextLabel):Void {
		var index:Int = _textLabels.indexOf(from);
		var option:Option = _element.options[index];
		option.text = from.text;
		checkMeas();
	}
}