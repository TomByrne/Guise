package guise.platform;
import composure.core.ComposeItem;
import composure.injectors.Injector;
import composure.traits.AbstractTrait;
import guise.platform.IPlatformAccess;
import cmtc.ds.hash.ObjectHash;

/**
 * @author Tom Byrne
 */

class AbsPlatformAccess<ContInfoType, LayerInfoType> extends AbstractTrait, implements IPlatformAccess
{
	//private var _contextToLayers:ObjectHash<ComposeItem, Hash<LayerInfoType>>;
	//private var _accessToLayer:ObjectHash<IAccessType, LayerInfoType>;
	
	private var _contextToBundle:ObjectHash<ComposeItem, ContBundle<ContInfoType, LayerInfoType>>;
	private var _accessToDetails:ObjectHash<IAccessType, RequestDetails>;
	
	private var _createContInfo:ComposeItem->ContInfoType;
	private var _destroyContInfo:ContInfoType->Void;
	private var _createLayerInfo:ContInfoType->String->LayerInfoType;
	private var _destroyLayerInfo:LayerInfoType->Void;
	
	private var _typeToCreate:ObjectHash<Class<IAccessType>, ContInfoType-> IAccessType>;
	private var _typeToDestroy:ObjectHash < Class<IAccessType>, ContInfoType-> IAccessType-> Void >;
	
	private var _typeToCreateLayer:ObjectHash<Class<IAccessType>, LayerInfoType-> IAccessType>;
	private var _typeToDestroyLayer:ObjectHash < Class<IAccessType>, LayerInfoType-> IAccessType-> Void >;
	
	//private var _contextToContInfo:ObjectHash<ComposeItem, ContInfoType>;

	public function new(createContInfo:ComposeItem->ContInfoType, destroyContInfo:ContInfoType->Void, createLayerInfo:ContInfoType->String->LayerInfoType, destroyLayerInfo:LayerInfoType->Void) 
	{
		super();
		
		_createContInfo = createContInfo;
		_destroyContInfo = destroyContInfo;
		_createLayerInfo = createLayerInfo;
		_destroyLayerInfo = destroyLayerInfo;
		
		_contextToBundle = new ObjectHash();
		_accessToDetails = new ObjectHash();
		
		_typeToCreate = new ObjectHash();
		_typeToDestroy = new ObjectHash();
		_typeToCreateLayer = new ObjectHash();
		_typeToDestroyLayer = new ObjectHash();
		
		//_contextToLayers = new ObjectHash();
		//_accessToLayer = new ObjectHash();
		//_contextToContInfo = new ObjectHash();
	}
	private function addContainerFurnisher<TagType>(tagType:Dynamic, onCreate:ContInfoType->TagType-> Array<Dynamic>, ?onDestroy:Null<ContInfoType->TagType-> Array<Dynamic>->Void>):Void {
		var bundle:FurnisherBundle<ContInfoType, LayerInfoType, TagType> = new FurnisherBundle(tagType, onCreate, onDestroy, getContBundle, assessBundle);
		addInjector(bundle.getInjector());
	}
	private function registerAccess < AccessClass > (klass:Class<AccessClass>, types:Array<Class<IAccessType>>, createHandler:ContInfoType-> AccessClass, destroyHandler:ContInfoType->AccessClass-> Void):Void {
		for(type in types){
			_typeToCreate.set(type, cast createHandler);
			_typeToDestroy.set(type, cast destroyHandler);
		}
	}
	private function registerLayerAccess < AccessClass > (klass:Class<AccessClass>, types:Array<Class<IAccessType>>, createHandler:LayerInfoType-> AccessClass, destroyHandler:LayerInfoType->AccessClass-> Void):Void {
		for(type in types){
			_typeToCreateLayer.set(type, cast createHandler);
			_typeToDestroyLayer.set(type, cast destroyHandler);
		}
	}
	public function accessTypeSupported(layerAccess:Bool, accessType:Class<IAccessType>):Bool {
		return layerAccess?_typeToCreateLayer.exists(cast accessType):_typeToCreate.exists(cast accessType);
	}
	
	public function requestAccess < AccessType : IAccessType > (context:ComposeItem, accessType:Class<AccessType>, ?layerName:Null<String>):AccessType {
		if (!accessTypeSupported(layerName != null, cast accessType)) {
			if(layerName!=null){
				throw Type.getClassName(Type.getClass(this)) + " Platform does not yet support access type: " + Type.getClassName(accessType)+" for layers";
			}else {
				throw Type.getClassName(Type.getClass(this)) + " Platform does not yet support access type: " + Type.getClassName(accessType)+" for containers";
			}
		}
		
		var contBundle = getContBundle(context);
		var ret:AccessType;
		if (layerName == null) {
			ret = contBundle.requestAccess(accessType);
		}else {
			ret = contBundle.requestLayerAccess(layerName, accessType);
		}
		_accessToDetails.set(ret, { context:context, layerName:layerName} );
		return ret;
	}
	private function getContBundle(context:ComposeItem):ContBundle<ContInfoType,LayerInfoType> {
		var contBundle = _contextToBundle.get(context);
		if (contBundle == null) {
			contBundle = new ContBundle<ContInfoType,LayerInfoType>(_createContInfo(context), _createLayerInfo, _destroyLayerInfo);
			contBundle.accessToCreate = _typeToCreate;
			contBundle.accessToDestroy = _typeToDestroy;
			contBundle.accessToCreateLayer = _typeToCreateLayer;
			contBundle.accessToDestroyLayer = _typeToDestroyLayer;
			_contextToBundle.set(context, contBundle);
		}
		return contBundle;
	}
	public function returnAccess(access:IAccessType):Void {
		var reqDetails = _accessToDetails.get(access);
		_accessToDetails.delete(access);
		
		var bundle = _contextToBundle.get(reqDetails.context);
		
		if (reqDetails.layerName == null) {
			bundle.returnAccess(access);
		}else {
			bundle.returnLayerAccess(reqDetails.layerName, access);
		}
		
		assessBundle(bundle, reqDetails.context);
		
		/*var layer = _accessToLayer.get(access);
		layer.returnAccess(access);
		
		if (layer.isEmpty()) {
			var context = layer.context;
			
			var layers = _contextToLayers.get(context);
			layers.remove(layer.name);
			layer.context = null;
			
			var keys = layers.keys();
			if (!keys.hasNext()) {
				_contextToLayers.remove(context);
				removeContext(context);
			}
		}*/
	}
	private function assessBundle(bundle:ContBundle<ContInfoType,LayerInfoType>, context:ComposeItem):Void {
		if (bundle.isEmpty()) {
			_contextToBundle.delete(context);
			_destroyContInfo(bundle.contInfo);
			bundle.cleanup();
		}
	}
	/*private function removeContext(context:ComposeItem):Void {
		// override me
	}*/
}
typedef RequestDetails = {
	var context:ComposeItem;
	var layerName:String;
}
class ContBundle<ContInfoType, LayerInfoType> extends AbsBundle<ContInfoType>{
	public var contInfo(default, null):ContInfoType;
	//public var context:ComposeItem;
	private var layers:Hash < LayerBundle < ContInfoType, LayerInfoType >> ;
	
	private var _createLayerInfo:ContInfoType->String->LayerInfoType;
	private var _destroyLayerInfo:LayerInfoType-> Void;
	
	private var _layerCount:Int = 0;
	private var _dependencyCount:Int = 0;
	
	public var accessToCreateLayer:ObjectHash<Dynamic, LayerInfoType -> IAccessType>;
	public var accessToDestroyLayer:ObjectHash<Dynamic, LayerInfoType -> IAccessType-> Void>;
	
	public function new(contInfo:ContInfoType, createLayerInfo:ContInfoType->String->LayerInfoType, destroyLayerInfo:LayerInfoType-> Void) 
	{
		super();
		
		this.contInfo = contInfo;
		_info = contInfo;
		
		_createLayerInfo = createLayerInfo;
		_destroyLayerInfo = destroyLayerInfo;
		
		layers = new Hash();
	}
	public function addDependency():Void {
		++_dependencyCount;
	}
	public function removeDependency():Void {
		--_dependencyCount;
	}
	
	public function requestLayerAccess < AccessType : IAccessType > (layerName:String, accessType:Class<AccessType>):AccessType {
		var layerBundle = layers.get(layerName);
		if (layerBundle==null) {
			layerBundle = new LayerBundle<ContInfoType, LayerInfoType>(_createLayerInfo(contInfo,layerName));
			layerBundle.accessToCreate = accessToCreateLayer;
			layerBundle.accessToDestroy = accessToDestroyLayer;
			layers.set(layerName, layerBundle);
			++_layerCount;
		}
		return layerBundle.requestAccess(accessType);
	}
	public function returnLayerAccess < AccessType : IAccessType > (layerName:String, access:AccessType):Void {
		var layerBundle = layers.get(layerName);
		layerBundle.returnAccess(access);
		if (layerBundle.isEmpty()) {
			_destroyLayerInfo(layerBundle.layerInfo);
			layers.remove(layerName);
			layerBundle.cleanup();
			layerBundle.accessToCreate = null;
			layerBundle.accessToDestroy = null;
			--_layerCount;
		}
	}
	override public function isEmpty():Bool {
		return super.isEmpty() && _layerCount==0 && _dependencyCount==0;
	}
	public function cleanup():Void {
		contInfo = null;
		_info = null;
		//context = null;
	}
}
class LayerBundle<ContInfoType, LayerInfoType> extends AbsBundle<LayerInfoType>{
	//public var contBundle:ContBundle;
	public var layerInfo(default, null):LayerInfoType;
	
	public var name:String;
	
	public function new(layerInfo:LayerInfoType) 
	{
		super();
		
		this.layerInfo = layerInfo;
		_info = layerInfo;
	}
	public function cleanup():Void {
		layerInfo = null;
		_info = null;
		name = null;
	}
}
class AbsBundle<InfoType> {
	
	private var _totalCount:Int = 0;
	private var _accessToCount:ObjectHash< Dynamic, Int>;
	private var _createToAccess:ObjectHash < InfoType -> IAccessType, IAccessType > ;
	private var _accessToType:ObjectHash < IAccessType, Class<IAccessType> > ;
	
	public var accessToCreate:ObjectHash<Dynamic, InfoType -> IAccessType>;
	public var accessToDestroy:ObjectHash < Dynamic, InfoType -> IAccessType-> Void > ;
	
	private var _info:InfoType;
	
	public function new() 
	{
		_accessToType = new ObjectHash();
		_accessToCount = new ObjectHash();
		_createToAccess = new ObjectHash();
	}
	
	public function getAccess < AccessType : IAccessType > (accessType:Class<AccessType>):AccessType {
		var accessFact = accessToCreate.get(accessType);
		return cast _createToAccess.get(accessFact);
	}
	public function requestAccess < AccessType : IAccessType > (accessType:Class<AccessType>):AccessType {
		++_totalCount;
		var accessFact = accessToCreate.get(accessType);
		
		if (_createToAccess.exists(accessFact)) {
			var access = _createToAccess.get(accessFact);
			_accessToCount.set(access, _accessToCount.get(access) + 1);
			return cast access;
		}
		
		var access = accessFact(_info);
		_createToAccess.set(accessFact, access);
		_accessToType.set(access, cast accessType);
		_accessToCount.set(access, 1);
		return cast access;
	}
	public function returnAccess < AccessType : IAccessType > (access:AccessType):Void {
		--_totalCount;
		
		var count = _accessToCount.get(access);
		_accessToCount.set(access, count - 1);
		if (count == 1) {
			var accessType = _accessToType.get(access);
			accessToDestroy.get(accessType)(_info, access);
			_createToAccess.delete(accessToCreate.get(accessType));
			_accessToType.delete(access);
		}
	}
	public function isEmpty():Bool {
		return _totalCount == 0;
	}
}

import cmtc.ds.hash.ObjectHash;

class FurnisherBundle < ContInfoType, LayerInfoType, TagType > {
	
	public function getInjector():Injector {
		return _injector;
	}
	
	private var _injector:Injector;
	private var _tagType:Dynamic;
	private var _onCreate:ContInfoType->TagType-> Array<Dynamic>;
	private var _onDestroy:Null<ContInfoType->TagType-> Array<Dynamic>->Void>;
	private var _getContBundle:ComposeItem->ContBundle<ContInfoType,LayerInfoType>;
	private var _assessBundle:ContBundle<ContInfoType,LayerInfoType>->ComposeItem-> Void;
	private var _tagToTraits:ObjectHash<TagType, Array<Dynamic>>;
	
	public function new(tagType:Dynamic, onCreate:ContInfoType->TagType-> Array<Dynamic>, onDestroy:Null<ContInfoType->TagType-> Array<Dynamic>->Void>, getContBundle:ComposeItem->ContBundle<ContInfoType,LayerInfoType>, assessBundle:ContBundle<ContInfoType,LayerInfoType>->ComposeItem->Void) {
		_tagType = tagType;
		_onCreate = onCreate;
		_onDestroy = onDestroy;
		_getContBundle = getContBundle;
		_assessBundle = assessBundle;
		
		_tagToTraits = new ObjectHash();
		
		_injector = new Injector(tagType, onAdd, onRemove, true, true);
		_injector.passThroughItem = true;
	}
	private function onAdd(tag:TagType, context:ComposeItem):Void {
		var contBundle = _getContBundle(context);
		contBundle.addDependency();
		var traits:Array<Dynamic> = _onCreate(contBundle.contInfo, tag);
		if (traits != null) {
			context.addTraits(traits);
			_tagToTraits.set(tag, traits);
		}
	}
	private function onRemove(tag:TagType, context:ComposeItem):Void {
		var contBundle = _getContBundle(context);
		contBundle.removeDependency();
		var traits:Array<Dynamic> = _tagToTraits.get(tag);
		if (traits != null) {
			context.removeTraits(traits);
			_tagToTraits.delete(tag);
		}
		if (_onDestroy != null) {
			_onDestroy(contBundle.contInfo, tag, traits);
		}
		_assessBundle(contBundle, context);
	}
}