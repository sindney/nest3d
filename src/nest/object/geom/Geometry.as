package nest.object.geom
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.VertexBuffer3D;
	import flash.geom.Vector3D;
	
	import nest.view.ViewPort;
	
	/**
	 * Geometry
	 */
	public class Geometry {
		
		public static function calculateNormal(vertices:Vector.<Vertex>, triangles:Vector.<Triangle>):void {
			var i:int, j:int;
			var tri:Triangle;
			var v1:Vertex, v2:Vertex, v3:Vertex;
			var vt1:Vector3D = new Vector3D();
			var vt2:Vector3D = new Vector3D();
			
			j = triangles.length;
			for (i = 0; i < j; i++) {
				tri = triangles[i];
				v1 = vertices[tri.index0];
				v2 = vertices[tri.index1];
				v3 = vertices[tri.index2];
				
				vt1.setTo(v2.x - v1.x, v2.y - v1.y, v2.z - v1.z);
				vt2.setTo(v3.x - v2.x, v3.y - v2.y, v3.z - v2.z);
				vt1 = vt1.crossProduct(vt2);
				vt1.normalize();
				
				v1.normal.x += vt1.x;
				v1.normal.y += vt1.y;
				v1.normal.z += vt1.z;
				v2.normal.x += vt1.x;
				v2.normal.y += vt1.y;
				v2.normal.z += vt1.z;
				v3.normal.x += vt1.x;
				v3.normal.y += vt1.y;
				v3.normal.z += vt1.z;
			}
			
			j = vertices.length;
			for (i = 0; i < j; i++) vertices[i].normal.normalize();
		}
		
		private var _vertexBuffer:VertexBuffer3D;
		private var _uvBuffer:VertexBuffer3D;
		private var _indexBuffer:IndexBuffer3D;
		private var _normalBuffer:VertexBuffer3D;
		
		private var _numVertices:int = 0;
		private var _numIndices:int = 0;
		private var _numTriangles:int = 0;
		
		public var vertices:Vector.<Vertex>;
		public var triangles:Vector.<Triangle>;
		
		public function Geometry(vertices:Vector.<Vertex>, triangles:Vector.<Triangle>) {
			this.vertices = vertices;
			this.triangles = triangles;
			update(true);
		}
		
		/**
		 * Call this when you modified vertices/triangles list.
		 * <p>If the length of your vertices, triangles array is changed, set flag to true.</p>
		 * <p>If you didn't initialize this class in it's constructor.</p>
		 * <p>Then when you valued it's vertices, triangles array, you should call update(true).</p>
		 */
		public function update(flag:Boolean = false):void {
			if (!vertices || !triangles) return;
			
			_numVertices = vertices.length;
			_numTriangles = triangles.length;
			_numIndices = _numTriangles * 3;
			
			var rawVertex:Vector.<Number> = new Vector.<Number>();
			var	rawUV:Vector.<Number> = new Vector.<Number>();
			var	rawIndex:Vector.<uint> = new Vector.<uint>();
			var	rawNormal:Vector.<Number> = new Vector.<Number>();
			
			var i:int, j:int, k:int;
			var vertex:Vertex;
			var triangle:Triangle;
			var size:int = _numVertices;
			
			for (i = 0; i < _numVertices; i++) {
				vertex = vertices[i];
				// vertex
				j = i * 3;
				rawVertex[j] = vertex.x;
				rawVertex[j + 1] = vertex.y;
				rawVertex[j + 2] = vertex.z;
				// normal
				rawNormal[j] = vertex.normal.x;
				rawNormal[j + 1] = vertex.normal.y;
				rawNormal[j + 2] = vertex.normal.z;
				// uv
				j = i * 2;
				rawUV[j] = vertex.u;
				rawUV[j + 1] = vertex.v;
			}
			
			for (i = 0; i < _numTriangles; i++) {
				triangle = triangles[i];
				// index
				j = i * 3;
				
				vertex = vertices[triangle.index0];
				if (triangle.u0 != vertex.u || triangle.v0 != vertex.v) {
					rawIndex[j] = size;
					
					k = size * 3;
					// vertex
					rawVertex[k] = vertex.x;
					rawVertex[k + 1] = vertex.y;
					rawVertex[k + 2] = vertex.z;
					// normal
					rawNormal[k] = vertex.normal.x;
					rawNormal[k + 1] = vertex.normal.y;
					rawNormal[k + 2] = vertex.normal.z;
					// uv
					k = size * 2;
					rawUV[k] = triangle.u0;
					rawUV[k + 1] = triangle.v0;
					
					size++;
				} else {
					rawIndex[j] = triangle.index0;
				}
				
				vertex = vertices[triangle.index1];
				if (triangle.u1 != vertex.u || triangle.v1 != vertex.v) {
					rawIndex[j + 1] = size;
					
					k = size * 3;
					// vertex
					rawVertex[k] = vertex.x;
					rawVertex[k + 1] = vertex.y;
					rawVertex[k + 2] = vertex.z;
					// normal
					rawNormal[k] = vertex.normal.x;
					rawNormal[k + 1] = vertex.normal.y;
					rawNormal[k + 2] = vertex.normal.z;
					// uv
					k = size * 2;
					rawUV[k] = triangle.u1;
					rawUV[k + 1] = triangle.v1;
					
					size++;
				} else {
					rawIndex[j + 1] = triangle.index1;
				}
				
				vertex = vertices[triangle.index2];
				if (triangle.u2 != vertex.u || triangle.v2 != vertex.v) {
					rawIndex[j + 2] = size;
					
					k = size * 3;
					// vertex
					rawVertex[k] = vertex.x;
					rawVertex[k + 1] = vertex.y;
					rawVertex[k + 2] = vertex.z;
					// normal
					rawNormal[k] = vertex.normal.x;
					rawNormal[k + 1] = vertex.normal.y;
					rawNormal[k + 2] = vertex.normal.z;
					// uv
					k = size * 2;
					rawUV[k] = triangle.u2;
					rawUV[k + 1] = triangle.v2;
					
					size++;
				} else {
					rawIndex[j + 2] = triangle.index2;
				}
			}
			
			if (flag) {
				var context3d:Context3D = ViewPort.context3d;
				if (_vertexBuffer)_vertexBuffer.dispose();
				_vertexBuffer = context3d.createVertexBuffer(size, 3);
				if (_uvBuffer)_uvBuffer.dispose();
				_uvBuffer = context3d.createVertexBuffer(size, 2);
				if (_normalBuffer)_normalBuffer.dispose();
				_normalBuffer = context3d.createVertexBuffer(size, 3);
				if (_indexBuffer)_indexBuffer.dispose();
				_indexBuffer = context3d.createIndexBuffer(_numIndices);
			}
			
			_vertexBuffer.uploadFromVector(rawVertex, 0, size);
			_uvBuffer.uploadFromVector(rawUV, 0, size);
			_normalBuffer.uploadFromVector(rawNormal, 0, size);
			_indexBuffer.uploadFromVector(rawIndex, 0, _numIndices);
		}
		
		public function upload(uv:Boolean, normal:Boolean):void {
			var context3d:Context3D = ViewPort.context3d;
			context3d.setVertexBufferAt(0, _vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			if (uv) context3d.setVertexBufferAt(1, _uvBuffer, 0, Context3DVertexBufferFormat.FLOAT_2);
			if (normal) context3d.setVertexBufferAt(2, _normalBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
		}
		
		public function unload():void {
			var context3d:Context3D = ViewPort.context3d;
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