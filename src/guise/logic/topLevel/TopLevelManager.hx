package guise.logic.topLevel;
import composure.core.ComposeGroup;
import composure.core.ComposeItem;
import composure.traits.AbstractTrait;
import guise.core.CoreTags;
import guise.core.IWindowInfo;
import guise.layout.IBoxPos;
import cmtc.ds.hash.ObjectHash;
import msignal.Signal;


class TopLevelManager extends AbstractTrait
{
	@inject({asc:true})
	@:isVar public var windowInfo(default, set_windowInfo):IWindowInfo;
	public function set_windowInfo(value:IWindowInfo):IWindowInfo {
		if (windowInfo != null) {
			windowInfo.availSizeChanged.remove(onAvailSizeChanged);
		}
		this.windowInfo = value;
		if (windowInfo != null) {
			windowInfo.availSizeChanged.add(onAvailSizeChanged);
			onAvailSizeChanged(windowInfo);
		}
		return value;
	}

	private var padding:Float;
	private var container:ComposeGroup;
	private var displays:Array<TopLevelDisplay>;
	private var dispToBundle:ObjectHash<TopLevelDisplay, ItemBundle>;
	private var areaToBundle:ObjectHash<TargetArea, ItemBundle>;
	private var boxToBundle:ObjectHash<IBoxPos, ItemBundle>;
	private var anscToBoxPos:ObjectHash<IBoxPos, Array<IBoxPos>>;
	
	public function new(padding:Float=0) 
	{
		super();
		this.padding = padding;
		dispToBundle = new ObjectHash<TopLevelDisplay, ItemBundle>();
		boxToBundle = new ObjectHash<IBoxPos, ItemBundle>();
		areaToBundle = new ObjectHash<TargetArea, ItemBundle>();
		anscToBoxPos = new ObjectHash < IBoxPos, Array<IBoxPos> > ();
		displays = [];
		container = new ComposeGroup([TopLevelTag]);
		addChildItem(container);
	}
	
	
	@injectAdd({desc:true})
	private function addTopLevelDisplay(disp:TopLevelDisplay, item:ComposeItem):Void {
		displays.push(disp);
		container.addChild(disp.item);
		if(disp.fitInWindow){
			var boxPos:IBoxPos = disp.item.getTrait(IBoxPos);
			if (boxPos != null) {
				disp.item.removeTrait(boxPos);
				boxPos.changed.add(onBoxPosChanged);
				
				var proxy:BoxPos = new BoxPos();
				disp.item.addTrait(proxy);
				
				var boxes:Array<IBoxPos> = getBoxes(item);
				
				var targetArea:TargetArea = item.getTrait(TargetArea);
				var proxyArea:TargetArea = null;
				if (targetArea != null) {
					targetArea.posChanged.add(onAreaPosChanged);
					targetArea.sizeChanged.add(onAreaSizeChanged);
					proxyArea = new TargetArea(targetArea.x, targetArea.y, targetArea.w, targetArea.h);
					disp.item.removeTrait(targetArea);
					disp.item.addTrait(proxyArea);
				}
				
				var bundle:ItemBundle = { trait:disp, boxPos:boxPos, proxy:proxy, parentPositions:boxes, targArea:targetArea, proxyArea:proxyArea};
				dispToBundle.set(disp, bundle);
				boxToBundle.set(boxPos, bundle);
				if (targetArea != null) {
					areaToBundle.set(targetArea, bundle);
					onAreaSizeChanged(targetArea);
				}
				
				for (anscBox in boxes) {
					var backRef = anscToBoxPos.get(anscBox);
					if (backRef == null) {
						backRef = [];
						anscToBoxPos.set(anscBox, backRef);
						anscBox.posChanged.add(onAnscChanged);
					}
					backRef.push(boxPos);
				}
				
				validateBundle(bundle);
			}
		}
	}
	
	@injectRemove({desc:true})
	private function removeTopLevelDisplay(disp:TopLevelDisplay, item:ComposeItem):Void {
		if(displays.remove(disp)){
			container.addChild(disp.item);
			var bundle:ItemBundle = dispToBundle.get(disp);
			if (bundle != null) {
				dispToBundle.delete(disp);
				boxToBundle.delete(bundle.boxPos);
				
				disp.item.removeTrait(bundle.proxy);
				
				bundle.boxPos.changed.remove(onBoxPosChanged);
				disp.item.addTrait(bundle.boxPos);
				
				var boxes:Array<IBoxPos> = bundle.parentPositions;
				for (anscBox in boxes) {
					
					var backRef = anscToBoxPos.get(anscBox);
					backRef.remove(bundle.boxPos);
					if (backRef.length == 0) {
						anscBox.posChanged.remove(onAnscChanged);
						anscToBoxPos.delete(anscBox);
					}
				}
				
				if (bundle.targArea != null) {
					bundle.targArea.posChanged.remove(onAreaPosChanged);
					bundle.targArea.sizeChanged.remove(onAreaSizeChanged);
					disp.item.removeTrait(bundle.proxyArea);
					disp.item.addTrait(bundle.targArea);
					areaToBundle.remove(bundle.targArea);
				}
			}
		}
	}
	
	private function onAreaPosChanged(from:TargetArea):Void {
		var bundle:ItemBundle = areaToBundle.get(from);
		validateBundle(bundle);
	}
	private function onAreaSizeChanged(from:TargetArea):Void {
		var bundle:ItemBundle = areaToBundle.get(from);
		bundle.proxyArea.setSize(from.w, from.h);
	}
	
	private function onAvailSizeChanged(from:IWindowInfo):Void {
		for (boxPos in boxToBundle) {
			onBoxPosChanged(boxPos);
		}
	}
	private function onAnscChanged(anscBox:IBoxPos):Void {
		var backRef = anscToBoxPos.get(anscBox);
		for (boxPos in backRef) {
			onBoxPosChanged(boxPos);
		}
	}
	private function onBoxPosChanged(boxPos:IBoxPos):Void {
		validateBundle(boxToBundle.get(boxPos));
	}
	private function validateBundle(bundle:ItemBundle):Void {
		if (windowInfo == null) return;
		
		var boxPos = bundle.boxPos;
		var proxy = bundle.proxy;
		var parents  = bundle.parentPositions;
		
		var x:Float = boxPos.x;
		var y:Float = boxPos.y;
		var w:Float = boxPos.w;
		var h:Float = boxPos.h;
		
		for (parent in parents) {
			x += parent.x;
			y += parent.y;
		}
		
		if (w > windowInfo.availWidth-padding*2) {
			w = windowInfo.availWidth-padding*2;
		}
		if (h > windowInfo.availHeight-padding*2) {
			h = windowInfo.availHeight-padding*2;
		}
		if (x > windowInfo.availWidth - w - padding){
			x = windowInfo.availWidth - w - padding;
		}else if (x < padding) {
			x = padding;
		}
		if (y > windowInfo.availHeight - h - padding){
			y = windowInfo.availHeight - h - padding;
		}else if (y < padding) {
			y = padding;
		}
		
		if (bundle.proxyArea != null) {
			var targArea = bundle.targArea;
			bundle.proxyArea.setPos(targArea.x + x, targArea.y + y);
			trace("targ: "+bundle.proxyArea.x+" "+bundle.proxyArea.y+" "+bundle.proxyArea.w+" "+bundle.proxyArea.h);
		}
		
		proxy.set(x, y, w, h);
	}
	
	private function getBoxes(item:ComposeItem):Array<IBoxPos> {
		var ret:Array<IBoxPos> = [];
		while (item!=null && item!=this.item) {
			var boxPos:IBoxPos = item.getTrait(IBoxPos);
			if (boxPos != null) {
				ret.push(boxPos);
			}
			item = item.parentItem;
		}
		return ret;
	}
}
typedef Point = { x:Float, y:Float };

typedef ItemBundle = {
	var trait:TopLevelDisplay;
	var boxPos:IBoxPos;
	var proxy:BoxPos;
	var parentPositions:Array<IBoxPos>;
	
	var targArea:TargetArea;
	var proxyArea:TargetArea;
}