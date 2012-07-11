package nest.object.geom 
{
	import flash.geom.Vector3D;
	
	import nest.object.geom.Vertex;
	
	/**
	 * BSphere
	 */
	public class BSphere implements IBound {
		
		private var _center:Vector3D;
		private var _radius:Number;
		
		public function BSphere() {
			_radius = 0;
			_center = new Vector3D();
		}
		
		public function update(vertices:Vector.<Vertex>):void {
			var max:Vector3D = new Vector3D();
			
			var vertex:Vertex;
			for each(vertex in vertices) {
				if (vertex.x > max.x) max.x = vertex.x;
				if (vertex.y > max.y) max.y = vertex.y;
				if (vertex.z > max.z) max.z = vertex.z;
			}
			
			_radius = max.x > max.y ? max.x : max.y;
			if (max.z > _radius)_radius = max.z;
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		public function get center():Vector3D {
			return _center;
		}
		
		public function get radius():Number {
			return _radius;
		}
		
	}

}