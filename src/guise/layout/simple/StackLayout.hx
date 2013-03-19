package guise.layout.simple;
import composure.core.ComposeItem;
import composure.injectors.Injector;
import composure.traitCheckers.GenerationChecker;
import guise.layout.AbsLayout;
import guise.layout.IBoxPos;
import guise.meas.IMeasurement;
import cmtc.ds.hash.ObjectHash;

using Lambda;

class StackLayout extends AbsLayout
{
	@:isVar private var direction(default, set_direction):StackDirection;
	private function set_direction(value:StackDirection):StackDirection {
		this.direction = value;
		if (direction == StackDirection.HORIZONTAL) {
			getBreadth = getHeight;
			getLength = getWidth;
			getMeasBreadth = getMeasHeight;
			getMeasLength = getMeasWidth;
			setChildPos = setChildPosHor;
			doSetMeas = setMeasHor;
			getBreadthFore = get_topGap;
			getBreadthAft = get_bottomGap;
			getLengthFore = get_leftGap;
			getLengthAft = get_rightGap;
			getBreadthPolicy = get_defaultHeightPolicy;
			getLengthPolicy = get_defaultWidthPolicy;
			getItemBreadthPolicy = getHeightPolicy;
			getItemLengthPolicy = getWidthPolicy;
		}else {
			getBreadth = getWidth;
			getLength = getHeight;
			getMeasBreadth = getMeasWidth;
			getMeasLength = getMeasHeight;
			setChildPos = setChildPosVer;
			doSetMeas = setMeasVer;
			getBreadthFore = get_leftGap;
			getBreadthAft = get_rightGap;
			getLengthFore = get_topGap;
			getLengthAft = get_bottomGap;
			getBreadthPolicy = get_defaultWidthPolicy;
			getLengthPolicy = get_defaultHeightPolicy;
			getItemBreadthPolicy = getWidthPolicy;
			getItemLengthPolicy = getHeightPolicy;
		}
		invalidate(doPositioning);
		return value;
	}
	
	@:isVar public var topGap(get_topGap, set_topGap):Float;
	private function get_topGap():Float {
		return this.topGap;
	}
	private function set_topGap(value:Float):Float {
		this.topGap = value;
		invalidate(doPositioning);
		return value;
	}
	
	@:isVar public var bottomGap(get_bottomGap, set_bottomGap):Float;
	private function get_bottomGap():Float {
		return this.bottomGap;
	}
	private function set_bottomGap(value:Float):Float {
		this.bottomGap = value;
		invalidate(doPositioning);
		return value;
	}
	
	@:isVar public var leftGap(get_leftGap, set_leftGap):Float;
	private function get_leftGap():Float {
		return this.leftGap;
	}
	private function set_leftGap(value:Float):Float {
		this.leftGap = value;
		invalidate(doPositioning);
		return value;
	}
	
	@:isVar public var rightGap(get_rightGap, set_rightGap):Float;
	private function get_rightGap():Float {
		return this.rightGap;
	}
	private function set_rightGap(value:Float):Float {
		this.rightGap = value;
		invalidate(doPositioning);
		return value;
	}
	
	@:isVar public var itemGap(default, set_itemGap):Float;
	private function set_itemGap(value:Float):Float {
		this.itemGap = value;
		invalidate(doPositioning);
		return value;
	}
	
	@:isVar public var defaultWidthPolicy(get_defaultWidthPolicy, set_defaultWidthPolicy):StackSizePolicy;
	private function get_defaultWidthPolicy():StackSizePolicy {
		return this.defaultWidthPolicy;
	}
	private function set_defaultWidthPolicy(value:StackSizePolicy):StackSizePolicy {
		this.defaultWidthPolicy = value;
		invalidate(doPositioning);
		return value;
	}
	
	@:isVar public var defaultHeightPolicy(get_defaultHeightPolicy, set_defaultHeightPolicy):StackSizePolicy;
	private function get_defaultHeightPolicy():StackSizePolicy {
		return this.defaultHeightPolicy;
	}
	private function set_defaultHeightPolicy(value:StackSizePolicy):StackSizePolicy {
		this.defaultHeightPolicy = value;
		invalidate(doPositioning);
		return value;
	}
	
	@:isVar public var defaultAlign(default, set_defaultAlign):StackAlign;
	private function set_defaultAlign(value:StackAlign):StackAlign {
		this.defaultAlign = value;
		invalidate(doPositioning);
		return value;
	}
	
	private var _childToBundle:ObjectHash<StackLayoutInfo, ChildBundle>;
	private var _stack:Array<ChildBundle>;
	
	private var getBreadth:Void->Float;
	private var getLength:Void->Float;
	private var getBreadthFore:Void->Float;
	private var getBreadthAft:Void->Float;
	private var getLengthFore:Void->Float;
	private var getLengthAft:Void->Float;
	private var getMeasBreadth:IMeasurement->Float;
	private var getMeasLength:IMeasurement->Float;
	private var setChildPos:BoxPos->Float->Float->Float->Float->Void;
	private var doSetMeas:Float->Float->Void;
	private var getBreadthPolicy:Void->StackSizePolicy;
	private var getLengthPolicy:Void->StackSizePolicy;
	private var getItemBreadthPolicy:StackLayoutInfo->StackSizePolicy;
	private var getItemLengthPolicy:StackLayoutInfo->StackSizePolicy;

	public function new(direction:StackDirection) 
	{
		super();
		_childToBundle = new ObjectHash();
		_stack = [];
		
		addFrameCall(doArrangeStack);
		addFrameCall(doPositioning, [doArrangeStack]);
		
		this.topGap = 0;
		this.bottomGap = 0;
		this.leftGap = 0;
		this.rightGap = 0;
		this.itemGap = 0;
		this.direction = direction;
		
		defaultWidthPolicy = Meas(true);
		defaultHeightPolicy = Meas(true);
		defaultAlign = Center;
		
		var injector:Injector = new Injector(StackLayoutInfo, addChild, removeChild, false, true);
		injector.stopDescendingAt = GenerationChecker.create(1);
		injector.passThroughItem = true;
		addInjector(injector);
	}
	override private function onSizeChanged(from:IBoxPos):Void {
		invalidate(doPositioning);
	}
	private function onChildMeasChanged(from:IMeasurement):Void {
		invalidate(doPositioning);
	}
	
	private function addChild(child:StackLayoutInfo, item:ComposeItem):Void {
		var boxPos = new BoxPos();
		var bundle = { layoutInfo:child, boxPos:boxPos, item:item, meas:null };
		item.addTrait(boxPos);
		_childToBundle.set(child, bundle);
		if (child.idealIndex != -1) {
			invalidate(doArrangeStack);
		}else {
			_stack.push(bundle);
			invalidate(doPositioning);
		}
	}
	private function removeChild(child:StackLayoutInfo, item:ComposeItem):Void {
		var bundle = _childToBundle.get(child);
		_childToBundle.delete(child);
		item.removeTrait(bundle.boxPos);
		
		if (bundle.meas!=null) {
			bundle.meas.measChanged.add(onChildMeasChanged);
		}
		
		if (_stack.remove(bundle)) {
			invalidate(doPositioning);
		}	
	}
	
	
	private function doArrangeStack():Bool {
		_stack = [];
		var specific:Array<ChildBundle> = [];
		for (layoutInfo in _childToBundle.keys()) {
			var bundle = _childToBundle.get(layoutInfo);
			var idealIndex:Int = layoutInfo.idealIndex;
			if (idealIndex != -1) {
				specific.push(bundle);
			}else{
				_stack.push(bundle);
			}
		}
		specific.sort(sortBundles);
		for (bundle in specific) {
			_stack.insert(bundle.layoutInfo.idealIndex, bundle);
		}
		
		return true;
	}
	private function sortBundles(bundle1:ChildBundle, bundle2:ChildBundle):Int {
		if (bundle1.layoutInfo.idealIndex < bundle2.layoutInfo.idealIndex) {
			return -1;
		}else if (bundle1.layoutInfo.idealIndex > bundle2.layoutInfo.idealIndex) {
			return 1;
		}else {
			return 0;
		}
	}
	private function doPositioning():Bool {
		if (boxPos == null || defaultWidthPolicy==null || defaultHeightPolicy==null) return false;
		
		var breadthAft:Float = getBreadthAft();
		var breadthFore:Float = getBreadthFore();
		var lengthFore:Float = getLengthFore();
		var lengthAft:Float = getLengthAft();
		
		var measBreadth:Float = 0;
		var measLength:Float = lengthFore;
		
		var breadth:Float = getBreadth()-breadthAft-breadthFore;
		var length:Float = getLength() - lengthAft - lengthFore;
		
		var policyB = getBreadthPolicy();
		var policyL = getLengthPolicy();
		for (bundle in _stack) {
			var meas:IMeasurement = cast bundle.item.getTrait(IMeasurement);
			if (meas != bundle.meas) {
				if (bundle.meas!=null) {
					bundle.meas.measChanged.remove(onChildMeasChanged);
				}
				bundle.meas = meas;
				if (bundle.meas!=null) {
					bundle.meas.measChanged.add(onChildMeasChanged);
				}
			}
			
			var boxPos = bundle.boxPos;
			
			var itemMeasB:Float;
			var itemMeasL:Float;
			if (meas != null) {
				itemMeasB = getMeasBreadth(meas);
				itemMeasL = getMeasLength(meas);
			}else {
				itemMeasB = Math.NaN;
				itemMeasL = Math.NaN;
			}
			var layoutInfo = bundle.layoutInfo;
			
			var itemPolB = getItemBreadthPolicy(layoutInfo);
			var itemPolL = getItemLengthPolicy(layoutInfo);
			
			var sizeBreadth = getSize(breadth, itemPolB, policyB, itemMeasB);
			var sizeLength = getSize(length, itemPolL, policyL, itemMeasL);
			
			itemMeasB = getMeas(itemPolB, policyB, sizeBreadth, itemMeasB);
			itemMeasL = getMeas(itemPolL, policyL, sizeLength, itemMeasL);
			
			var align:StackAlign = (layoutInfo.align != null?layoutInfo.align:defaultAlign);
			var pos:Float;
			switch(align) {
				case Left:
					pos = breadthFore;
				case Center:
					pos = breadthFore + (breadth-sizeBreadth) / 2;
				case Right:
					pos = breadthFore + breadth - sizeBreadth;
			}
			
			setChildPos(boxPos, pos, measLength, sizeBreadth, sizeLength);
			
			if (!Math.isNaN(itemMeasB) && measBreadth < itemMeasB) {
				measBreadth = itemMeasB;
			}
			measLength += itemGap;
			if(!Math.isNaN(itemMeasL))measLength += itemMeasL;
		}
		measBreadth += breadthFore + breadthAft;
		measLength += lengthAft - itemGap;
		doSetMeas(measBreadth, measLength);
		
		return true;
	}
	private function getSize(dim:Float, itemPolicy:StackSizePolicy, defPolicy:StackSizePolicy, meas:Float):Float {
		if (itemPolicy == null) {
			itemPolicy = defPolicy;
		}
		switch(itemPolicy) {
			case Meas(capAtFill):
				if (Math.isNaN(meas) || (capAtFill && meas > dim)) {
					return dim;
				}else {
					return meas;
				}
			case Fill: return dim;
			case Size(val): return val;
		}
	}
	private function getMeas(itemPolicy:StackSizePolicy, defPolicy:StackSizePolicy, size:Float, meas:Float):Float {
		if (itemPolicy == null) {
			itemPolicy = defPolicy;
		}
		switch(itemPolicy) {
			case Meas(capAtFill): return meas;
			case Fill: return 0;
			case Size(val): return size;
		}
	}
	
	private function getWidth():Float {
		return boxPos.w;
	}
	private function getHeight():Float {
		return boxPos.h;
	}
	private function getMeasWidth(meas:IMeasurement):Float {
		return meas.measWidth;
	}
	private function getMeasHeight(meas:IMeasurement):Float {
		return meas.measHeight;
	}
	private function setChildPosHor(pos:BoxPos, breadthCoord:Float, lengthCoord:Float, breadthDim:Float, lengthDim:Float):Void{
		pos.set(lengthCoord, breadthCoord, lengthDim, breadthDim);
	}
	private function setChildPosVer(pos:BoxPos, breadthCoord:Float, lengthCoord:Float, breadthDim:Float, lengthDim:Float):Void{
		pos.set(breadthCoord, lengthCoord, breadthDim, lengthDim);
	}
	private function setMeasHor(breadthMeas:Float, lengthMeas:Float):Void {
		setMeas(lengthMeas, breadthMeas);
	}
	private function setMeasVer(breadthMeas:Float, lengthMeas:Float):Void {
		setMeas(breadthMeas, lengthMeas);
	}
	private function getWidthPolicy(layoutInfo:StackLayoutInfo):StackSizePolicy {
		return layoutInfo.widthPolicy;
	}
	private function getHeightPolicy(layoutInfo:StackLayoutInfo):StackSizePolicy {
		return layoutInfo.heightPolicy;
	}
}

private typedef ChildBundle = {
	var layoutInfo:StackLayoutInfo;
	var boxPos:BoxPos;
	var item:ComposeItem;
	var meas:IMeasurement;
}

class StackLayoutInfo {
	public var idealIndex:Int;
	public var widthPolicy:Null<StackSizePolicy>;
	public var heightPolicy:Null<StackSizePolicy>;
	public var align:Null<StackAlign>;
	
	public function new(idealIndex:Int = -1, ?widthPolicy:StackSizePolicy, ?heightPolicy:StackSizePolicy, ?align:StackAlign) {
		this.idealIndex = idealIndex;
		this.widthPolicy = widthPolicy;
		this.heightPolicy = heightPolicy;
		this.align = align;
	}
}

enum StackAlign {
	Left;
	Center;
	Right;
}
enum StackSizePolicy {
	Fill;
	Meas(capAtFill:Bool);
	Size(val:Float);
}

enum StackDirection {
	HORIZONTAL;
	VERTICAL;
}