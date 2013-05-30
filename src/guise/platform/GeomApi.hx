package guise.platform;

class GeomApi { }




#if nme
typedef Matrix = nme.geom.Matrix;
typedef Point = nme.geom.Point;
#else
// taken from jeash.geom.Matrix
class Matrix
{
	public var a : Float;
	public var b : Float;
	public var c : Float;
	public var d : Float;
	public var tx : Float;
	public var ty : Float;

	public function new(?in_a : Float, ?in_b : Float, ?in_c : Float, ?in_d : Float,
			?in_tx : Float, ?in_ty : Float)
	{
		a = in_a==null ? 1.0 : in_a;
		b = in_b==null ? 0.0 : in_b;
		c = in_c==null ? 0.0 : in_c;
		d = in_d==null ? 1.0 : in_d;
		tx = in_tx==null ? 0.0 : in_tx;
		ty = in_ty==null ? 0.0 : in_ty;
	}


	public function clone() { return new guise.platform.GeomApi(a,b,c,d,tx,ty); }

	public function createGradientBox(in_width : Float, in_height : Float,
			?rotation : Float, ?in_tx : Float, ?in_ty : Float) : Void
	{
		a = in_width/1638.4;
		d = in_height/1638.4;

		// rotation is clockwise
		if (rotation!=null && rotation!=0.0)
		{
			var cos = Math.cos(rotation);
			var sin = Math.sin(rotation);
			b = sin*d;
			c = -sin*a;
			a *= cos;
			d *= cos;
		}
		else
		{
			b = c = 0;
		}

		tx = in_tx!=null ? in_tx+in_width/2 : in_width/2;
		ty = in_ty!=null ? in_ty+in_height/2 : in_height/2;
	}

	public function setRotation(inTheta:Float,?inScale:Float)
	{
		var scale:Float = inScale==null ? 1.0 : inScale;
		a = Math.cos(inTheta)*scale;
		c = Math.sin(inTheta)*scale;
		b = -c;
		d = a;
	}

	public function invert() : Matrix
	{
		var norm = a*d-b*c;
		if (norm==0)
		{
			a = b = c = d = 0;
			tx=-tx;
			ty=-ty;
		}
		else
		{
			norm = 1.0/norm;
			var a1 = d*norm;
			d = a*norm;
			a = a1;
			b*=-norm;
			c*=-norm;

			var tx1 = - a*tx - c*ty; 
			ty = - b*tx - d*ty; 
			tx = tx1;
		}
		return this;
	}

	public function transformPoint(inPos:Point)
	{
		return new Point( inPos.x*a + inPos.y*c + tx,
				inPos.x*b + inPos.y*d + ty );
	}

	public function translate(inDX:Float, inDY:Float)
	{
		tx += inDX;
		ty += inDY;
	}


	/*
	   Rotate object "after" other transforms

	   [  a  b   0 ][  ma mb  0 ]
	   [  c  d   0 ][  mc md  0 ]
	   [  tx ty  1 ][  mtx mty 1 ]

	   ma = md = cos
	   mb = -sin
	   mc = sin
	   mtx = my = 0

	 */

	public function rotate(inTheta:Float)
	{
		var cos = Math.cos(inTheta);
		var sin = Math.sin(inTheta);

		var a1 = a*cos - b*sin;
		b = a*sin + b*cos;
		a = a1;

		var c1 = c*cos - d*sin;
		d = c*sin + d*cos;
		c = c1;

		var tx1 = tx*cos - ty*sin;
		ty = tx*sin + ty*cos;
		tx = tx1;
	}



	/*

	   Scale object "after" other transforms

	   [  a  b   0 ][  sx  0   0 ]
	   [  c  d   0 ][  0   sy  0 ]
	   [  tx ty  1 ][  0   0   1 ]
	 */
	public function scale(inSX:Float, inSY:Float)
	{
		a*=inSX;
		b*=inSY;

		c*=inSX;
		d*=inSY;

		tx*=inSX;
		ty*=inSY;
	}


	/*

	   A "translate" . concat "rotate" rotates the translation component.
	   ie,

	   [X'] = [X][trans][rotate]


	   Multiply "after" other transforms ...


	   [  a  b   0 ][  ma mb  0 ]
	   [  c  d   0 ][  mc md  0 ]
	   [  tx ty  1 ][  mtx mty 1 ]


	 */
	public function concat(m:guise.platform.GeomApi)
	{
		var a1 = a*m.a + b*m.c;
		b = a*m.b + b*m.d;
		a = a1;

		var c1 = c*m.a + d*m.c;
		d = c*m.b + d*m.d;
		c = c1;

		var tx1 = tx*m.a + ty*m.c + m.tx;
		ty = tx*m.b + ty*m.d + m.ty;
		tx = tx1;
	}

	public function mult(m:guise.platform.GeomApi)
	{
		var result = new guise.platform.GeomApi();
		result.a = a*m.a + b*m.c;
		result.b = a*m.b + b*m.d;
		result.c = c*m.a + d*m.c;
		result.d = c*m.b + d*m.d;

		result.tx = tx*m.a + ty*m.c + m.tx;
		result.ty = tx*m.b + ty*m.d + m.ty;
		return result;
	}

	public function identity() 
	{
		a = 1;
		b = 0;
		c = 0;
		d = 1;
		tx = 0;
		ty = 0;
	}

	public inline function toMozString()
	{
		#if js
		untyped {
			var m = "matrix(";
			m += a; m += ", ";
			m += b; m += ", ";
			m += c; m += ", ";
			m += d; m += ", ";
			m += tx; m += "px, ";
			m += ty; m += "px)";
			return m;
		}
		#end
	}

	public inline function toString()
	{
		#if js
		untyped {
			var m = "matrix(";
			m += a; m += ", ";
			m += b; m += ", ";
			m += c; m += ", ";
			m += d; m += ", ";
			m += tx; m += ", ";
			m += ty; m += ")";
			return m;
		}
		#end
	}
}
// taken from jeash.geom.Point
class Point
{
   public var x : Float;
   public var y : Float;

   public function new(?inX : Float, ?inY : Float)
   {
      x = inX==null ? 0.0 : inX;
      y = inY==null ? 0.0 : inY;
   }

   public function add(v : Point) : Point
   {
      return new Point(v.x+x,v.y+y);
   }

   public function clone() : Point
   {
      return new Point(x,y);
   }

   public function equals(toCompare : Point) : Bool
   {
      return toCompare.x==x && toCompare.y==y;
   }

   public var length(get_length,null) : Float;
   function get_length()
   {
      return Math.sqrt(x*x+y*y);
   }
   public function normalize(thickness : Float) : Void
   {
      if (x==0 && y==0)
         x = thickness;
      else
      {
         var norm = thickness / Math.sqrt(x*x+y*y);
         x*=norm;
         y*=norm;
      }
   }

   public function offset(dx : Float, dy : Float) : Void
   {
      x+=dx;
      y+=dy;
   }
   public function subtract(v : Point) : Point
   {
      return new Point(x-v.x,y-v.y);
   }

   public static function distance(pt1 : Point, pt2 : Point) : Float
   {
      var dx = pt1.x-pt2.x;
      var dy = pt1.y-pt2.y;
      return Math.sqrt(dx*dx + dy*dy);
   }

   public static function interpolate(pt1 : Point, pt2 : Point, f : Float) : Point
   {
      return new Point( pt2.x + f*(pt1.x-pt2.x),
                        pt2.y + f*(pt1.y-pt2.y) );
   }

   public static function polar(len : Float, angle : Float) : Point
   {
      return new Point( len*Math.cos(angle), len*Math.sin(angle) );
   }
}
#end