package nest.control.factory
{
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	import nest.object.geom.Geometry;
	import nest.object.geom.Vertex;
	import nest.object.geom.Triangle;
	
	/**
	 * PrimitiveFactory
	 * <p>Util class to create primitive objects.</p>
	 * <p>Like Cube, Plane, Sphere, etc</p>
	 */
	public final class PrimitiveFactory {
		
		private static var _skybox:Geometry;
		
		/**
		 * Set mesh's scale to resize your skybox.
		 */
		public static function get skybox():Geometry {
			if (!_skybox) {
				var tri:Triangle;
				var vertices:Vector.<Vertex> = new Vector.<Vertex>(8, true);
				var triangles:Vector.<Triangle> = new Vector.<Triangle>(12, true);
				
				vertices[0] = new Vertex( -.5, .5, -.5);
				vertices[1] = new Vertex(.5, .5, -.5);
				vertices[2] = new Vertex(.5, -.5, -.5);
				vertices[3] = new Vertex( -.5, -.5, -.5);
				
				vertices[4] = new Vertex(.5, .5, .5);
				vertices[5] = new Vertex( -.5, .5, .5);
				vertices[6] = new Vertex( -.5, -.5, .5);
				vertices[7] = new Vertex(.5, -.5, .5);
				
				// front
				tri = triangles[0] = new Triangle(0, 3, 2);
				tri = triangles[1] = new Triangle(0, 2, 1);
				
				// back
				tri = triangles[2] = new Triangle(4, 7, 6);
				tri = triangles[3] = new Triangle(4, 6, 5);
				
				// top
				tri = triangles[4] = new Triangle(5, 0, 1);
				tri = triangles[5] = new Triangle(5, 1, 4);
				
				// bottom
				tri = triangles[6] = new Triangle(7, 2, 3);
				tri = triangles[7] = new Triangle(7, 3, 6);
				
				// left
				tri = triangles[8] = new Triangle(5, 6, 3);
				tri = triangles[9] = new Triangle(5, 3, 0);
				
				// right
				tri = triangles[10] = new Triangle(1, 2, 7);
				tri = triangles[11] = new Triangle(1, 7, 4);
				
				Geometry.calculateNormal(vertices, triangles);
				_skybox = new Geometry(vertices, triangles);
			}
			return _skybox;
		}
		
		private static var _sprite3d:Geometry;
		
		/**
		 * Set mesh's scaleX,Y to resize your sprite3d.
		 */
		public static function get sprite3d():Geometry {
			if (!_sprite3d) {
				var vertices:Vector.<Vertex> = Vector.<Vertex>([new Vertex( -0.5, -0.5, 0, 0.0, 0.0), 
																new Vertex(0.5, -0.5, 0, 1.0, 0.0), 
																new Vertex(0.5, 0.5, 0, 1.0, 1.0), 
																new Vertex( -0.5, 0.5, 0, 0.0, 1.0)]);
				var triangles:Vector.<Triangle> = new Vector.<Triangle>(2, true);
				
				var tri:Triangle = new Triangle(0, 2, 1);
				tri.u0 = 0.0; tri.v0 = 1.0;
				tri.u1 = 1.0; tri.v1 = 0.0;
				tri.u2 = 1.0; tri.v2 = 1.0;
				triangles[0] = tri;
				tri = new Triangle(0, 3, 2);
				tri.u0 = 0.0; tri.v0 = 1.0;
				tri.u1 = 0.0; tri.v1 = 0.0;
				tri.u2 = 1.0; tri.v2 = 0.0;
				triangles[1] = tri;
				
				Geometry.calculateNormal(vertices, triangles);
				_sprite3d = new Geometry(vertices, triangles);
			}
			return _sprite3d;
		}
		
		public static function createBox(width:Number = 100, height:Number = 100, depth:Number = 100):Geometry {
			var w2:Number = width / 2;
			var h2:Number = height / 2;
			var d2:Number = depth / 2;
			
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
			
			Geometry.calculateNormal(vertices, triangles);
			return new Geometry(vertices, triangles);
		}
		
		public static function createPlane(width:Number = 100, height:Number = 100, segmentsW:int = 1, segmentsH:int = 1):Geometry {
			var w2:Number = width / 2;
			var h2:Number = height / 2;
			var dw:Number = width / segmentsW;
			var dh:Number = height / segmentsH;
			var du:Number = 1 / segmentsW;
			var dv:Number = 1 / segmentsH;
			var s:int = (segmentsW + 1) * (segmentsH + 1);
			
			var p1:int, p2:int, p3:int, p4:int;
			var i:int, j:int, k:int, l:int = 0;
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
					
					if (!vertices[p1]) vertices[p1] = new Vertex(i * dw - w2,       0, j * dh - h2,       i * du,       j * dv      );
					if (!vertices[p2]) vertices[p2] = new Vertex(i * dw - w2,       0, (j + 1) * dh - h2, i * du,       (j + 1) * dv);
					if (!vertices[p3]) vertices[p3] = new Vertex((i + 1) * dw - w2, 0, j * dh - h2,       (i + 1) * du, j * dv      );
					if (!vertices[p4]) vertices[p4] = new Vertex((i + 1) * dw - w2, 0, (j + 1) * dh - h2, (i + 1) * du, (j + 1) * dv);
					
					triangles[l].u2 = vertices[p3].u;
					triangles[l].v2 = vertices[p3].v;
					triangles[l].u1 = vertices[p4].u;
					triangles[l].v1 = vertices[p4].v;
					triangles[l].u0 = vertices[p1].u;
					triangles[l].v0 = vertices[p1].v;
					triangles[l + 1].u0 = vertices[p1].u;
					triangles[l + 1].v0 = vertices[p1].v;
					triangles[l + 1].u1 = vertices[p2].u;
					triangles[l + 1].v1 = vertices[p2].v;
					triangles[l + 1].u2 = vertices[p4].u;
					triangles[l + 1].v2 = vertices[p4].v;
					
					l += 2;
				}
			}
			
			Geometry.calculateNormal(vertices, triangles);
			return new Geometry(vertices, triangles);
		}
		
		public static function createSphere(radius:Number = 100, segmentsW:int = 8, segmentsH:int = 6):Geometry {
			var du:Number = 1 / segmentsW;
			var dv:Number = 1 / segmentsH;
			var da:Number = -Math.PI / segmentsH;
			var db:Number = Math.PI * 2 / segmentsW;
			var s:int = (segmentsW + 1) * (segmentsH + 1);
			
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
			
			Geometry.calculateNormal(vertices, triangles);
			return new Geometry(vertices, triangles);
		}
		
		public static function createPrimitiveByRevolution(samples:Vector.<Point>,segmentsW:uint=10, startRadian:Number=0,endRadian:Number=Math.PI*2):Geometry {
			var segmentsH:uint = samples.length-1;
			var radian:Number = endRadian - startRadian;
			var du:Number = 1 / Math.PI / 2 * radian / segmentsW;
			var dv:Number = 1 / segmentsH;
			
			var db:Number = radian / segmentsW;
			var s:int = (segmentsW + 1) * (segmentsH + 1);
			
			var b:Number = startRadian;
			var radius1:Number;
			var radius2:Number;
			var i:int, j:int, k:int, l:int = 0;
			var p1:int, p2:int, p3:int, p4:int;
			var vertices:Vector.<Vertex> = new Vector.<Vertex>(s, true);
			var triangles:Vector.<Triangle> = new Vector.<Triangle>(segmentsW * segmentsH * 2, true);
			
			for (i = 0; i < segmentsW; i++ ) {
				for (j = 0; j < segmentsH; j++) {
					k = i * (segmentsH + 1) + j;
					
					p1 = k;
					p2 = k + 1;
					p3 = k + segmentsH + 1;
					p4 = k + segmentsH + 2;
					
					triangles[l] = new Triangle(p1, p3, p4);
					triangles[l + 1] = new Triangle(p1, p4, p2);
					
					radius1 = samples[j].x;
					radius2 = samples[j + 1].x;
					
					
					if (!vertices[p1]) vertices[p1] = new Vertex(radius1*Math.cos(b), samples[j].y, radius1 * Math.sin(b), i * du, j * dv);
					if (!vertices[p2]) vertices[p2] = new Vertex(radius2*Math.cos(b), samples[j+1].y, radius2 * Math.sin(b), i * du, (j + 1) * dv);
					if (!vertices[p3]) vertices[p3] = new Vertex(radius1*Math.cos(b+db), samples[j].y, radius1 * Math.sin(b+db), (i + 1) * du, j * dv);
					if (!vertices[p4]) vertices[p4] = new Vertex(radius2*Math.cos(b+db), samples[j+1].y, radius2 * Math.sin(b+db), (i + 1) * du, (j + 1) * dv);
					
					triangles[l].u0 = vertices[p1].u;
					triangles[l].v0 = vertices[p1].v;
					triangles[l].u1 = vertices[p3].u;
					triangles[l].v1 = vertices[p3].v;
					triangles[l].u2 = vertices[p4].u;
					triangles[l].v2 = vertices[p4].v;
					
					triangles[l + 1].u0 = vertices[p1].u;
					triangles[l + 1].v0 = vertices[p1].v;
					triangles[l + 1].u1 = vertices[p4].u;
					triangles[l + 1].v1 = vertices[p4].v;
					triangles[l + 1].u2 = vertices[p2].u;
					triangles[l + 1].v2 = vertices[p2].v;
					
					l += 2;
				}
				
				b += db;
			}
			
			Geometry.calculateNormal(vertices, triangles);
			return new Geometry(vertices, triangles);
		}
		
		public static function createPrimitiveByLoft(samples:Vector.<Point>, path:Vector.<Vertex>, topCover:Boolean = false, bottomCover:Boolean = false):Geometry {
			var segmentsW:uint = samples.length - 1;
			var segmentsH:uint = path.length - 1;
			var du:Number = 1 / segmentsW;
			var dv:Number = 1 / segmentsH;
			
			var s:int = (segmentsW + 1) * (segmentsH + 1);
			var ts:int = segmentsW * segmentsH * 2;
			
			var i:int, j:int, k:int, l:int = 0;
			var p1:int, p2:int, p3:int, p4:int;
			
			var vertices:Vector.<Vertex> = new Vector.<Vertex>(s, true);
			var triangles:Vector.<Triangle> = new Vector.<Triangle>(segmentsW * segmentsH * 2, true);
			
			for (i = 0; i < segmentsW; i++ ) {
				for (j = 0; j < segmentsH; j++) {
					k = i * (segmentsH + 1) + j;
					
					p1 = k;
					p2 = k + 1;
					p3 = k + segmentsH + 1;
					p4 = k + segmentsH + 2;
					
					triangles[l] = new Triangle(p1, p3, p4);
					triangles[l + 1] = new Triangle(p1, p4, p2);
					
					if (!vertices[p1]) vertices[p1] = new Vertex(samples[i].x+path[j].x, path[j].y, samples[i].y+path[j].z, i * du, j * dv);
					if (!vertices[p2]) vertices[p2] = new Vertex(samples[i].x+path[j+1].x, path[j+1].y, samples[i].y+path[j+1].z, i * du, (j + 1) * dv);
					if (!vertices[p3]) vertices[p3] = new Vertex(samples[i+1].x+path[j].x, path[j].y, samples[i+1].y+path[j].z, (i + 1) * du, j * dv);
					if (!vertices[p4]) vertices[p4] = new Vertex(samples[i+1].x+path[j+1].x, path[j+1].y, samples[i+1].y+path[j+1].z, (i + 1) * du, (j + 1) * dv);
					
					triangles[l].u0 = vertices[p1].u;
					triangles[l].v0 = vertices[p1].v;
					triangles[l].u1 = vertices[p3].u;
					triangles[l].v1 = vertices[p3].v;
					triangles[l].u2 = vertices[p4].u;
					triangles[l].v2 = vertices[p4].v;
					
					triangles[l + 1].u0 = vertices[p1].u;
					triangles[l + 1].v0 = vertices[p1].v;
					triangles[l + 1].u1 = vertices[p4].u;
					triangles[l + 1].v1 = vertices[p4].v;
					triangles[l + 1].u2 = vertices[p2].u;
					triangles[l + 1].v2 = vertices[p2].v;
					
					l += 2;
				}
			}
			vertices.fixed = triangles.fixed = false;
			
			if (topCover) {
				l = ts;
				p1 = s;
				p2 = segmentsH + 1;
				p3 = 0;
				vertices[p1] = new Vertex(path[0].x, path[0].y, path[0].z, 0, 0);
				for (i = 0; i < segmentsW; i++ ) {
					triangles[l] = new Triangle(p1, p2, p3);
					
					triangles[l].u0 = vertices[p1].u;
					triangles[l].v0 = vertices[p1].v;
					triangles[l].u1 = vertices[p2].u;
					triangles[l].v1 = vertices[p2].v;
					triangles[l].u2 = vertices[p3].u;
					triangles[l].v2 = vertices[p3].v;
					
					p2 += (segmentsH + 1);
					p3 += (segmentsH + 1);
					l++;
				}
			}
			if (bottomCover) {
				l = triangles.length;
				p1 = vertices.length;
				p2 = segmentsH;
				p3 = 2*segmentsH + 1;
				vertices[p1] = new Vertex(path[segmentsH].x, path[segmentsH].y, path[segmentsH].z, 1, 1);
				for (i = 0; i < segmentsW;i++ ) {
					triangles[l] = new Triangle(p1, p2, p3);
					
					triangles[l].u0 = vertices[p1].u;
					triangles[l].v0 = vertices[p1].v;
					triangles[l].u1 = vertices[p2].u;
					triangles[l].v1 = vertices[p2].v;
					triangles[l].u2 = vertices[p3].u;
					triangles[l].v2 = vertices[p3].v;
					
					p2 += (segmentsH + 1);
					p3 += (segmentsH + 1);
					l++;
				}
			}
			vertices.fixed = triangles.fixed = true;
			
			Geometry.calculateNormal(vertices, triangles);
			return new Geometry(vertices, triangles);
		}
	}

}