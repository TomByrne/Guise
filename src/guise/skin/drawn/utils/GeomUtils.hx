package guise.skin.drawn.utils;

class GeomUtils
{

	/*inline public static function closestPoint2Line(x1:Float,y1:Float, x2:Float,y2:Float, pX:Float,pY:Float):Point{ // pX,pY is the point
		var px = x2 - x1;
		var py = y2 - y1;

		var dist = px * px + py * py;

		var u =  ((pX - x1) * px + (pY - y1) * py) / dist;

		if (u > 1){
			u = 1;
		}else if( u < 0){
			u = 0;
		}

		var x = x1 + u * px;
		var y = y1 + u * py;

		return { x:x - pX, y:y - pY };
	}*/
	
		inline public static function closestPoint2Line(sx1:Float, sy1:Float, sx2:Float, sy2:Float, px:Float, py:Float):Point
	{
		var xDelta = sx2 - sx1;
		var yDelta = sy2 - sy1;

		if ((xDelta == 0) && (yDelta == 0))
		{
			throw "Segment start equals segment end";
		}

		var u = ((px - sx1) * xDelta + (py - sy1) * yDelta) / (xDelta * xDelta + yDelta * yDelta);

		if (u < 0){
			return { x:sx1, y:sy1 };
		}else if (u > 1){
			return { x:sx2, y:sy2 };
		}else{
			return { x:Math.round(sx1 + u * xDelta), y:Math.round(sy1 + u * yDelta) };
		}
	}
	

	inline public static function closestLineToPoint(x:Float, y:Float, lines:Array<Line>):Line{
		var closest:Float = 0;
		var closestLine:Line = null;
		for (i in 0...lines.length) {
			var line = lines[i];
			var dist1 = dist(x, y, line.start.x, line.start.y);
			var dist2 = dist(x, y, line.end.x, line.end.y);
			if (closestLine == null || dist1 < closest) {
				closest = dist1;
				closestLine = line;
			}
			if (dist2 < closest) {
				closest = dist2;
				closestLine = line;
			}
		}
		return closestLine;
	}
	
	inline public static function dist(x1:Float, y1:Float, x2:Float, y2:Float):Float {
		var difX = x1 - x2;
		var difY = y1 - y2;
		return Math.sqrt(difX * difX + difY * difY);
	}
	
	inline public static function getAngle2Points(x1:Float, y1:Float, x2:Float, y2:Float):Float {
		var xDiff = x2 - x1;
        var yDiff = y2 - y1;
        return Math.atan2(yDiff, xDiff);
	}
	
	inline public static function projectPoint(distance:Float, angle:Float, x:Float, y:Float):Point{
		return {x:projectX(distance, angle, x), y:projectY(distance, angle, y)};
	}
	inline public static function projectX(distance:Float, angle:Float, fromX:Float):Float{
		return (distance*Math.cos((angle)))+fromX;
	}
	inline public static function projectY(distance:Float, angle:Float, fromY:Float):Float{
		return (distance*Math.sin((angle)))+fromY;
	}
}


typedef Point = {x:Float, y:Float};
typedef Line = {start:Point, end:Point};