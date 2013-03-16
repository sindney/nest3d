package nest.object.geom 
{
	
	/**
	 * SkinInfo
	 */
	public class SkinInfo {
		
		// TODO: 决定要不要copyToGeometries函数
		/*public static function copyToGeometries(target:Vector.<Geometry>, skin:SkinInfo):void {
			var i:int, j:int, k:int, l:int = skin.vertices.length;
			var m:int, n:int;
			var geom:Geometry;
			var vertices:Vector.<Vertex>;
			var triangles:Vector.<Triangle>;
			var vertex:Vertex, vertex1:Vertex;
			var triangle:Triangle;
			for (i = 0; i < l; i++) {
				geom = target[i] = new Geometry(new Vector.<Vertex>(), new Vector.<Triangle>());
				vertices = skin.vertices[i];
				k = vertices.length;
				for (j = 0; j < k; j++) {
					vertex = vertices[j];
					vertex1 = new Vertex(vertex.x, vertex.y, vertex.z, vertex.u, vertex.v);
					vertex1.indices = new Vector.<uint>();
					vertex1.weights = new Vector.<Number>();
					vertex1.nx = vertex.nx;
					vertex1.ny = vertex.ny;
					vertex1.nz = vertex.nz;
					n = vertex.indices.length;
					for (m = 0; m < n; m++) {
						vertex1.indices[m] = vertex.indices[m];
						vertex1.weights[m] = vertex.weights[m];
					}
					geom.vertices.push(vertex1);
				}
				triangles = skin.triangles[i];
				k = triangles.length;
				for (j = 0; j < k; j++) {
					triangle = triangles[j];
					geom.triangles.push(new Triangle(triangle.indices[0], triangle.indices[1], triangle.indices[2], 
													triangle.uvs[0], triangle.uvs[1], triangle.uvs[2], triangle.uvs[3], 
													triangle.uvs[4], triangle.uvs[5]));
				}
			}
		}*/
		
		public var root:Joint;
		public var joints:Vector.<Joint>;
		
		public function SkinInfo(root:Joint, joints:Vector.<Joint>) {
			this.root = root;
			this.joints = joints;
		}
		
	}

}