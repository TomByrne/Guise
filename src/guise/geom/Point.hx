package guise.geom;

#if nme
typedef Point = nme.geom.Point;
#else
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