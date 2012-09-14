package guise.platform;
import composure.injectors.Injector;
import composure.traits.AbstractTrait;
import guise.platform.IPlatformAccess;

/**
 * ...
 * @author Tom Byrne
 */

class PlatformAccessor<AccessType : IAccessType> extends AbstractTrait
{
	
	@inject({asc:true})
	public var platformAccess(default, set_platformAccess):IPlatformAccess;
	private function set_platformAccess(value:IPlatformAccess):IPlatformAccess {
		if(_injected==null)returnAccess();
		this.platformAccess = value;
		if(_injected==null)requestAccess();
		return value;
	}
	
	public var layerName(default, set_layerName):String;
	private function set_layerName(value:String):String {
		if(_injected==null)returnAccess();
		this.layerName = value;
		if(_injected==null)requestAccess();
		return value;
	}

	private var _accessTaken:Bool;
	private var _access:AccessType;
	private var _injected:AccessType;
	private var _accessType:Class<AccessType>;
	
	public function new(accessType:Class<AccessType>, ?layerName:String, ?onAccessAdd:AccessType-> Void, ?onAccessRemove:AccessType-> Void, inject:Bool=false) {
		super();
		_accessType = accessType;
		
		this.layerName = layerName;
		
		if (onAccessAdd != null) this.onAccessAdd = onAccessAdd;
		if (onAccessRemove != null) this.onAccessRemove = onAccessRemove;
		
		if (inject) {
			addInjector(new Injector(accessType, onInjectAdd, onInjectRemove));
		}
	}
	override private function onItemAdd():Void {
		super.onItemAdd();
		
		if (_injected == null) requestAccess();
		else onAccessAdd(_injected);
	}
	override private function onItemRemove():Void {
		if (_injected == null) returnAccess();
		else onAccessRemove(_injected);
		
		super.onItemRemove();
	}
	private function onInjectAdd(access:AccessType):Void {
		super.onItemAdd();
		returnAccess();
		_injected = access;
		onAccessAdd(_injected);
	}
	private function onInjectRemove(access:AccessType):Void {
		onAccessRemove(_injected);
		_injected = null;
		requestAccess();
		super.onItemRemove();
	}
	private function requestAccess():Void {
		if (platformAccess != null && item!=null) {
			_accessTaken = true;
			
			_access = platformAccess.requestAccess(item, _accessType, layerName);
			onAccessAdd(_access);
		}
	}
	private function returnAccess():Void {
		if (_accessTaken) {
			_accessTaken = false;
			onAccessRemove(_access);
			platformAccess.returnAccess(_access);
		}
	}
	
	private dynamic function onAccessAdd(access:AccessType):Void {
		// override me 
	}
	private dynamic function onAccessRemove(access:AccessType):Void {
		// override me 
	}
}