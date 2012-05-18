package nest.control.factories
{
	import nest.object.data.MeshData;
	import nest.object.geom.Vertex;
	import nest.object.geom.Triangle;
	
	/**
	 * PrimitiveFactory
	 * <p>Util class to create primitive objects.</p>
	 * <p>Like Cube, Plane, Sphere, etc</p>
	 */
	public final class PrimitiveFactory {
		
		public static function createBox(width:Number = 100, height:Number = 100, depth:Number = 100, segmentsW:uint = 1, segmentsH:uint = 1, segmentsD:uint = 1):MeshData {
			const w2:Number = width / 2;
			const h2:Number = height / 2;
			const d2:Number = depth / 2;
			const dw:Number = width / segmentsW;
			const dh:Number = height / segmentsH;
			const dd:Number = depth / segmentsD;
			var i:int, j:int, k:int, l:int;
			var du:Number, dv:Number;
			var p1:int, p2:int, p3:int, p4:int;
			var s:int = 2 * ((segmentsH + 1) * (segmentsD + 1) + (segmentsH + 1) * (segmentsW + 1) + (segmentsD + 1) * (segmentsW + 1));
			var vertices:Vector.<Vertex> = new Vector.<Vertex>(s, true);
			var triangles:Vector.<Triangle> = new Vector.<Triangle>(4 * (segmentsH * segmentsD + segmentsH * segmentsW + segmentsD * segmentsW));
			//create top
			du = 1 / segmentsW;
			dv = 1 / segmentsD;
			l = 0;
			for (i = 0; i < segmentsW; i++) {
				for (j = 0; j < segmentsD; j++) {
					k = i * (segmentsD + 1) + j;
					
					p1 = k;
					p2 = k + 1;
					p3 = k + segmentsD + 1;
					p4 = k + segmentsD + 2;
					
					triangles[l] = new Triangle(p1, p4, p2);
					triangles[l + 1] = new Triangle(p1, p3, p4);
					l += 2;
					
					if (!vertices[p1]) vertices[p1] = new Vertex(i * dw - w2, h2, d2-j * dd, i * du, j * dv);
					if (!vertices[p2]) vertices[p2] = new Vertex(i * dw - w2, h2, d2-(j + 1) * dd, i * du, (j + 1) * dv);
					if (!vertices[p3]) vertices[p3] = new Vertex((i + 1) * dw - w2, h2,d2-j * dd, (i + 1) * du, j * dv);
					if (!vertices[p4]) vertices[p4] = new Vertex((i + 1) * dw - w2, h2, d2-(j + 1) * dd, (i + 1) * du, (j + 1) * dv);
				}
			}
			//create bottom
			for (i = 0; i < segmentsW; i++) {
				for (j = 0; j < segmentsD; j++) {
					k = (segmentsW + 1) * (segmentsD + 1) + i * (segmentsD + 1) + j;
					
					p1 = k;
					p2 = k + 1;
					p3 = k + segmentsD + 1;
					p4 = k + segmentsD + 2;
					
					triangles[l] = new Triangle(p1, p4, p2);
					triangles[l + 1] = new Triangle(p1, p3, p4);
					l += 2;
					
					if (!vertices[p1]) vertices[p1] = new Vertex(i * dw - w2, -h2, j * dd-d2, i * du, j * dv);
					if (!vertices[p2]) vertices[p2] = new Vertex(i * dw - w2,-h2, (j + 1) * dd-d2, i * du, (j + 1) * dv);
					if (!vertices[p3]) vertices[p3] = new Vertex((i + 1) * dw - w2, -h2, j * dd-d2, (i + 1) * du, j * dv);
					if (!vertices[p4]) vertices[p4] = new Vertex((i + 1) * dw - w2, -h2, (j + 1) * dd-d2, (i + 1) * du, (j + 1) * dv);
				}
			}
			//create left
			du = 1 / segmentsD;
			dv = 1 / segmentsH;
			for (i = 0; i < segmentsD; i++) {
				for (j = 0; j < segmentsH; j++) {
					k = 2 * (segmentsW + 1) * (segmentsD + 1) + i * (segmentsH + 1) + j;
					p1 = k;
					p2 = k + 1;
					p3 = k + segmentsH + 1;
					p4 = k + segmentsH + 2;
					
					triangles[l] = new Triangle(p1, p4, p2);
					triangles[l + 1] = new Triangle(p1, p3, p4);
					l += 2;
					
					if (!vertices[p1]) vertices[p1] = new Vertex( -w2, h2 - j * dh, d2-i * dd, i * du, j * dv);
					if (!vertices[p2]) vertices[p2] = new Vertex( -w2, h2 - (j + 1) * dh, d2-i * dd, i * du, (j + 1) * dv);
					if (!vertices[p3]) vertices[p3] = new Vertex( -w2, h2 - j * dh, d2-(i + 1) * dd, (i + 1) * du, j * dv);
					if (!vertices[p4]) vertices[p4] = new Vertex( -w2, h2 - (j + 1) * dh, d2-(i + 1) * dd, (i + 1) * du, (j + 1) * dv);
				}
			}
			//create right
			for (i = 0; i < segmentsD; i++) {
				for (j = 0; j < segmentsH; j++) {
					k = 2 * (segmentsW + 1) * (segmentsD + 1) + (segmentsD + 1) * (segmentsH + 1) + i * (segmentsH + 1) + j;
					p1 = k;
					p2 = k + 1;
					p3 = k + segmentsH + 1;
					p4 = k + segmentsH + 2;
					
					triangles[l] = new Triangle(p1, p4, p2);
					triangles[l + 1] = new Triangle(p1, p3, p4);
					l += 2;
					
					if (!vertices[p1]) vertices[p1] = new Vertex( w2, h2 - j * dh, i * dd-d2, i * du, j * dv);
					if (!vertices[p2]) vertices[p2] = new Vertex( w2, h2 - (j + 1) * dh, i * dd-d2, i * du, (j + 1) * dv);
					if (!vertices[p3]) vertices[p3] = new Vertex( w2, h2 - j * dh, (i + 1) * dd-d2, (i + 1) * du, j * dv);
					if (!vertices[p4]) vertices[p4] = new Vertex( w2, h2 - (j + 1) * dh, (i + 1) * dd-d2, (i + 1) * du, (j + 1) * dv);
				}
			}
			//create front
			du = 1 / segmentsW;
			dv = 1 / segmentsH;
			for (i = 0; i < segmentsW; i++) {
				for (j = 0; j < segmentsH; j++) {
					k = 2 * (segmentsW + 1) * (segmentsD + 1) + 2 * (segmentsD + 1) * (segmentsH + 1) + i * (segmentsH + 1) + j;
					p1 = k;
					p2 = k + 1;
					p3 = k + segmentsH + 1;
					p4 = k + segmentsH + 2;
					
					triangles[l] = new Triangle(p1, p4, p2);
					triangles[l + 1] = new Triangle(p1, p3, p4);
					l += 2;
					
					if (!vertices[p1]) vertices[p1] = new Vertex(i * dw - w2, h2 - j * dh, -d2, i * du, j * dv);
					if (!vertices[p2]) vertices[p2] = new Vertex(i * dw - w2, h2 - (j+1) * dh, -d2, i * du, (j+1) * dv);
					if (!vertices[p3]) vertices[p3] = new Vertex((i+1) * dw - w2, h2 - j * dh, -d2, (i+1) * du, j * dv);
					if (!vertices[p4]) vertices[p4] = new Vertex((i+1) * dw - w2, h2 - (j+1) * dh, -d2, (i+1) * du, (j+1) * dv);
				}
			}
			//create back
			for (i = 0; i < segmentsW; i++) {
				for (j = 0; j < segmentsH; j++) {
					k = 2 * (segmentsW + 1) * (segmentsD + 1) + 2 * (segmentsD + 1) * (segmentsH + 1) + (segmentsW + 1) * (segmentsH + 1) + i * (segmentsH + 1) + j;
					p1 = k;
					p2 = k + 1;
					p3 = k + segmentsH + 1;
					p4 = k + segmentsH + 2;
					
					triangles[l] = new Triangle(p1, p4, p2);
					triangles[l + 1] = new Triangle(p1, p3, p4);
					l += 2;
					
					if (!vertices[p1]) vertices[p1] = new Vertex(w2 - i * dw, h2 - j * dh, d2, i * du, j * dv);
					if (!vertices[p2]) vertices[p2] = new Vertex(w2 - i * dw, h2 - (j + 1) * dh, d2, i * du, (j + 1) * dv);
					if (!vertices[p3]) vertices[p3] = new Vertex(w2 - (i + 1) * dw, h2 - j * dh, d2, (i + 1) * du, j * dv);
					if (!vertices[p4]) vertices[p4] = new Vertex(w2 - (i + 1) * dw, h2 - (j + 1) * dh, d2, (i + 1) * du, (j + 1) * dv);
				}
			}
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
			
			var vertices:Vector.<Vertex> = new Vector.<Vertex>(s, true);
			var triangles:Vector.<Triangle> = new Vector.<Triangle>(segmentsW * segmentsH * 2, true);
			
			var p1:int, p2:int, p3:int, p4:int;
			var i:int, j:int, k:int, l:int = 0;
			for (i = 0; i < segmentsW; i++) {
				for (j = 0; j < segmentsH; j++) {
					k = i * (segmentsH + 1) + j;
					
					p1 = k;
					p2 = k + 1;
					p3 = k + segmentsH + 1;
					p4 = k + segmentsH + 2;
					
					triangles[l] = new Triangle(p1, p4, p3);
					triangles[l + 1] = new Triangle(p1, p2, p4);
					l += 2;
					
					if (!vertices[p1]) vertices[p1] = new Vertex(i * dw - w2,       0, j * dh - h2,       i * du,       (j + 1) * dv);
					if (!vertices[p2]) vertices[p2] = new Vertex(i * dw - w2,       0, (j + 1) * dh - h2, i * du,       j * dv      );
					if (!vertices[p3]) vertices[p3] = new Vertex((i + 1) * dw - w2, 0, j * dh - h2,       (i + 1) * du, (j + 1) * dv);
					if (!vertices[p4]) vertices[p4] = new Vertex((i + 1) * dw - w2, 0, (j + 1) * dh - h2, (i + 1) * du, j * dv      );
				}
			}
			
			return new MeshData(vertices, triangles);
		}
		
		public static function createSphere(radius:Number = 100, segmentsW:int = 8, segmentsH:int = 6):MeshData {
			var a:Number = Math.PI / 2;
			var b:Number = 0;
			var i:int = 0;
			var j:int = 0;
			var l:int = 0;
			var k:int = 0;
			var p1:int, p2:int, p3:int, p4:int;
			const du:Number = 1 / segmentsW;
			const dv:Number = 1 / segmentsH;
			const da:Number = -Math.PI / segmentsH;
			const db:Number = Math.PI * 2 / segmentsW;
			const s:int = (segmentsW + 1) * (segmentsH + 1);
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
					l += 2;
					
					if (!vertices[p1]) vertices[p1] = new Vertex(radius * Math.cos(a) * Math.sin(b), radius * Math.sin(a), radius * Math.cos(a) * Math.cos(b), i * du, j * dv);
					if (!vertices[p2]) vertices[p2] = new Vertex(radius * Math.cos(a + da) * Math.sin(b), radius * Math.sin(a + da), radius * Math.cos(a + da) * Math.cos(b), i * du, (j + 1) * dv);
					if (!vertices[p3]) vertices[p3] = new Vertex(radius * Math.cos(a) * Math.sin(b + db), radius * Math.sin(a), radius * Math.cos(a) * Math.cos(b + db), (i + 1) * du, j * dv);
					if (!vertices[p4]) vertices[p4] = new Vertex(radius * Math.cos(a + da) * Math.sin(b + db), radius * Math.sin(a + da), radius * Math.cos(a + da) * Math.cos(b + db), (i + 1) * du, (j + 1) * dv);
					a += da;
				}
				
				b += db;
			}
			return new MeshData(vertices, triangles);
		}
		
	}

}