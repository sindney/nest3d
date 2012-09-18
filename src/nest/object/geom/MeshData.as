package nest.object.geom
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.VertexBuffer3D;
	import flash.geom.Vector3D;
	
	/**
	 * MeshData
	 */
	public class MeshData {
		
		public static function calculateNormal(vertices:Vector.<Vertex>, triangles:Vector.<Triangle>):void {
			var i:int, j:int;
			var tri:Triangle;
			var v1:Vertex, v2:Vertex, v3:Vertex;
			var n1:Vector3D = new Vector3D();
			var n2:Vector3D = new Vector3D();
			
			j = triangles.length;
			for (i = 0; i < j; i++) {
				tri = triangles[i];
				v1 = vertices[tri.index0];
				v2 = vertices[tri.index1];
				v3 = vertices[tri.index2];
				
				n1.setTo(v2.x - v1.x, v2.y - v1.y, v2.z - v1.z);
				n2.setTo(v3.x - v2.x, v3.y - v2.y, v3.z - v2.z);
				tri.normal.copyFrom(n1.crossProduct(n2));
				tri.normal.normalize();
				
				v1.normal.x += tri.normal.x;
				v1.normal.y += tri.normal.y;
				v1.normal.z += tri.normal.z;
				v2.normal.x += tri.normal.x;
				v2.normal.y += tri.normal.y;
				v2.normal.z += tri.normal.z;
				v3.normal.x += tri.normal.x;
				v3.normal.y += tri.normal.y;
				v3.normal.z += tri.normal.z;
			}
			
			j = vertices.length;
			for (i = 0; i < j; i++) vertices[i].normal.normalize();
		}
		
		private var _vertexBuffer:VertexBuffer3D;
		private var _uvBuffer:VertexBuffer3D;
		private var _indexBuffer:IndexBuffer3D;
		private var _normalBuffer:VertexBuffer3D;
		
		private var _vertices:Vector.<Vertex>;
		private var _triangles:Vector.<Triangle>;
		
		private var _vertex:Vector.<Number>;
		private var _uv:Vector.<Number>;
		private var _index:Vector.<uint>;
		private var _normal:Vector.<Number>;
		
		private var _bNumVts:int;
		
		private var _numVertices:int = 0;
		private var _numIndices:int = 0;
		private var _numTriangles:int = 0;
		
		private var _changed:Boolean = false;
		
		public function MeshData(vertices:Vector.<Vertex>, triangles:Vector.<Triangle>) {
			_vertices = vertices;
			_triangles = triangles;
			_vertex = new Vector.<Number>();
			_uv = new Vector.<Number>();
			_index = new Vector.<uint>();
			_normal = new Vector.<Number>();
			update();
		}
		
		/**
		 * Call this when you modified vertices/triangles list.
		 */
		public function update(recreate:Boolean = false):void {
			if (!_vertices || !_triangles) return;
			
			_numVertices = _vertices.length;
			_numTriangles = _triangles.length;
			_numIndices = _triangles.length * 3;
			
			if (recreate) {
				_vertex = new Vector.<Number>();
				_uv = new Vector.<Number>();
				_index = new Vector.<uint>();
				_normal = new Vector.<Number>();
			}
			
			var i:int, j:int, k:int;
			var vertex:Vertex;
			var triangle:Triangle;
			
			_bNumVts = _numVertices;
			for (i = 0; i < _numVertices; i++) {
				vertex = _vertices[i];
				// vertex
				j = i * 3;
				_vertex[j] = vertex.x;
				_vertex[j + 1] = vertex.y;
				_vertex[j + 2] = vertex.z;
				// normal
				_normal[j] = vertex.normal.x;
				_normal[j + 1] = vertex.normal.y;
				_normal[j + 2] = vertex.normal.z;
				// uv
				j = i * 2;
				_uv[j] = vertex.u;
				_uv[j + 1] = vertex.v;
			}
			
			for (i = 0; i < _numTriangles; i++) {
				triangle = _triangles[i];
				// index
				j = i * 3;
				
				vertex = _vertices[triangle.index0];
				if (triangle.u0 != vertex.u || triangle.v0 != vertex.v) {
					_index[j] = _bNumVts;
					
					k = _bNumVts * 3;
					// vertex
					_vertex[k] = vertex.x;
					_vertex[k + 1] = vertex.y;
					_vertex[k + 2] = vertex.z;
					// normal
					_normal[k] = vertex.normal.x;
					_normal[k + 1] = vertex.normal.y;
					_normal[k + 2] = vertex.normal.z;
					// uv
					k = _bNumVts * 2;
					_uv[k] = triangle.u0;
					_uv[k + 1] = triangle.v0;
					
					_bNumVts++;
				} else {
					_index[j] = triangle.index0;
				}
				
				vertex = _vertices[triangle.index1];
				if (triangle.u1 != vertex.u || triangle.v1 != vertex.v) {
					_index[j + 1] = _bNumVts;
					
					k = _bNumVts * 3;
					// vertex
					_vertex[k] = vertex.x;
					_vertex[k + 1] = vertex.y;
					_vertex[k + 2] = vertex.z;
					// normal
					_normal[k] = vertex.normal.x;
					_normal[k + 1] = vertex.normal.y;
					_normal[k + 2] = vertex.normal.z;
					// uv
					k = _bNumVts * 2;
					_uv[k] = triangle.u1;
					_uv[k + 1] = triangle.v1;
					
					_bNumVts++;
				} else {
					_index[j + 1] = triangle.index1;
				}
				
				vertex = _vertices[triangle.index2];
				if (triangle.u2 != vertex.u || triangle.v2 != vertex.v) {
					_index[j + 2] = _bNumVts;
					
					k = _bNumVts * 3;
					// vertex
					_vertex[k] = vertex.x;
					_vertex[k + 1] = vertex.y;
					_vertex[k + 2] = vertex.z;
					// normal
					_normal[k] = vertex.normal.x;
					_normal[k + 1] = vertex.normal.y;
					_normal[k + 2] = vertex.normal.z;
					// uv
					k = _bNumVts * 2;
					_uv[k] = triangle.u2;
					_uv[k + 1] = triangle.v2;
					
					_bNumVts++;
				} else {
					_index[j + 2] = triangle.index2;
				}
			}
			
			_changed = true;
		}
		
		/**
		 * Get the 3D position of a Point by its UV.
		 */
		public function getPositionByUV(u:Number, v:Number):Vertex {
			var v0:Vertex;
			var v1:Vertex;
			var v2:Vertex;
			var contains:Boolean = false;
			var result:Vertex;
			for each(var tri:Triangle in _triangles) {
				if (tri.contains(u, v)) {
					contains = true;
					break;
				}
			}
			if (contains) {
				v0 = _vertices[tri.index0];
				v1 = _vertices[tri.index1];
				v2 = _vertices[tri.index2];
				var du0:Number = tri.u0 - u;
				var dv0:Number = tri.v0 - v;
				var du1:Number = tri.u1 - u;
				var dv1:Number = tri.v1 - v;
				var du2:Number = tri.u2 - u;
				var dv2:Number = tri.v2 - v;
				
				var cross1:Number = du0 * dv1 - du1 * dv0;
				var cross2:Number = du1 * dv2 - du2 * dv1;
				var cross3:Number = du2 * dv0 - du0 * dv2;
				var invArea:Number = 1 / (cross1 + cross2 + cross3);
				
				var w0:Number = cross1 * invArea;
				var w1:Number = cross2 * invArea;
				var w2:Number = cross3 * invArea;
				
				result = new Vertex(v0.x * w0 + v1.x * w1 + v2.x * w2,
									v0.y * w0 + v1.y * w1 + v2.y * w2,
									v0.z * w0 + v1.z * w1 + v2.z * w2,
									u, v);
			}
			return result;
		}
		
		public function upload(context3d:Context3D, uv:Boolean, normal:Boolean):void {
			if (_changed) {
				_changed = false;
				if (_vertexBuffer)_vertexBuffer.dispose();
				_vertexBuffer = context3d.createVertexBuffer(_bNumVts, 3);
				_vertexBuffer.uploadFromVector(_vertex, 0, _bNumVts);
				if (_uvBuffer)_uvBuffer.dispose();
				_uvBuffer = context3d.createVertexBuffer(_bNumVts, 2);
				_uvBuffer.uploadFromVector(_uv, 0, _bNumVts);
				if (_normalBuffer)_normalBuffer.dispose();
				_normalBuffer = context3d.createVertexBuffer(_bNumVts, 3);
				_normalBuffer.uploadFromVector(_normal, 0, _bNumVts);
				if (_indexBuffer)_indexBuffer.dispose();
				_indexBuffer = context3d.createIndexBuffer(_numIndices);
				_indexBuffer.uploadFromVector(_index, 0, _numIndices);
			}
			context3d.setVertexBufferAt(0, _vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			if (uv) context3d.setVertexBufferAt(1, _uvBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
			if (normal) context3d.setVertexBufferAt(2, _normalBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
		}
		
		public function unload(context3d:Context3D):void {
			context3d.setVertexBufferAt(0, null, 0, Context3DVertexBufferFormat.FLOAT_3);
			context3d.setVertexBufferAt(1, null, 0, Context3DVertexBufferFormat.FLOAT_2);
			context3d.setVertexBufferAt(2, null, 0, Context3DVertexBufferFormat.FLOAT_3);
		}
		
		public function dispose():void {
			if (_vertexBuffer)_vertexBuffer.dispose();
			if (_uvBuffer)_uvBuffer.dispose();
			if (_indexBuffer)_indexBuffer.dispose();
			if (_normalBuffer)_normalBuffer.dispose();
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		public function get vertices():Vector.<Vertex> {
			return _vertices;
		}
		
		public function set vertices(value:Vector.<Vertex>):void {
			_vertices = value;
		}
		
		public function get triangles():Vector.<Triangle> {
			return _triangles;
		}
		
		public function set triangles(value:Vector.<Triangle>):void {
			_triangles = value;
		}
		
		public function get rawVertices():Vector.<Number> {
			return _vertex;
		}
		
		public function get indices():Vector.<uint> {
			return _index;
		}
		
		public function get bNumVts():int {
			return _bNumVts;
		}
		
		public function get numVertices():int {
			return _numVertices;
		}
		
		public function get numIndices():int {
			return _numIndices;
		}
		
		public function get numTriangles():int {
			return _numTriangles;
		}
		
		public function get indexBuffer():IndexBuffer3D {
			return _indexBuffer;
		}
		
	}

}