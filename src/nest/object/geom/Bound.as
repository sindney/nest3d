package nest.object.geom 
{
	import flash.geom.Vector3D;
	
	/**
	 * Bound
	 */
	public class Bound {
		
		public static function BSphere_BSphere(center:Vector3D, r:Number, center1:Vector3D, r1:Number):Boolean {
			var x:Number = center.x - center1.x;
			var y:Number = center.y - center1.y;
			var z:Number = center.z - center1.z;
			return (x * x + y * y + z * z) <= (r + r1) * (r + r1);
		}
		
		public static function AABB_BSphere(max:Vector3D, min:Vector3D, center:Vector3D, r:Number):Boolean {
			var x:Number = center.x, y:Number = center.y, z:Number = center.z;
			if (x < min.x) {
				x = min.x;
			} else if (x > max.x) {
				x = max.x;
			}
			if (y < min.y) {
				y = min.y;
			} else if (y > max.y) {
				y = max.y;
			}
			if (z < min.z) {
				z = min.z;
			} else if (z > max.z) {
				z = max.z;
			}
			x -= center.x;
			y -= center.y;
			z -= center.z;
			return (x * x + y * y + z * z) <= (r * r);
		}
		
		public static function AABB_AABB(max:Vector3D, min:Vector3D, max1:Vector3D, min1:Vector3D):Boolean {
			if (min.x > max1.x) return false;
			if (max.x < min1.x) return false;
			if (min.y > max1.y) return false;
			if (max.y < min1.y) return false;
			if (min.z > max1.z) return false;
			if (max.z < min1.z) return false;
			return true;
		}
		
		public var vertices:Vector.<Vector3D> = new Vector.<Vector3D>(8, true);
		
		public function Bound() {
			vertices[0] = new Vector3D();
			vertices[1] = new Vector3D();
			vertices[2] = new Vector3D();
			vertices[3] = new Vector3D();
			vertices[4] = new Vector3D();
			vertices[5] = new Vector3D();
			vertices[6] = new Vector3D();
			vertices[7] = new Vector3D();
		}
		
	}

}