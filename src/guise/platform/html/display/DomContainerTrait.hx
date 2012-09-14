package guise.platform.html.display;
import composure.injectors.Injector;
import js.Dom;
import composure.traitCheckers.TraitTypeChecker;

/**
 * ...
 * @author Tom Byrne
 */

class DomContainerTrait extends DomElementSkin
{

	public function new(?domElement:HtmlDom) {
		super(domElement);
		
		var injector = new Injector(DomContainerTrait, onChildAdded, onChildRemoved, false, true);
		injector.stopDescendingAt = TraitTypeChecker.create(DomContainerTrait);
		addInjector(injector);
	}
	
	
	private function onChildAdded(child:DomContainerTrait):Void {
		if(child.domElement.parentNode==null){
			domElement.appendChild(child.domElement);
		}
	}
	private function onChildRemoved(child:DomContainerTrait):Void {
		if(child.domElement.parentNode==domElement){
			domElement.appendChild(child.domElement);
		}
	}
}