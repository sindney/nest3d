package nest.control.factories
{
	import flash.geom.Vector3D;
	
	import nest.object.data.MeshData;
	import nest.object.geom.Vertex;
	import nest.object.geom.Triangle;
	
	/**
	 * PrimitiveFactory
	 * <p>Util class to create primitive objects.</p>
	 * <p>Like Cube, Plane, Sphere, etc</p>
	 */
	public final class PrimitiveFactory {
		
		public static function createBox(width:Number = 100, height:Number = 100, depth:Number = 100):MeshData {
			const w2:Number = width / 2;
			const h2:Number = height / 2;
			const d2:Number = depth / 2;
			
			var tri:Triangle;
			var vertices:Vector.<Vertex> = new Vector.<Vertex>(8, true);
			var triangles:Vector.<Triangle> = new Vector.<Triangle>(12, true);
			
			vertices[0] = new Vertex( -w2, h2, -d2, 0, 0);
			vertices[1] = new Vertex(w2, h2, -d2, 1, 0);
			vertices[2] = new Vertex(w2, -h2, -d2, 1, 1);
			vertices[3] = new Vertex( -w2, -h2, -d2, 0, 1);
			
			vertices[4] = new Vertex(w2, h2, d2, 0, 0);
			vertices[5] = new Vertex( -w2, h2, d2, 1, 0);
			vertices[6] = new Vertex( -w2, -h2, d2, 1, 1);
			vertices[7] = new Vertex(w2, -h2, d2, 0, 1);
			
			// front
			tri = triangles[0] = new Triangle(0, 1, 2);
			tri.u0 = 0; tri.v0 = 0;
			tri.u1 = 1; tri.v1 = 0;
			tri.u2 = 1; tri.v2 = 1;
			tri = triangles[1] = new Triangle(0, 2, 3);
			tri.u0 = 0; tri.v0 = 0;
			tri.u1 = 1; tri.v1 = 1;
			tri.u2 = 0; tri.v2 = 1;
			
			// back
			tri = triangles[2] = new Triangle(4, 5, 6);
			tri.u0 = 0; tri.v0 = 0;
			tri.u1 = 1; tri.v1 = 0;
			tri.u2 = 1; tri.v2 = 1;
			tri = triangles[3] = new Triangle(4, 6, 7);
			tri.u0 = 0; tri.v0 = 0;
			tri.u1 = 1; tri.v1 = 1;
			tri.u2 = 0; tri.v2 = 1;
			
			// top
			tri = triangles[4] = new Triangle(5, 4, 1);
			tri.u0 = 0; tri.v0 = 0;
			tri.u1 = 1; tri.v1 = 0;
			tri.u2 = 1; tri.v2 = 1;
			tri = triangles[5] = new Triangle(5, 1, 0);
			tri.u0 = 0; tri.v0 = 0;
			tri.u1 = 1; tri.v1 = 1;
			tri.u2 = 0; tri.v2 = 1;
			
			// bottom
			tri = triangles[6] = new Triangle(7, 6, 3);
			tri.u0 = 0; tri.v0 = 0;
			tri.u1 = 1; tri.v1 = 0;
			tri.u2 = 1; tri.v2 = 1;
			tri = triangles[7] = new Triangle(7, 3, 2);
			tri.u0 = 0; tri.v0 = 0;
			tri.u1 = 1; tri.v1 = 1;
			tri.u2 = 0; tri.v2 = 1;
			
			// left
			tri = triangles[8] = new Triangle(5, 0, 3);
			tri.u0 = 0; tri.v0 = 0;
			tri.u1 = 1; tri.v1 = 0;
			tri.u2 = 1; tri.v2 = 1;
			tri = triangles[9] = new Triangle(5, 3, 6);
			tri.u0 = 0; tri.v0 = 0;
			tri.u1 = 1; tri.v1 = 1;
			tri.u2 = 0; tri.v2 = 1;
			
			// right
			tri = triangles[10] = new Triangle(1, 4, 7);
			tri.u0 = 0; tri.v0 = 0;
			tri.u1 = 1; tri.v1 = 0;
			tri.u2 = 1; tri.v2 = 1;
			tri = triangles[11] = new Triangle(1, 7, 2);
			tri.u0 = 0; tri.v0 = 0;
			tri.u1 = 1; tri.v1 = 1;
			tri.u2 = 0; tri.v2 = 1;
			
			MeshData.calculateNormal(vertices, triangles);
			return new MeshData(vertices, triangles);
		}
		
		public static function createPlane(width:Number = 100, height:Number = 100, segmentsW:int = 1, segmentsH:int = 1):MeshData {
			const w2:Number = width / 2;
			const h2:Number = height / 2;
			const dw:Number = width / segmentsW;
			const dh:Number = height / segmentsH;
			const du:Number = 1 / segmentsW;
			const dv:Number = 1 / segmentsH;
			const s:int = (segmentsW + 1) * (segmentsH + 1);
			
			var p1:int, p2:int, p3:int, p4:int;
			var i:int, j:int, k:int, l:int = 0;
			var n1:Vector3D = new Vector3D();
			var n2:Vector3D = new Vector3D();
			var vertices:Vector.<Vertex> = new Vector.<Vertex>(s, true);
			var triangles:Vector.<Triangle> = new Vector.<Triangle>(segmentsW * segmentsH * 2, true);
			
			for (i = 0; i < segmentsW; i++) {
				for (j = 0; j < segmentsH; j++) {
					k = i * (segmentsH + 1) + j;
					
					p1 = k;
					p2 = k + 1;
					p3 = k + segmentsH + 1;
					p4 = k + segmentsH + 2;
					
					triangles[l] = new Triangle(p1, p4, p3);
					triangles[l + 1] = new Triangle(p1, p2, p4);
					
					if (!vertices[p1]) vertices[p1] = new Vertex(i * dw - w2,       0, j * dh - h2,       i * du,       (j + 1) * dv);
					if (!vertices[p2]) vertices[p2] = new Vertex(i * dw - w2,       0, (j + 1) * dh - h2, i * du,       j * dv      );
					if (!vertices[p3]) vertices[p3] = new Vertex((i + 1) * dw - w2, 0, j * dh - h2,       (i + 1) * du, (j + 1) * dv);
					if (!vertices[p4]) vertices[p4] = new Vertex((i + 1) * dw - w2, 0, (j + 1) * dh - h2, (i + 1) * du, j * dv      );
					
					triangles[l].u0 = vertices[p1].u;
					triangles[l].v0 = vertices[p1].v;
					triangles[l].u1 = vertices[p4].u;
					triangles[l].v1 = vertices[p4].v;
					triangles[l].u2 = vertices[p3].u;
					triangles[l].v2 = vertices[p3].v;
					
					triangles[l + 1].u0 = vertices[p1].u;
					triangles[l + 1].v0 = vertices[p1].v;
					triangles[l + 1].u1 = vertices[p2].u;
					triangles[l + 1].v1 = vertices[p2].v;
					triangles[l + 1].u2 = vertices[p4].u;
					triangles[l + 1].v2 = vertices[p4].v;
					
					l += 2;
				}
			}
			
			MeshData.calculateNormal(vertices, triangles);
			return new MeshData(vertices, triangles);
		}
		
		public static function createSphere(radius:Number = 100, segmentsW:int = 8, segmentsH:int = 6):MeshData {
			const du:Number = 1 / segmentsW;
			const dv:Number = 1 / segmentsH;
			const da:Number = -Math.PI / segmentsH;
			const db:Number = Math.PI * 2 / segmentsW;
			const s:int = (segmentsW + 1) * (segmentsH + 1);
			
			var a:Number = Math.PI / 2;
			var b:Number = 0;
			var i:int, j:int, k:int, l:int = 0;
			var p1:int, p2:int, p3:int, p4:int;
			var vertices:Vector.<Vertex> = new Vector.<Vertex>(s, true);
			var triangles:Vector.<Triangle> = new Vector.<Triangle>(segmentsW * segmentsH * 2, true);
			
			for (i = 0; i < segmentsW; i++ ) {
				a = Math.PI / 2;
				for (j = 0; j < segmentsH; j++) {
					k = i * (segmentsH + 1) + j;
					
					p1 = k;
					p2 = k + 1;
					p3 = k + segmentsH + 1;
					p4 = k + segmentsH + 2;
					
					triangles[l] = new Triangle(p1, p4, p3);
					triangles[l + 1] = new Triangle(p1, p2, p4);
					
					if (!vertices[p1]) vertices[p1] = new Vertex(radius * Math.cos(a) * Math.sin(b), radius * Math.sin(a), radius * Math.cos(a) * Math.cos(b), i * du, j * dv);
					if (!vertices[p2]) vertices[p2] = new Vertex(radius * Math.cos(a + da) * Math.sin(b), radius * Math.sin(a + da), radius * Math.cos(a + da) * Math.cos(b), i * du, (j + 1) * dv);
					if (!vertices[p3]) vertices[p3] = new Vertex(radius * Math.cos(a) * Math.sin(b + db), radius * Math.sin(a), radius * Math.cos(a) * Math.cos(b + db), (i + 1) * du, j * dv);
					if (!vertices[p4]) vertices[p4] = new Vertex(radius * Math.cos(a + da) * Math.sin(b + db), radius * Math.sin(a + da), radius * Math.cos(a + da) * Math.cos(b + db), (i + 1) * du, (j + 1) * dv);
					a += da;
					
					triangles[l].u0 = vertices[p1].u;
					triangles[l].v0 = vertices[p1].v;
					triangles[l].u1 = vertices[p4].u;
					triangles[l].v1 = vertices[p4].v;
					triangles[l].u2 = vertices[p3].u;
					triangles[l].v2 = vertices[p3].v;
					
					triangles[l + 1].u0 = vertices[p1].u;
					triangles[l + 1].v0 = vertices[p1].v;
					triangles[l + 1].u1 = vertices[p2].u;
					triangles[l + 1].v1 = vertices[p2].v;
					triangles[l + 1].u2 = vertices[p4].u;
					triangles[l + 1].v2 = vertices[p4].v;
					
					l += 2;
				}
				
				b += db;
			}
			
			MeshData.calculateNormal(vertices, triangles);
			return new MeshData(vertices, triangles);
		}
		
	}

}