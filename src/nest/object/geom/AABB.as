package nest.object.geom 
{
	import flash.geom.Vector3D;
	
	import nest.object.geom.Vertex;
	
	/**
	 * AABB
	 */
	public class AABB implements IBound {
		
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
		
		private var _vertices:Vector.<Vector3D>;
		private var _center:Vector3D;
		
		public function AABB() {
			_vertices = new Vector.<Vector3D>(8, true);
			_vertices[0] = new Vector3D();
			_vertices[1] = new Vector3D();
			_vertices[2] = new Vector3D();
			_vertices[3] = new Vector3D();
			_vertices[4] = new Vector3D();
			_vertices[5] = new Vector3D();
			_vertices[6] = new Vector3D();
			_vertices[7] = new Vector3D();
			_center = new Vector3D();
		}
		
		public function update(vertices:Vector.<Vertex>):void {
			var max:Vector3D = _vertices[7];
			var min:Vector3D = _vertices[0];
			max.setTo(0, 0, 0);
			min.setTo(0, 0, 0);
			
			var vertex:Vertex;
			for each(vertex in vertices) {
				if (vertex.x > max.x) max.x = vertex.x;
				else if (vertex.x < min.x) min.x = vertex.x;
				if (vertex.y > max.y) max.y = vertex.y;
				else if (vertex.y < min.y) min.y = vertex.y;
				if (vertex.z > max.z) max.z = vertex.z;
				else if (vertex.z < min.z) min.z = vertex.z;
			}
			
			_vertices[1].setTo(max.x, min.y, min.z);
			_vertices[2].setTo(min.x, max.y, min.z);
			_vertices[3].setTo(max.x, max.y, min.z);
			_vertices[4].setTo(min.x, min.y, max.z);
			_vertices[5].setTo(max.x, min.y, max.z);
			_vertices[6].setTo(min.x, max.y, max.z);
			
			_center.x = (max.x + min.x) * 0.5;
			_center.y = (max.y + min.y) * 0.5;
			_center.z = (max.z + min.z) * 0.5;
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		public function get vertices():Vector.<Vector3D> {
			return _vertices;
		}
		
		public function get max():Vector3D {
			return _vertices[7];
		}
		
		public function get min():Vector3D {
			return _vertices[0];
		}
		
		public function get center():Vector3D {
			return _center;
		}
		
	}

}