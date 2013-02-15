package nest.control.util 
{
	import flash.geom.Vector3D;
	
	/**
	 * Plane
	 */
	public final class Plane {
		
		public static const FRONT_PLANE:int = 0;
		public static const BACK_PLANE:int = 1;
		public static const ON_PLANE:int = 2;
		
		public var a:Number;
		public var b:Number;
		public var c:Number;
		public var d:Number;
		
		public function Plane(a:Number = 0, b:Number = 0, c:Number = 0, d:Number = 0) {
			this.a = a;
			this.b = b;
			this.c = c;
			this.d = d;
		}
		
		public function create(v1:Vector3D, v2:Vector3D, v3:Vector3D):void {
			var e1:Vector3D = new Vector3D();
			var e2:Vector3D = new Vector3D();
			var n:Vector3D = new Vector3D();
			
			e1 = v2.subtract(v1);
			e2 = v3.subtract(v1);
			
			n = e1.crossProduct(e2);
			n.normalize();
			
			a = n.x; b = n.y; c = n.z;
			d = - (a * v1.x + b * v1.y + c * v1.z);
		}
		
		public function classifyPoint(p:Vector3D):int {
			var distance:Number = getDistance(p);
			if (distance > 0.001) return Plane.FRONT_PLANE;
			if (distance < -0.001) return Plane.BACK_PLANE;
			return Plane.ON_PLANE;
		}
		
		public function getDistance(p:Vector3D):Number {
			return a * p.x + b * p.y + c * p.z + d;
		}
		
	}

}