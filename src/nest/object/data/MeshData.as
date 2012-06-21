package nest.object.data
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.VertexBuffer3D;
	import flash.geom.Vector3D;
	
	import nest.object.geom.Triangle;
	import nest.object.geom.Vertex;
	
	/**
	 * MeshData
	 */
	public class MeshData {
		
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
			if (!_vertices && !_triangles) return;
			
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
		
		public function upload(context3D:Context3D, uv:Boolean, normal:Boolean):void {
			if (_changed) {
				_changed = false;
				if (_vertexBuffer)_vertexBuffer.dispose();
				_vertexBuffer = context3D.createVertexBuffer(_bNumVts, 3);
				_vertexBuffer.uploadFromVector(_vertex, 0, _bNumVts);
				if (_uvBuffer)_uvBuffer.dispose();
				if (uv) {
					_uvBuffer = context3D.createVertexBuffer(_bNumVts, 2);
					_uvBuffer.uploadFromVector(_uv, 0, _bNumVts);
				}
				if (_normalBuffer)_normalBuffer.dispose();
				if (normal) {
					_normalBuffer = context3D.createVertexBuffer(_bNumVts, 3);
					_normalBuffer.uploadFromVector(_normal, 0, _bNumVts);
				}
				if (_indexBuffer)_indexBuffer.dispose();
				_indexBuffer = context3D.createIndexBuffer(_numIndices);
				_indexBuffer.uploadFromVector(_index, 0, _numIndices);
			}
			context3D.setVertexBufferAt(0, _vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			if (uv) context3D.setVertexBufferAt(1, _uvBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
			if (normal) context3D.setVertexBufferAt(2, _normalBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
		}
		
		public function unload(context3D:Context3D):void {
			context3D.setVertexBufferAt(0, null, 0, Context3DVertexBufferFormat.FLOAT_3);
			context3D.setVertexBufferAt(1, null, 0, Context3DVertexBufferFormat.FLOAT_2);
			context3D.setVertexBufferAt(2, null, 0, Context3DVertexBufferFormat.FLOAT_3);
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
		
		///////////////////////////////////
		// toString
		///////////////////////////////////
		
		public function toString():String {
			return "[nest.object.data.MeshData]";
		}
		
	}

}