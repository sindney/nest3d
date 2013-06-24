package nest.object
{
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.VertexBuffer3D;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import nest.object.IMesh;
	import nest.view.ViewPort;
	
	/**
	 * Geometry
	 * <p>When you use calculateNormal/Tangent(), make sure you'v setup the geometry using setupGeometry().</p>
	 */
	public class Geometry {
		
		public static function setupGeometry(geom:Geometry, vertex:Boolean = true, normal:Boolean = true, tangent:Boolean = true, uv:Boolean = true):void {
			geom.numVertices = geom.vertices.length / 3;
			geom.numTriangles = geom.indices.length / 3;
			
			if (geom.vertexBuffer) {
				geom.vertexBuffer.dispose();
				geom.vertexBuffer = null;
			}
			
			if (geom.normalBuffer) {
				geom.normalBuffer.dispose();
				geom.normalBuffer = null;
			}
			
			if (geom.tangentBuffer) {
				geom.tangentBuffer.dispose();
				geom.tangentBuffer = null;
			}
			
			if (geom.uvBuffer) {
				geom.uvBuffer.dispose();
				geom.uvBuffer = null;
			}
			
			if (geom.indexBuffer) {
				geom.indexBuffer.dispose();
				geom.indexBuffer = null;
			}
			
			if (vertex) geom.vertexBuffer = ViewPort.context3d.createVertexBuffer(geom.numVertices, 3);
			if (normal) geom.normalBuffer = ViewPort.context3d.createVertexBuffer(geom.numVertices, 3);
			if (tangent) geom.tangentBuffer = ViewPort.context3d.createVertexBuffer(geom.numVertices, 3);
			if (uv) geom.uvBuffer = ViewPort.context3d.createVertexBuffer(geom.numVertices, 2);
			geom.indexBuffer = ViewPort.context3d.createIndexBuffer(geom.numTriangles * 3);
		}
		
		public static function uploadGeometry(geom:Geometry, vertex:Boolean = true, normal:Boolean = true, tangent:Boolean = true, uv:Boolean = true, index:Boolean = true):void {
			if (vertex) geom.vertexBuffer.uploadFromVector(geom.vertices, 0, geom.numVertices);
			if (normal) geom.normalBuffer.uploadFromVector(geom.normals, 0, geom.numVertices);
			if (tangent) geom.tangentBuffer.uploadFromVector(geom.tangents, 0, geom.numVertices);
			if (uv) geom.uvBuffer.uploadFromVector(geom.uvs, 0, geom.numVertices);
			if (index) geom.indexBuffer.uploadFromVector(geom.indices, 0, geom.numTriangles * 3);
		}
		
		public static function calculateNormal(geom:Geometry):void {
			if (!geom.normals) geom.normals = new Vector.<Number>(geom.numVertices * 3, true);
			
			var i:int, j:int;
			var a:int, b:int, c:int;
			var x1:Number, y1:Number, z1:Number;
			var x2:Number, y2:Number, z2:Number;
			var x3:Number, y3:Number, z3:Number;
			var vt1:Vector3D = new Vector3D();
			var vt2:Vector3D = new Vector3D();
			
			for (i = 0; i < geom.numTriangles; i++) {
				j = i * 3;
				a = geom.indices[j] * 3;
				x1 = geom.vertices[a];
				y1 = geom.vertices[a + 1];
				z1 = geom.vertices[a + 2];
				b = geom.indices[j + 1] * 3;
				x2 = geom.vertices[b];
				y2 = geom.vertices[b + 1];
				z2 = geom.vertices[b + 2];
				c = geom.indices[j + 2] * 3;
				x3 = geom.vertices[c];
				y3 = geom.vertices[c + 1];
				z3 = geom.vertices[c + 2];
				
				vt1.setTo(x2 - x1, y2 - y1, z2 - z1);
				vt2.setTo(x3 - x2, y3 - y2, z3 - z2);
				vt1 = vt1.crossProduct(vt2);
				vt1.normalize();
				
				geom.normals[a] += vt1.x;
				geom.normals[a + 1] += vt1.y;
				geom.normals[a + 2] += vt1.z;
				geom.normals[b] += vt1.x;
				geom.normals[b + 1] += vt1.y;
				geom.normals[b + 2] += vt1.z;
				geom.normals[c] += vt1.x;
				geom.normals[c + 1] += vt1.y;
				geom.normals[c + 2] += vt1.z;
			}
			
			for (i = 0; i < geom.numVertices; i++) {
				j = i * 3;
				x3 = geom.normals[j];
				y3 = geom.normals[j + 1];
				z3 = geom.normals[j + 2];
				x1 = 1 / Math.sqrt(x3 * x3 + y3 * y3 + z3 * z3);
				geom.normals[j] *= x1;
				geom.normals[j + 1] *= x1;
				geom.normals[j + 2] *= x1;
			}
		}
		
		public static function calculateTangent(geom:Geometry):void {
			if (!geom.tangents) geom.tangents = new Vector.<Number>(geom.numVertices * 3, true);
			
			var i:int, j:int;
			var a:int, b:int, c:int, d:int;
			var u1:Number, u2:Number, u3:Number;
			var v1:Number, v2:Number, v3:Number;
			var p1:Vector3D = new Vector3D();
			var p2:Vector3D = new Vector3D();
			var p3:Vector3D = new Vector3D();
			var p4:Vector3D, p5:Vector3D;
			
			for (i = 0; i < geom.numTriangles; i++) {
				j = i * 3;
				a = geom.indices[j] * 3;
				p1.x = geom.vertices[a];
				p1.y = geom.vertices[a + 1];
				p1.z = geom.vertices[a + 2];
				b = geom.indices[j + 1] * 3;
				p2.x = geom.vertices[b];
				p2.y = geom.vertices[b + 1];
				p2.z = geom.vertices[b + 2];
				c = geom.indices[j + 2] * 3;
				p3.x = geom.vertices[c];
				p3.y = geom.vertices[c + 1];
				p3.z = geom.vertices[c + 2];
				
				d = geom.indices[j] * 2;
				u1 = geom.uvs[d];
				v1 = geom.uvs[d + 1];
				d = geom.indices[j + 1] * 2;
				u2 = geom.uvs[d];
				v2 = geom.uvs[d + 1];
				d = geom.indices[j + 2] * 2;
				u3 = geom.uvs[d];
				v3 = geom.uvs[d + 1];
				
				p4 = p2.clone();
				p4.decrementBy(p1);
				p4.scaleBy(v3 - v1);
				p5 = p3.clone();
				p5.decrementBy(p1);
				p5.scaleBy(v2 - v1);
				p4.decrementBy(p5);
				p4.scaleBy(1 / ((u2 - u1) * (v3 - v1) - (v2 - v1) * (u3 - u1)));
				
				geom.tangents[a] += p4.x;
				geom.tangents[a + 1] += p4.y;
				geom.tangents[a + 2] += p4.z;
				geom.tangents[b] += p4.x;
				geom.tangents[b + 1] += p4.y;
				geom.tangents[b + 2] += p4.z;
				geom.tangents[c] += p4.x;
				geom.tangents[c + 1] += p4.y;
				geom.tangents[c + 2] += p4.z;
			}
			
			for (i = 0; i < geom.numVertices; i++) {
				j = i * 3;
				v1 = geom.tangents[j];
				v2 = geom.tangents[j + 1];
				v3 = geom.tangents[j + 2];
				u1 = 1 / Math.sqrt(v1 * v1 + v2 * v2 + v3 * v3);
				geom.tangents[j] *= u1;
				geom.tangents[j + 1] *= u1;
				geom.tangents[j + 2] *= u1;
			}
		}
		
		public static function transformGeometry(geom:Geometry, matrix:Matrix3D):void {
			var i:int, j:int;
			var tmp:Vector3D = new Vector3D();
			for (i = 0; i < geom.numVertices; i++) {
				j = i * 3;
				tmp.x = geom.vertices[j];
				tmp.y = geom.vertices[j + 1];
				tmp.z = geom.vertices[j + 2];
				tmp = matrix.transformVector(tmp);
				geom.vertices[j] = tmp.x;
				geom.vertices[j + 1] = tmp.y;
				geom.vertices[j + 2] = tmp.z;
				if (geom.normals) {
					tmp.x = geom.normals[j];
					tmp.y = geom.normals[j + 1];
					tmp.z = geom.normals[j + 2];
					tmp = matrix.transformVector(tmp);
					tmp.normalize();
					geom.normals[j] = tmp.x;
					geom.normals[j + 1] = tmp.y;
					geom.normals[j + 2] = tmp.z;
				}
				if (geom.tangents) {
					tmp.x = geom.tangents[j];
					tmp.y = geom.tangents[j + 1];
					tmp.z = geom.tangents[j + 2];
					tmp = matrix.transformVector(tmp);
					tmp.normalize();
					geom.tangents[j] = tmp.x;
					geom.tangents[j + 1] = tmp.y;
					geom.tangents[j + 2] = tmp.z;
				}
			}
		}
		
		public static function calculateBound(geom:Geometry):void {
			var max:Vector3D = geom.max;
			var min:Vector3D = geom.min;
			var i:int, j:int;
			var a:Number;
			max.setTo(0, 0, 0);
			min.setTo(0, 0, 0);
			for (i = 0; i < geom.numVertices; i++) {
				j = i * 3;
				a = geom.vertices[j];
				if (a > max.x) max.x = a;
				else if (a < min.x) min.x = a;
				a = geom.vertices[j + 1];
				if (a > max.y) max.y = a;
				else if (a < min.y) min.y = a;
				a = geom.vertices[j + 2];
				if (a > max.z) max.z = a;
				else if (a < min.z) min.z = a;
			}
		}
		
		public var name:String;
		
		public var vertexBuffer:VertexBuffer3D;
		public var normalBuffer:VertexBuffer3D;
		public var tangentBuffer:VertexBuffer3D;
		public var uvBuffer:VertexBuffer3D;
		public var indexBuffer:IndexBuffer3D;
		
		public var vertices:Vector.<Number>;
		public var normals:Vector.<Number>;
		public var tangents:Vector.<Number>;
		public var uvs:Vector.<Number>;
		public var indices:Vector.<uint>;
		
		public var max:Vector3D = new Vector3D();
		public var min:Vector3D = new Vector3D();
		
		public var numVertices:int = 0;
		public var numTriangles:int = 0;
		
		public function dispose():void {
			if (vertexBuffer) vertexBuffer.dispose();
			vertexBuffer = null;
			if (normalBuffer) normalBuffer.dispose();
			normalBuffer = null;
			if (tangentBuffer) tangentBuffer.dispose();
			tangentBuffer = null;
			if (uvBuffer) uvBuffer.dispose();
			uvBuffer = null;
			if (indexBuffer) indexBuffer.dispose();
			indexBuffer = null;
			name = null;
			vertices = null;
			normals = null;
			tangents = null;
			uvs = null;
			indices = null;
			max = min = null;
			numVertices = numTriangles = 0;
		}
		
	}

}