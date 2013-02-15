package nest.control.util 
{
	import flash.display3D.IndexBuffer3D;
	import flash.geom.Vector3D;
	
	import nest.object.geom.Geometry;
	import nest.object.geom.Triangle;
	import nest.object.geom.Vertex;
	import nest.view.ViewPort;
	
	public class GeometryUtil {
		
		public static function uploadGeometry(geom:Geometry, indexed:Boolean = false, vertex:int = 0, normal:int = -1, uv:int = -1, indices:int = -1, weights:int = -1):void {
			geom.numVertices = geom.vertices.length;
			geom.numTriangles = geom.triangles.length;
			geom.numIndices = geom.numTriangles * 3;

			var bNormal:Boolean = normal != -1;
			var bUV:Boolean = uv != -1;

			var rawVertex:Vector.<Number> = new Vector.<Number>();
			var	rawNormal:Vector.<Number>;
			var	rawUV:Vector.<Number>;
			var	rawIndex:Vector.<uint> = new Vector.<uint>();
			var rawIndices:Vector.<uint>;
			var rawWeights:Vector.<Number>;

			if (bNormal) rawNormal = new Vector.<Number>();
			if (bUV) rawUV = new Vector.<Number>();
			if (indexed) {
				rawIndices = new Vector.<uint>();
				rawWeights = new Vector.<Number>();
			}

			var i:int, j:int, k:int;
			var v0:Vertex, v1:Vertex, v2:Vertex;
			var triangle:Triangle;
			
			for (i = 0; i < geom.numVertices; i++) {
				v0 = geom.vertices[i];
				// vertex
				j = i * 3;
				rawVertex[j] = v0.x;
				rawVertex[j + 1] = v0.y;
				rawVertex[j + 2] = v0.z;
				// normal
				if (bNormal) {
					rawNormal[j] = v0.normal.x;
					rawNormal[j + 1] = v0.normal.y;
					rawNormal[j + 2] = v0.normal.z;
				}
				// uv
				if (bUV) {
					j = i * 2;
					rawUV[j] = v0.u;
					rawUV[j + 1] = v0.v;
				}
				if (indexed) {
					// indices
					j = i * 4;
					rawIndices[j] = v0.indices[0];
					rawIndices[j + 1] = v0.indices[1];
					rawIndices[j + 2] = v0.indices[2];
					rawIndices[j + 3] = v0.indices[3];
					// weights
					rawWeights[j] = v0.weights[0];
					rawWeights[j + 1] = v0.weights[1];
					rawWeights[j + 2] = v0.weights[2];
					rawWeights[j + 3] = v0.weights[3];
				}
			}
			
			geom.vertexBuffers[vertex].uploadFromVector(rawVertex, vertex, geom.numVertices);
			if (bUV) geom.vertexBuffers[uv].uploadFromVector(rawUV, uv, geom.numVertices);
			if (bNormal) geom.vertexBuffers[normal].uploadFromVector(rawNormal, normal, geom.numVertices);
			if (indexed) {
				geom.vertexBuffers[indices].uploadFromVector(rawIndices), indices, geom.numVertices);
				geom.vertexBuffers[weights].uploadFromVector(rawWeights), weights, geom.numVertices);
				var temp0:Vector.<Vector.<uint>> = new Vector.<Vector.<uint>>();
				var temp1:Vector.<Vector>;
				for (i = 0; i < geom.numTriangles; i++) {
					tri = geom.triangles[i];
					v0 = geom.vertices[tri.index0];
					v1 = geom.vertices[tri.index1];
					v2 = geom.vertices[tri.index2];
					for (j = 0; j < 4; j++) {
						temp1 = temp0[v0.indices[j]];
						if (!temp1) temp1 = new Vector.<uint>();
						temp1.push(tri.index0);
						temp1 = temp0[v1.indices[j]];
						if (!temp1) temp1 = new Vector.<uint>();
						temp1.push(tri.index1);
						temp1 = temp0[v2.indices[j]];
						if (!temp1) temp1 = new Vector.<uint>();
						temp1.push(tri.index2);
					}
				}
				var indexBuffer:IndexBuffer3D;
				j = temp0.length;
				for (i = 0; i < j; i++) {
					temp1 = temp0[i];
					k = temp1.length;
					indexBuffer = ViewPort.context3d.createIndexBuffer(k);
					indexBuffer.uploadFromVector(temp1, 0, k);
					geom.indexBuffers.push(indexBuffer);
				}
			} else {
				for (i = 0; i < geom.numTriangles; i++) {
					triangle = geom.triangles[i];
					j = i * 3;
					rawIndex[j] = triangle.index0;
					rawIndex[j + 1] = triangle.index1;
					rawIndex[j + 2] = triangle.index2;
				}
				geom.indexBuffers[0].uploadFromVector(rawIndex, 0, geom.numIndices);
			}
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

	}
}