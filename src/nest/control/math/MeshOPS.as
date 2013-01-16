package nest.control.math 
{
	import flash.geom.Vector3D;
	
	import nest.object.geom.AABB;
	import nest.object.geom.BSphere;
	import nest.object.geom.Geometry;
	import nest.object.geom.Triangle;
	import nest.object.geom.Vertex;
	import nest.object.IMesh;
	
	/**
	 * MeshOPS
	 */
	public final class MeshOPS {
		
		public static function containsUV(tri:Triangle, u:Number, v:Number):Boolean {
			var minX:Number = Math.min(tri.u0, tri.u1, tri.u2);
			var maxX:Number = Math.max(tri.u0, tri.u1, tri.u2);
			var minY:Number = Math.min(tri.v0, tri.v1, tri.v2);
			var maxY:Number = Math.max(tri.v0, tri.v1, tri.v2);
			var result:Boolean = false;
			if (u <= maxX && u >= minX && v <= maxY && v >= minY) {
				var du0:Number = tri.u0 - u;
				var dv0:Number = tri.v0 - v;
				var du1:Number = tri.u1 - u;
				var dv1:Number = tri.v1 - v;
				var du2:Number = tri.u2 - u;
				var dv2:Number = tri.v2 - v;
				
				var cross1:Number = du0 * dv1 - du1 * dv0;
				var cross2:Number = du1 * dv2 - du2 * dv1;
				var cross3:Number = du2 * dv0 - du0 * dv2;
				
				if ((cross1 >= 0 && cross2 >= 0 && cross3 >= 0) || (cross1 <= 0 && cross2 <= 0 && cross3 <= 0)) { ;
					result = true;
				}
			}
			return result;
		}
		
		public static function getVertexByUV(geom:Geometry, u:Number, v:Number):Vertex {
			var v0:Vertex;
			var v1:Vertex;
			var v2:Vertex;
			var contains:Boolean = false;
			var result:Vertex;
			var tri:Triangle;
			for each(tri in geom.triangles) {
				if (containsUV(tri, u, v)) {
					contains = true;
					break;
				}
			}
			if (contains) {
				v0 = geom.vertices[tri.index0];
				v1 = geom.vertices[tri.index1];
				v2 = geom.vertices[tri.index2];
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
		
		///////////////////////////////////
		// AABB / BSphere
		///////////////////////////////////
		
		public static function AABB_BSphere(max:Vector3D, min:Vector3D, center:Vector3D, r:Number):Boolean {
			var x:Number = center.x, y:Number = center.y, z:Number = center.z;
			
			if (x < min.x) {
				x = min.x;
			} else if (x > max.x) {
				x = max.x;
			}
			
			if (y < min.y) {
				y = min.y;
			} else if (y > max.y) {
				y = max.y;
			}
			
			if (z < min.z) {
				z = min.z;
			} else if (z > max.z) {
				z = max.z;
			}
			
			x -= center.x;
			y -= center.y;
			z -= center.z;
			
			return (x * x + y * y + z * z) <= (r * r);
		}
		
		public static function AABB_AABB(max:Vector3D, min:Vector3D, max1:Vector3D, min1:Vector3D):Boolean {
			if (min.x > max1.x) return false;
			if (max.x < min1.x) return false;
			if (min.y > max1.y) return false;
			if (max.y < min1.y) return false;
			if (min.z > max1.z) return false;
			if (max.z < min1.z) return false;
			return true;
		}
		
		public static function BSphere_BSphere(center:Vector3D, r:Number, center1:Vector3D, r1:Number):Boolean {
			var x:Number = center.x - center1.x;
			var y:Number = center.y - center1.y;
			var z:Number = center.z - center1.z;
			return (x * x + y * y + z * z) <= (r + r1) * (r + r1);
		}
		
		///////////////////////////////////
		// Ray
		///////////////////////////////////
		
		/**
		 * Orgion and delta should be translated into mesh's croodinate space.
		 * <p>result.w == 0 means they aren't intersected.</p>
		 * <p>result.w == 1 means they're intersected.</p>
		 */
		public static function Ray_BSphere(result:Vector3D, orgion:Vector3D, delta:Vector3D, bsphere:BSphere):void {
			var e:Vector3D = new Vector3D(bsphere.center.x - orgion.x, bsphere.center.y - orgion.y, bsphere.center.z - orgion.z);
			var a:Number = e.dotProduct(delta) / delta.length;
			var f:Number = bsphere.radius * bsphere.radius - e.lengthSquared + a * a;
			if (f < 0) {
				// no intersection.
				result.w = 0;
				return;
			}
			f = a - Math.sqrt(f);
			if (f > delta.length || f < 0) {
				// no intersection.
				result.w = 0;
				return;
			}
			result.w = 0;
			result.copyFrom(delta);
			result.scaleBy(f);
			result.x += orgion.x;
			result.y += orgion.y;
			result.z += orgion.z;
		}
		
		/**
		 * Orgion and delta should be translated into mesh's croodinate space.
		 * <p>Graphics Gems I p395</p>
		 * <p>result.w == 0 means they aren't intersected.</p>
		 * <p>result.w == 1 means they're intersected.</p>
		 */
		public static function Ray_AABB(result:Vector3D, orgion:Vector3D, delta:Vector3D, aabb:AABB):void {
			result.w = 0;
			var inside:Boolean = true;
			var xt:Number, xn:Number;
			if (orgion.x < aabb.min.x) {
				xt = aabb.min.x - orgion.x;
				if (xt > delta.x) return;
				xt /= delta.x;
				inside = false;
				xn = -1;
			} else if (orgion.x > aabb.max.x) {
				xt = aabb.max.x - orgion.x;
				if (xt < delta.x) return;
				xt /= delta.x;
				inside = false;
				xn = 1;
			} else {
				xt = -1;
			}
			var yt:Number, yn:Number;
			if (orgion.y < aabb.min.y) {
				yt = aabb.min.y - orgion.y;
				if (yt > delta.y) return;
				yt /= delta.y;
				inside = false;
				yn = -1;
			} else if (orgion.y > aabb.max.y) {
				yt = aabb.max.y - orgion.y;
				if (yt < delta.y) return;
				yt /= delta.y;
				inside = false;
				yn = 1;
			}else {
				yt = -1;
			}
			var zt:Number, zn:Number;
			if (orgion.z < aabb.min.z) {
				zt = aabb.min.z - orgion.z;
				if (zt > delta.z) return;
				zt /= delta.z;
				inside = false;
				zn = -1;
			} else if (orgion.z > aabb.max.z) {
				zt = aabb.max.z - orgion.z;
				if (zt < delta.z) return;
				zt /= delta.z;
				inside = false;
				zn = 1;
			} else {
				zt = -1;
			}
			if (inside) return;
			var which:int = 0;
			var t:Number = xt;
			if (yt > t) {
				which = 1;
				t = yt;
			}
			if (zt > t) {
				which = 2;
				t = zt;
			}
			var x:Number, y:Number, z:Number;
			switch(which) {
				case 0:
					// yz
					y = orgion.y + delta.y * t;
					if (y < aabb.min.y || y > aabb.max.y) return;
					z = orgion.z + delta.z * t;
					if (z < aabb.min.z || z > aabb.max.z) return;
					break;
				case 1:
					// xz
					x = orgion.x + delta.x * t;
					if (x < aabb.min.x || x > aabb.max.x) return;
					z = orgion.z + delta.z * t;
					if (z < aabb.min.z || z > aabb.max.z) return;
					break;
				case 2:
					// xy
					x = orgion.x + delta.x * t;
					if (x < aabb.min.x || x > aabb.max.x) return;
					y = orgion.y + delta.y * t;
					if (y < aabb.min.y || y > aabb.max.y) return;
					break;
			}
			result.w = 1;
			result.copyFrom(delta);
			result.scaleBy(t);
			result.x += orgion.x;
			result.y += orgion.y;
			result.z += orgion.z;
		}
		
		/**
		 * Orgion and delta should be translated into mesh's croodinate space.
		 * <p>Graphics Gems I Dider Badouel.</p>
		 */
		public static function Ray_Triangle(orgion:Vector3D, delta:Vector3D, p0:Vertex, p1:Vertex, p2:Vertex, normal:Vector3D, minT:Number = 1):Number {
			var dot:Number = normal.dotProduct(delta);
			if (!(dot < 0)) return Number.MAX_VALUE;
			var d:Number = normal.x * p0.x + normal.y * p0.y + normal.z * p0.z;
			var t:Number = d - normal.dotProduct(orgion);
			if (!(t <= 0)) return Number.MAX_VALUE;
			if (!(t >= dot * minT)) return Number.MAX_VALUE;
			t = t / dot;
			var p:Vector3D = new Vector3D();
			p.copyFrom(delta);
			p.scaleBy(t);
			p.x += orgion.x;
			p.y += orgion.y;
			p.z += orgion.z;
			var u0:Number, u1:Number, u2:Number;
			var v0:Number, v1:Number, v2:Number;
			if (Math.abs(normal.x) > Math.abs(normal.y)) {
				if (Math.abs(normal.x) > Math.abs(normal.z)) {
					u0 = p.y - p0.y;
					u1 = p1.y - p0.y;
					u2 = p2.y - p0.y;
					v0 = p.z - p0.z;
					v1 = p1.z - p0.z;
					v2 = p2.z - p0.z;
				} else {
					u0 = p.x - p0.x;
					u1 = p1.x - p0.x;
					u2 = p2.x - p0.x;
					v0 = p.y - p0.y;
					v1 = p1.y - p0.y;
					v2 = p2.y - p0.y;
				}
			} else {
				if (Math.abs(normal.y) > Math.abs(normal.z)) {
					u0 = p.x - p0.x;
					u1 = p1.x - p0.x;
					u2 = p2.x - p0.x;
					v0 = p.z - p0.z;
					v1 = p1.z - p0.z;
					v2 = p2.z - p0.z;
				} else {
					u0 = p.x - p0.x;
					u1 = p1.x - p0.x;
					u2 = p2.x - p0.x;
					v0 = p.y - p0.y;
					v1 = p1.y - p0.y;
					v2 = p2.y - p0.y;
				}
			}
			var tmp:Number = u1 * v2 - v1 * u2;
			if (!(tmp != 0)) return Number.MAX_VALUE;
			tmp = 1 / tmp;
			var alpha:Number = (u0 * v2 - v0 * u2) * tmp;
			if (!(alpha >= 0)) return Number.MAX_VALUE;
			var beta:Number = (u1 * v0 - v1 * u0) * tmp;
			if (!(beta >= 0)) return Number.MAX_VALUE;
			var gamma:Number = 1 - alpha - beta;
			if (!(gamma >= 0)) return Number.MAX_VALUE;
			return t;
		}
		
		/**
		 * Orgion and delta should be translated into mesh's croodinate space.
		 * <p>result.w == 0 means they aren't intersected.</p>
		 * <p>result.w == 1 means they're intersected.</p>
		 */
		public static function Ray_Mesh(result:Vector3D, orgion:Vector3D, delta:Vector3D, mesh:IMesh):void {
			if (mesh.bound is AABB) {
				Ray_AABB(result, orgion, delta, mesh.bound as AABB);
			} else {
				Ray_BSphere(result, orgion, delta, mesh.bound as BSphere);
			}
			if (result.w == 1) {
				var t:Number;
				var triangle:Triangle;
				for each(triangle in mesh.geom.triangles) {
					t = Ray_Triangle(orgion, delta, mesh.geom.vertices[triangle.index0], 
													mesh.geom.vertices[triangle.index1], 
													mesh.geom.vertices[triangle.index2], 
													triangle.normal);
					if (t <= 1) {
						result.copyFrom(delta);
						result.scaleBy(t);
						result.x += orgion.x;
						result.y += orgion.y;
						result.z += orgion.z;
						return;
					}
				}
				result.w = 0;
			}
		}
		
	}

}