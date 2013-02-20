package nest.object.geom
{
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.VertexBuffer3D;
	import flash.geom.Vector3D;
	
	import nest.view.ViewPort;
	
	/**
	 * Geometry
	 */
	public class Geometry {
		
		public static function setupGeometry(geom:Geometry, vertex:Boolean = true, normal:Boolean = true, uv:Boolean = true):void {
			geom.numVertices = geom.vertices.length;
			geom.numTriangles = geom.triangles.length;
			geom.numIndices = geom.numTriangles * 3;
			
			var i:int, j:int, k:int, size:int = geom.numVertices;
			var t0:Triangle;
			var v0:Vertex;
			if (uv) {
				for (i = 0; i < geom.numTriangles; i++) {
					t0 = geom.triangles[i];
					for (j = 0; j < 3; j++) {
						v0 = geom.vertices[t0.indices[j]];
						k = j * 2;
						if (t0.uvs[k] != v0.u || t0.uvs[k + 1] != v0.v) size++;
					}
				}
			}
			
			if (geom.vertexBuffer) {
				geom.vertexBuffer.dispose();
				geom.vertexBuffer = null;
			}
			
			if (geom.normalBuffer) {
				geom.normalBuffer.dispose();
				geom.normalBuffer = null;
			}
			
			if (geom.uvBuffer) {
				geom.uvBuffer.dispose();
				geom.uvBuffer = null;
			}
			
			if (geom.indexBuffer) {
				geom.indexBuffer.dispose();
				geom.indexBuffer = null;
			}
			
			if (vertex) geom.vertexBuffer = ViewPort.context3d.createVertexBuffer(size, 3);
			if (normal) geom.normalBuffer = ViewPort.context3d.createVertexBuffer(size, 3);
			if (uv) geom.uvBuffer = ViewPort.context3d.createVertexBuffer(size, 2);
			geom.indexBuffer = ViewPort.context3d.createIndexBuffer(geom.numIndices);
		}
		
		public static function uploadGeometry(geom:Geometry, vertex:Boolean = true, normal:Boolean = true, uv:Boolean = true, index:Boolean = true):void {
			var rawVertex:Vector.<Number>;
			var	rawNormal:Vector.<Number>;
			var	rawUV:Vector.<Number>;
			var	rawIndex:Vector.<uint>;
			
			if (vertex) rawVertex = new Vector.<Number>();
			if (normal) rawNormal = new Vector.<Number>();
			if (uv) rawUV = new Vector.<Number>();
			if (index) rawIndex = new Vector.<uint>();
			
			var i:int, j:int, k:int, l:int, m:int;
			var v0:Vertex;
			var t0:Triangle;
			var changed:Boolean = (vertex || normal || uv);
			var size:int = geom.numVertices;
			
			if(changed) {
				for (i = 0; i < size; i++) {
					v0 = geom.vertices[i];
					j = i * 3;
					// vertex
					if (vertex) {
						rawVertex[j] = v0.x;
						rawVertex[j + 1] = v0.y;
						rawVertex[j + 2] = v0.z;
					}
					// normal
					if (normal) {
						rawNormal[j] = v0.nx;
						rawNormal[j + 1] = v0.ny;
						rawNormal[j + 2] = v0.nz;
					}
					// uv
					if (uv) {
						j = i * 2;
						rawUV[j] = v0.u;
						rawUV[j + 1] = v0.v;
					}
				}
			}
			
			if (changed || index) {
				for (i = 0; i < geom.numTriangles; i++) {
					t0 = geom.triangles[i];
					j = i * 3;
					for (k = 0; k < 3; k++) {
						v0 = geom.vertices[t0.indices[k]];
						l = k * 2;
						if (uv && (t0.uvs[l] != v0.u || t0.uvs[l + 1] != v0.v)) {
							rawIndex[j + k] = size;
							m = size * 3;
							if (vertex) {
								rawVertex[m] = v0.x;
								rawVertex[m + 1] = v0.y;
								rawVertex[m + 2] = v0.z;
							}
							if (normal) {
								rawNormal[m] = v0.nx;
								rawNormal[m + 1] = v0.ny;
								rawNormal[m + 2] = v0.nz;
							}
							m = size * 2;
							rawUV[m] = t0.uvs[l];
							rawUV[m + 1] = t0.uvs[l + 1];
							size++;
						} else {
							rawIndex[j + k] = t0.indices[k];
						}
					}
				}
				geom.indexBuffer.uploadFromVector(rawIndex, 0, geom.numIndices);
			}
			
			if (vertex) geom.vertexBuffer.uploadFromVector(rawVertex, 0, size);
			if (normal) geom.normalBuffer.uploadFromVector(rawNormal, 0, size);
			if (uv) geom.uvBuffer.uploadFromVector(rawUV, 0, size);
		}
		
		public static function calculateNormal(vertices:Vector.<Vertex>, triangles:Vector.<Triangle>):void {
			var i:int, j:int;
			var tri:Triangle;
			var v1:Vertex, v2:Vertex, v3:Vertex;
			var vt1:Vector3D = new Vector3D();
			var vt2:Vector3D = new Vector3D();
			
			j = triangles.length;
			for (i = 0; i < j; i++) {
				tri = triangles[i];
				v1 = vertices[tri.indices[0]];
				v2 = vertices[tri.indices[1]];
				v3 = vertices[tri.indices[2]];
				
				vt1.setTo(v2.x - v1.x, v2.y - v1.y, v2.z - v1.z);
				vt2.setTo(v3.x - v2.x, v3.y - v2.y, v3.z - v2.z);
				vt1 = vt1.crossProduct(vt2);
				vt1.normalize();
				
				v1.nx += vt1.x;
				v1.ny += vt1.y;
				v1.nz += vt1.z;
				v2.nx += vt1.x;
				v2.ny += vt1.y;
				v2.nz += vt1.z;
				v3.nx += vt1.x;
				v3.ny += vt1.y;
				v3.nz += vt1.z;
			}
			
			var mag:Number;
			j = vertices.length;
			for (i = 0; i < j; i++) {
				v1 = vertices[i];
				mag = 1 / Math.sqrt(v1.nx * v1.nx + v1.ny * v1.ny + v1.nz * v1.nz);
				v1.nx *= mag;
				v1.ny *= mag;
				v1.nz *= mag;
			}
		}
		
		public var vertexBuffer:VertexBuffer3D;
		public var normalBuffer:VertexBuffer3D;
		public var uvBuffer:VertexBuffer3D;
		public var indexBuffer:IndexBuffer3D;
		
		public var numVertices:int = 0;
		public var numIndices:int = 0;
		public var numTriangles:int = 0;
		
		public var vertices:Vector.<Vertex>;
		public var triangles:Vector.<Triangle>;
		
		public function Geometry(vertices:Vector.<Vertex>, triangles:Vector.<Triangle>) {
			this.vertices = vertices;
			this.triangles = triangles;
		}
		
		public function dispose():void {
			if (vertexBuffer) vertexBuffer.dispose();
			vertexBuffer = null;
			if (normalBuffer) normalBuffer.dispose();
			normalBuffer = null;
			if (uvBuffer) uvBuffer.dispose();
			uvBuffer = null;
			if (indexBuffer) indexBuffer.dispose();
			indexBuffer = null;
			vertices = null;
			triangles = null;
		}
		
	}

}