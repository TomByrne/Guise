package guise.skin.drawn;
import guise.platform.cross.IAccessRequest;
import guise.skin.drawn.utils.DrawnStyles;
import guise.skin.drawn.utils.DrawnStyleUtils;
import guise.accessTypes.IGraphicsAccess;
import guise.platform.GeomApi;
import guise.skin.drawn.utils.GeomUtils;
import guise.values.IValue;
import guise.accessTypes.IPositionAccess;
import guise.skin.common.PositionedLayer;
import guise.platform.GraphicsApi;

class BoxLayer extends PositionedLayer<BoxStyle>, implements IAccessRequest
{
	private static var ACCESS_TYPES:Array<Class<Dynamic>> = [IGraphicsAccess, IPositionAccess];
	private static var NINETY_DEGREES:Float = Math.PI/2;
	
	
	@injectAdd
	private function onGraphicsAdd(access:IGraphicsAccess):Void {
		if (layerName != null && access.layerName != layerName) return;
		
		_graphicsAccess = access;
		if (_graphicsAccess != null) {
			_graphicsAccess.idealDepth = idealDepth;
		}
		invalidate();
	}
	@injectRemove
	private function onGraphicsRemove(access:IGraphicsAccess):Void {
		if (access != _graphicsAccess) return;
		
		_graphicsAccess = null;
	}
	
	@injectAdd
	private function onPosAdd(access:IPositionAccess):Void {
		if (layerName != null && access.layerName != layerName) return;
		
		_pos = access;
		invalidate();
	}
	@injectRemove
	private function onPosRemove(access:IPositionAccess):Void {
		if (access != _pos) return;
		
		_pos = null;
	}
	
	@:isVar public var idealDepth(default, set_idealDepth):Int;
	private function set_idealDepth(value:Int):Int {
		this.idealDepth = value;
		if (_graphicsAccess != null) {
			_graphicsAccess.idealDepth = idealDepth;
		}
		return value;
	}
	
	private var _graphicsAccess:IGraphicsAccess;
	private var _pos:IPositionAccess;

	public function new(?layerName:String, ?normalStyle:BoxStyle) 
	{
		super(layerName, normalStyle);
	}
	public function getAccessTypes():Array<Class<Dynamic>> {
		return ACCESS_TYPES;
	}
	override private function _isReadyToDraw():Bool {
		return _graphicsAccess != null && super._isReadyToDraw();
	}
	override private function _clearStyle():Void {
		_graphicsAccess.clear();
	}
	override private function _drawStyle():Void {
		_graphicsAccess.clear();
		
		removeValuesByHandler(onShapeChanged);
		
		var style:BoxStyle = currentStyle;
		var fill:FillStyle;
		var stroke:StrokeStyle;
		var tl:CornerStyle;
		var tr:CornerStyle;
		var bl:CornerStyle;
		var br:CornerStyle;
		
		var edges:Edges = null;
		
		switch(style) {
			case BsRectComplex(f, s, c, e):
				
				fill = f;
				stroke = s;
				edges = e;
				switch(c) {
					case CSame(cs):
						tl = cs;
						tr = cs;
						bl = cs;
						br = cs;
					case CDiff(c1, c2, c3, c4):
						tl = c1;
						tr = c2;
						br = c3;
						bl = c4;
						
				}
			case BsCapsule(f, s):
				
				fill = f;
				stroke = s;
				if (CAPSULE_CORNER == null) {
					CAPSULE_CORNER = CsCirc(Math.POSITIVE_INFINITY);
				}
				tl = CAPSULE_CORNER;
				tr = CAPSULE_CORNER;
				bl = CAPSULE_CORNER;
				br = CAPSULE_CORNER;
			case BsRect(f, s, e):
				
				fill = f;
				stroke = s;
				edges = e;
				if (SQUARE_CORNER == null) {
					SQUARE_CORNER = CsSquare;
				}
				tl = SQUARE_CORNER;
				tr = SQUARE_CORNER;
				bl = SQUARE_CORNER;
				br = SQUARE_CORNER;
		}
		
		var tlSize:Float = getCornerSize(tl);
		var trSize:Float = getCornerSize(tr);
		var blSize:Float = getCornerSize(bl);
		var brSize:Float = getCornerSize(br);
		
		var topCom:GraphArray<Int> = null;
		var topDat:GraphArray<Float> = null;
		var rightCom:GraphArray<Int> = null;
		var rightDat:GraphArray<Float> = null;
		var bottomCom:GraphArray<Int> = null;
		var bottomDat:GraphArray<Float> = null;
		var leftCom:GraphArray<Int> = null;
		var leftDat:GraphArray<Float> = null;
		
		if (edges != null) {
			switch(edges) {
				case EArrow(atX, atY, arrowLength, arrowWidth, baseRadius, pointRadius, angleArrow):
					var xNum = getValue(atX, 0, onShapeChanged, false);
					var yNum = getValue(atY, 0, onShapeChanged, false);
					var lNum = getValue(arrowLength, 0, onShapeChanged, false);
					var wNum = getValue(arrowWidth, 0, onShapeChanged, false);
					var basRad = getValue(baseRadius, 0, onShapeChanged, false);
					var pntRad = getValue(pointRadius, 0, onShapeChanged, false);
					var hW = wNum / 2;
					var lines:Array<Line> = [ { start: { x:x + tlSize + hW, y:y }, end: { x:x + w - trSize-hW, y:y }},
											  { start: { x:x + w, y:y + trSize + hW }, end: { x:x + w, y:y + h - brSize-hW }},
											  { start: { x:x + w - brSize-hW, y:y + h }, end: { x:x + blSize + hW, y:y + h }},
											  { start: { x:x, y:y + h - blSize-hW }, end: { x:x, y:y + tlSize + hW }} ];
					
					var line = GeomUtils.closestLineToPoint(xNum, yNum, lines);
					var lineAngle = GeomUtils.getAngle2Points(line.start.x, line.start.y, line.end.x, line.end.y);
					var basePoint = GeomUtils.closestPoint2Line(line.start.x, line.start.y, line.end.x, line.end.y, xNum, yNum);
					var endPoint:Point;
					var arrowAngle:Float;
					if (angleArrow) {
						arrowAngle = GeomUtils.getAngle2Points(basePoint.x, basePoint.y, xNum, yNum);
						var dist = GeomUtils.dist(basePoint.x, basePoint.y, xNum, yNum);
						if (lNum > dist) lNum = dist;
					}else{
						arrowAngle = lineAngle-NINETY_DEGREES;
						if (arrowAngle%Math.PI == 0) {
							var dist = Math.abs(basePoint.x - xNum);
							if (lNum > dist) lNum = dist;
						}else {
							var dist = Math.abs(basePoint.y - yNum);
							if (lNum > dist) lNum = dist;
						}
					}
					
					var com:GraphArray<Int>;
					var dat:GraphArray<Float>;
					switch(Lambda.indexOf(lines, line)) {
						case 0:
							com = topCom = new GraphArray<Int>();
							dat = topDat = new GraphArray<Float>();
						case 1:
							com = rightCom = new GraphArray<Int>();
							dat = rightDat = new GraphArray<Float>();
						case 2:
							com = bottomCom = new GraphArray<Int>();
							dat = bottomDat = new GraphArray<Float>();
						case 3:
							com = leftCom = new GraphArray<Int>();
							dat = leftDat = new GraphArray<Float>();
						default:
							com = null;
							dat = null;
					}
					var point = GeomUtils.projectPoint(lNum, arrowAngle, basePoint.x, basePoint.y); // this is the tip of the arrow
					var baseFore = GeomUtils.projectPoint(hW, lineAngle+Math.PI, basePoint.x, basePoint.y);
					var baseAft = GeomUtils.projectPoint(hW, lineAngle, basePoint.x, basePoint.y);
					var sideDist = GeomUtils.dist(baseFore.x, baseFore.y, point.x, point.y);
					if (basRad > 0) {
						var baseAngle = GeomUtils.getAngle2Points(baseFore.x, baseFore.y, point.x, point.y);
						if (basRad > sideDist / 2) basRad = sideDist / 2;
						var hCurve = Math.asin(lNum / sideDist);
						var baseLead = basRad * Math.tan(180 - hCurve);
						var turn = (180 - hCurve) * 2; // amount of circular turn in base corner
						
						var innerCorner = GeomUtils.projectPoint(baseLead, lineAngle-Math.PI, baseFore.x, baseFore.y);
						// e.g.
						//drawRoundedCorner(graph,  baseFore.x, baseFore.y, innerCorner.x, innerCorner.y, point.x, point.y, basRad)
					}else {
						com.push(GraphicsPathCommand.LINE_TO);
						dat.push(baseFore.x);
						dat.push(baseFore.y);
					}
					if (pntRad > 0) {
						
					}else {
						com.push(GraphicsPathCommand.LINE_TO);
						dat.push(point.x);
						dat.push(point.y);
					}
					if (basRad > 0) {
						
					}else {
						com.push(GraphicsPathCommand.LINE_TO);
						dat.push(baseAft.x);
						dat.push(baseAft.y);
					}
			}
		}
		
		var centerX:Float = x + w / 2;
		var centerY:Float = y + h / 2;
		
		var path:GraphicsPath = new GraphicsPath();
		path.commands = new GraphArray<Int>();
		path.data = new GraphArray<Float>();
		
		drawCorner(path, tl, false, false, -Math.PI / 2, true, w, h, centerX, centerY);
		if (topCom != null) {
			path.commands = path.commands.concat(topCom);
			path.data = path.data.concat(topDat);
		}
		drawCorner(path, tr, true, false, 0, false, w, h, centerX, centerY);
		if (rightCom != null) {
			path.commands = path.commands.concat(rightCom);
			path.data = path.data.concat(rightDat);
		}
		drawCorner(path, br, true, true, Math.PI/2, false, w, h, centerX, centerY);
		if (bottomCom != null) {
			path.commands = path.commands.concat(bottomCom);
			path.data = path.data.concat(bottomDat);
		}
		drawCorner(path, bl, false, true, Math.PI, false, w, h, centerX, centerY);
		if (leftCom != null) {
			path.commands = path.commands.concat(leftCom);
			path.data = path.data.concat(leftDat);
		}
		
		DrawnStyleUtils.closePath(path);
		
		var pathArr:GraphArray<IGraphicsData> = new GraphArray<IGraphicsData>();
		pathArr.push(path);
		
		var commands = DrawnStyleUtils.beginFillStrokes(fill, stroke, true, w, h, pathArr);
		commands.push(new GraphicsEndFill());
		_graphicsAccess.drawGraphicsData(commands);
	}
	private function onShapeChanged(?param1:Dynamic, ?param2:Dynamic):Void {
		invalidate();
	}
	private function getCornerSize(cs:CornerStyle):Float {
		switch(cs) {
			case CsSquare: return 0;
			case CsCirc(r): return r;
		}
	}
	static var SQUARE_CORNER:CornerStyle;
	static var CAPSULE_CORNER:CornerStyle;
	
	private function drawCorner(addTo:GraphicsPath, cs:CornerStyle, flipH:Bool, flipV:Bool, angle:Float, isInitial:Bool, width:Float, height:Float, cX:Float, cY:Float):Void {
		var hW:Float = width / 2;
		var hH:Float = height / 2;
		switch(cs) {
			case CsSquare:
				var x:Float = -hW;
				var y:Float = -hH;
				if (flipH) x *= -1;
				if (flipV) y *= -1;
				if (isInitial) {
					addTo.commands.push(GraphicsPathCommand.MOVE_TO);
				}else {
					addTo.commands.push(GraphicsPathCommand.LINE_TO);
				}
				addTo.data.push(x+cX);
				addTo.data.push(y+cY);
			case CsCirc(r):
				if (r > hW) r = hW;
				if (r > hH) r = hH;
				
				var x:Float = r-hW;
				var y:Float = r-hH;
				if (flipH) x *= -1;
				if (flipV) y *= -1;
				
				DrawnStyleUtils.drawArc(addTo, x+cX, y+cY, r, Math.PI / 2, angle, isInitial);
		}
	}
}
enum BoxStyle{
	BsRect(f:FillStyle, s:StrokeStyle, ?e:Edges);
	BsRectComplex(f:FillStyle, s:StrokeStyle, c:Corners, ?e:Edges);
	BsCapsule(f:FillStyle, s:StrokeStyle);
}
enum Corners{
	CSame(cs:CornerStyle);
	CDiff(tl:CornerStyle, tr:CornerStyle, br:CornerStyle, bl:CornerStyle);
}
enum Edges{
	EArrow(atX:IValue, atY:IValue, arrowLength:IValue, arrowWidth:IValue, ?baseRadius:IValue, ?pointRadius:IValue, ?angleArrow:Bool);
}
enum CornerStyle{
	CsSquare;
	CsCirc(r:Float);
}
