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
		
		public static function calculate(bound:Bound, geom:Geometry):void {
			var i:int, j:int = geom.numVertices;
			var max:Vector3D, min:Vector3D;
			if (bound.aabb) {
				max = bound.vertices[7];
				min = bound.vertices[0];
				max.setTo(0, 0, 0);
				min.setTo(0, 0, 0);
				
				for each(var vertex:Vertex in geom.vertices) {
					if (vertex.x > max.x) max.x = vertex.x;
					else if (vertex.x < min.x) min.x = vertex.x;
					if (vertex.y > max.y) max.y = vertex.y;
					else if (vertex.y < min.y) min.y = vertex.y;
					if (vertex.z > max.z) max.z = vertex.z;
					else if (vertex.z < min.z) min.z = vertex.z;
				}
				
				bound.vertices[1].setTo(max.x, min.y, min.z);
				bound.vertices[2].setTo(min.x, max.y, min.z);
				bound.vertices[3].setTo(max.x, max.y, min.z);
				bound.vertices[4].setTo(min.x, min.y, max.z);
				bound.vertices[5].setTo(max.x, min.y, max.z);
				bound.vertices[6].setTo(min.x, max.y, max.z);
			} else {
				max = new Vector3D();
				for each(vertex in geom.vertices) {
					if (vertex.x > max.x) max.x = vertex.x;
					if (vertex.y > max.y) max.y = vertex.y;
					if (vertex.z > max.z) max.z = vertex.z;
				}
				bound.radius = max.x > max.y ? max.x : max.y;
				if (max.z > bound.radius) bound.radius = max.z;
			}
			bound.center.x = (max.x + min.x) * 0.5;
			bound.center.y = (max.y + min.y) * 0.5;
			bound.center.z = (max.z + min.z) * 0.5;
		}
		
		public var center:Vector3D = new Vector3D();
		public var radius:Number = 0;
		public var vertices:Vector.<Vector3D>;
		
		public var aabb:Boolean = true;
		
		public function Bound() {
			vertices = new Vector.<Vector3D>(8, true);
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