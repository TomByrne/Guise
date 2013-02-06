package guise.platform.cross;

import cmtc.ds.hash.ObjectHash;
import composure.core.ComposeItem;
import composure.traits.AbstractTrait;
import guise.accessTypes.IAccessType;
import guise.layer.LayerAccessRequire;

class AccessProvider extends AbstractTrait
{
	private var _accessClassMap:Hash<Class<Dynamic>>;
	private var _itemToLayers:ObjectHash<ComposeItem, Hash<LayerInfo>>;
	private var _addTraitHandler:ComposeItem->String->Dynamic->Void;
	private var _removeTraitHandler:ComposeItem->String->Dynamic->Void;

	public function new(?addTraitHandler:ComposeItem->String->Dynamic->Void, ?removeTraitHandler:ComposeItem->String->Dynamic->Void) 
	{
		super();
		_accessClassMap = new Hash();
		_itemToLayers = new ObjectHash();
		_addTraitHandler = addTraitHandler;
		_removeTraitHandler = removeTraitHandler;
	}
	
	
	public function mapAccessType<T>(accessType:T, klass:Class<T>):Void {
		var key:String = Type.getClassName(cast accessType);
		_accessClassMap.set(key, klass);
	}
	
	@injectAdd({desc:true})
	public function onAccessRequireAdd(accessReq:LayerAccessRequire, item:ComposeItem):Void {
		var layerHash:Hash<LayerInfo> = _itemToLayers.get(item);
		var layerInfo:LayerInfo;
		if (layerHash != null) {
			layerInfo = layerHash.get(accessReq.layerName);
		}else {
			layerHash = new Hash();
			_itemToLayers.set(item, layerHash);
			layerInfo = null;
		}
		
		if (layerInfo==null) {
			layerInfo = new LayerInfo(accessReq.layerName);
			layerHash.set(accessReq.layerName, layerInfo);
		}
		for (req in accessReq.accessTypes) {
			var klass:Class<Dynamic>;
			var key:String = Type.getClassName(req);
			if (_accessClassMap.exists(key)) {
				klass = _accessClassMap.get(key);
				key = Type.getClassName(klass);
			}else{
				klass = req;
			}
			if (!layerInfo.requirements.exists(key)) {
				
				var trait:Dynamic = item.getTrait(klass);
				if (Std.is(trait, IAccessType)) {
					var access:IAccessType = cast trait;
					if(access.layerName != accessReq.layerName)trait = null;
				}
				if (trait == null ) {
					if (req==klass) {
						try{
							trait = Type.createInstance(klass, []);
						}catch (e:Dynamic) {
							throw "Platform accessor "+klass+" is not available for this platform.";
						}
					}else {
						trait = Type.createInstance(klass, []);
					}
				}
				if (Std.is(trait, IAccessType)) {
					var access:IAccessType = cast trait;
					access.layerName = accessReq.layerName;
				}
				item.addTrait(trait);
				layerInfo.requirements.set(key, 1);
				layerInfo.accessors.set(key, trait);
				if (_addTraitHandler != null) {
					_addTraitHandler(item, accessReq.layerName, trait);
				}
			}else {
				layerInfo.requirements.set(key, layerInfo.requirements.get(key)+1);
			}
			layerInfo.totalReqs++;
		}
	}
	@injectRemove({desc:true})
	public function onAccessRequireRemove(accessReq:LayerAccessRequire, item:ComposeItem):Void {
		var layerHash:Hash<LayerInfo> = _itemToLayers.get(item);
		var layerInfo:LayerInfo = layerHash.get(accessReq.layerName);
		
		for (req in accessReq.accessTypes) {
			var klass:Class<Dynamic>;
			var key:String = Type.getClassName(req);
			if (_accessClassMap.exists(key)) {
				klass = _accessClassMap.get(key);
				key = Type.getClassName(klass);
			}else{
				klass = req;
			}
			
			var count:Int = layerInfo.requirements.get(key);
			if (count > 1) {
				layerInfo.requirements.set(key, count - 1);
			}else {
				var trait:Dynamic = layerInfo.accessors.get(key);
				item.removeTrait(trait);
				layerInfo.accessors.remove(key);
				layerInfo.requirements.remove(key);
				if (_removeTraitHandler != null) {
					_removeTraitHandler(item, accessReq.layerName, trait);
				}
			}
			layerInfo.totalReqs--;
		}
		if (layerInfo.totalReqs == 0) {
			layerHash.remove(accessReq.layerName);
		}
	}
}
class LayerInfo {
	
	public var name:String;
	public var requirements:Hash<Int>;
	public var accessors:Hash<IAccessType>;
	public var totalReqs:Int;
	
	public function new(name:String) {
		this.name = name;
		requirements = new Hash();
		accessors = new Hash();
		totalReqs = 0;
	}
}