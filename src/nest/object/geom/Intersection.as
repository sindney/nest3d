package nest.object.geom 
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import nest.object.data.IntersectionData;
	import nest.object.geom.Vertex;
	import nest.object.IMesh;
	
	/**
	 * Intersection
	 */
	public class Intersection {
		
		public static function ClosestPtPointTriangle(p:Vector3D, a:Vector3D, b:Vector3D, c:Vector3D):Vector3D {
			const ab:Vector3D = b.subtract(a);
			const ac:Vector3D = c.subtract(a);
			const ap:Vector3D = p.subtract(a);
			
			const d1:Number = ab.dotProduct(ap);
			const d2:Number = ac.dotProduct(ap);
			if (d1 <= 0 && d2 <= 0) return a;
			
			const bp:Vector3D = p.subtract(b);
			const d3:Number = ab.dotProduct(bp);
			const d4:Number = ac.dotProduct(bp);
			if (d3 >= 0 && d4 <= d3) return b;
			
			const vc:Number = d1 * d4 - d3 * d2;
			if (vc <= 0 && d1 >= 0 && d3 <= 0) {
				ab.scaleBy(d1 / (d1 - d3));
				return a.add(ab);
			}
			
			const cp:Vector3D = p.subtract(c);
			const d5:Number = ab.dotProduct(cp);
			const d6:Number = ac.dotProduct(cp);
			if (d6 >= 0 && d5 <= d6) return c;
			
			const vb:Number = d5 * d2 - d1 * d6;
			if (vb <= 0 && d2 >= 0 && d6 <= 0) {
				ac.scaleBy(d2 / (d2 - d6));
				return a.add(ac);
			}
			
			const va:Number = d3 * d6 - d5 * d4;
			if (va <= 0 && (d4 - d3) >= 0 && (d5 - d6) >= 0) {
				const cb:Vector3D = c.subtract(b);
				cb.scaleBy((d4 - d3) / ((d4 - d3) + (d5 - d6)));
				return b.add(cb);
			}
			
			const denom:Number = 1 / (va + vb + vc);
			ab.scaleBy(vb * denom);
			ac.scaleBy(vc * denom);
			return a.add(ab.add(ac));
		}
		
		public static function ClosestPtPointPlane(p:Vector3D, plane:Plane):Vector3D {
			const v:Vector3D = new Vector3D(plane.a, plane.b, plane.c);
			v.scaleBy(v.dotProduct(p) - plane.d);
			return p.subtract(v);
		}
		
		public static function ClosestPtPointAABB(p:Vector3D, aabb:AABB):Vector3D {
			var x:Number = p.x;
			if (x < aabb.min.x) x = aabb.min.x;
			if (x > aabb.max.x) x = aabb.max.x;
			
			var y:Number = p.y;
			if (y < aabb.min.y) y = aabb.min.y;
			if (y > aabb.max.y) y = aabb.max.y;
			
			var z:Number = p.z;
			if (z < aabb.min.z) z = aabb.min.z;
			if (z > aabb.max.z) z = aabb.max.z;
			
			return new Vector3D(x, y, z);
		}
		
		///////////////////////////////////
		// Triangle
		///////////////////////////////////
		
		public static function Triangles(v0:Vector3D, v1:Vector3D, v2:Vector3D, v3:Vector3D, v4:Vector3D, v5:Vector3D):Boolean {
			return true;
		}
		
		public static function AABB_Triangle(aabb:AABB, v0:Vector3D, v1:Vector3D, v2:Vector3D):Boolean {
			var p0:Number, p1:Number, p2:Number, r:Number, a:Number, b:Number, c:Number;
			
			const e0:Number = (aabb.max.x - aabb.min.x) * 0.5;
			const e1:Number = (aabb.max.y - aabb.min.y) * 0.5;
			const e2:Number = (aabb.max.z - aabb.min.z) * 0.5;
			
			v0.x = v0.x - aabb.center.x;
			v0.y = v0.y - aabb.center.y;
			v0.z = v0.z - aabb.center.z;
			
			v1.x = v1.x - aabb.center.x;
			v1.y = v1.y - aabb.center.y;
			v1.z = v1.z - aabb.center.z;
			
			v2.x = v2.x - aabb.center.x;
			v2.y = v2.y - aabb.center.y;
			v2.z = v2.z - aabb.center.z;
			
			const f0:Vector3D = v1.subtract(v0);
			const f1:Vector3D = v2.subtract(v1);
			const f2:Vector3D = v0.subtract(v2);
			
			// a00
			r = e1 * Math.abs(f0.z) + e2 * Math.abs(f0.y);
			b = v1.z - v0.z;
			c = v1.y - v0.y;
			p0 = v0.z * c - v0.y * b;
			p1 = v1.z * c - v1.y * b;
			p2 = v2.z * c - v2.y * b;
			if (Math.max( -Math.max(p0, p1, p2), Math.min(p0, p1, p2)) > r) return false;
			
			// a01
			r = e1 * Math.abs(f1.z) + e2 * Math.abs(f1.y);
			b = v2.z - v1.z;
			c = v2.y - v1.y;
			p0 = v0.z * c - v0.y * b;
			p1 = v1.z * c - v1.y * b;
			p2 = v2.z * c - v2.y * b;
			if (Math.max( -Math.max(p0, p1, p2), Math.min(p0, p1, p2)) > r) return false;
			
			// a02
			r = e1 * Math.abs(f2.z) + e2 * Math.abs(f2.y);
			b = v0.z - v2.z;
			c = v0.y - v2.y;
			p0 = v0.z * c - v0.y * b;
			p1 = v1.z * c - v1.y * b;
			p2 = v2.z * c - v2.y * b;
			if (Math.max( -Math.max(p0, p1, p2), Math.min(p0, p1, p2)) > r) return false;
			
			// a10
			r = e0 * Math.abs(f0.z) + e2 * Math.abs(f0.x);
			a = v1.z - v0.z;
			c = v1.x - v0.x;
			p0 = v0.z * a - v0.x * c;
			p1 = v1.z * a - v1.x * c;
			p2 = v2.z * a - v2.x * c;
			if (Math.max( -Math.max(p0, p1, p2), Math.min(p0, p1, p2)) > r) return false;
			
			// a11
			r = e0 * Math.abs(f1.z) + e2 * Math.abs(f1.x);
			a = v2.z - v1.z;
			c = v2.x - v1.x;
			p0 = v0.z * a - v0.x * c;
			p1 = v1.z * a - v1.x * c;
			p2 = v2.z * a - v2.x * c;
			if (Math.max( -Math.max(p0, p1, p2), Math.min(p0, p1, p2)) > r) return false;
			
			// a12
			r = e0 * Math.abs(f2.z) + e2 * Math.abs(f2.x);
			a = v0.z - v2.z;
			c = v0.x - v2.x;
			p0 = v0.z * a - v0.x * c;
			p1 = v1.z * a - v1.x * c;
			p2 = v2.z * a - v2.x * c;
			if (Math.max( -Math.max(p0, p1, p2), Math.min(p0, p1, p2)) > r) return false;
			
			// a20
			r = e0 * Math.abs(f0.y) + e1 * Math.abs(f0.x);
			a = v1.y - v0.y;
			b = v1.x - v0.x;
			p0 = v0.x * b - v0.y * a;
			p1 = v1.x * b - v1.y * a;
			p2 = v2.x * b - v2.y * a;
			if (Math.max( -Math.max(p0, p1, p2), Math.min(p0, p1, p2)) > r) return false;
			
			// a21
			r = e0 * Math.abs(f1.y) + e1 * Math.abs(f1.x);
			a = v2.y - v1.y;
			b = v2.x - v1.x;
			p0 = v0.x * b - v0.y * a;
			p1 = v1.x * b - v1.y * a;
			p2 = v2.x * b - v2.y * a;
			if (Math.max( -Math.max(p0, p1, p2), Math.min(p0, p1, p2)) > r) return false;
			
			// a22
			r = e0 * Math.abs(f2.y) + e1 * Math.abs(f2.x);
			a = v0.y - v2.y;
			b = v0.x - v2.x;
			p0 = v0.x * b - v0.y * a;
			p1 = v1.x * b - v1.y * a;
			p2 = v2.x * b - v2.y * a;
			if (Math.max( -Math.max(p0, p1, p2), Math.min(p0, p1, p2)) > r) return false;
			
			if (Math.max(v0.x, v1.x, v2.x) < -e0 || Math.min(v0.x, v1.x, v2.x) > e0) return false;
			if (Math.max(v0.y, v1.y, v2.y) < -e1 || Math.min(v0.y, v1.y, v2.y) > e1) return false;
			if (Math.max(v0.z, v1.z, v2.z) < -e2 || Math.min(v0.z, v1.z, v2.z) > e1) return false;
			
			const n:Vector3D = f0.crossProduct(f1);
			const d:Number = n.dotProduct(v0);
			
			const e:Vector3D = aabb.max.subtract(aabb.center);
			const s:Number = n.dotProduct(aabb.center) - d;
			
			return Math.abs(s) <= e.x * Math.abs(n.x) + e.y * Math.abs(n.y) + e.z * Math.abs(n.z);
		}
		
		public static function BSphere_Triangle(bsphere:BSphere, a:Vector3D, b:Vector3D, c:Vector3D):Boolean {
			const v:Vector3D = ClosestPtPointTriangle(bsphere.center, a, b, c).subtract(bsphere.center);
			return v.dotProduct(v) <= bsphere.radius * bsphere.radius;
		}
		
		///////////////////////////////////
		// AABB / BSphere
		///////////////////////////////////
		
		/**
		 * center should be translated into aabb's croodinate space.
		 */
		public static function AABB_BSphere(aabb:AABB, center:Vector3D, radius:Number):Boolean {
			const r2:Number = radius * radius;
			const a:Vector3D = new Vector3D();
			
			if (center.x < aabb.min.x) {
				a.x = aabb.min.x;
			} else if (center.x > aabb.max.x) {
				a.x = aabb.max.x;
			} else {
				a.x = center.x;
			}
			
			if (center.y < aabb.min.y) {
				a.y = aabb.min.y;
			} else if (center.y > aabb.max.y) {
				a.y = aabb.max.y;
			} else {
				a.y = center.y;
			}
			
			if (center.z < aabb.min.z) {
				a.z = aabb.min.z;
			} else if (center.z > aabb.max.z) {
				a.z = aabb.max.z;
			} else {
				a.z = center.z;
			}
			
			const x:Number = a.x - center.x;
			const y:Number = a.y - center.y;
			const z:Number = a.z - center.z;
			const d:Number = x * x + y * y + z * z;
			
			return d < r2;
		}
		
		/**
		 * max/min should be translated into aabb's croodinate space.
		 */
		public static function AABB_AABB(aabb:AABB, max:Vector3D, min:Vector3D):Boolean {
			if (aabb.min.x > max.x) return false;
			if (aabb.max.x < min.x) return false;
			if (aabb.min.y > max.y) return false;
			if (aabb.max.y < min.y) return false;
			if (aabb.min.z > max.z) return false;
			if (aabb.max.z < min.z) return false;
			return true;
		}
		
		/**
		 * center should be translated into bsphere's croodinate space.
		 */
		public static function BSphere_BSphere(bsphere:BSphere, center:Vector3D, radius:Number):Boolean {
			const x:Number = bsphere.center.x - center.x;
			const y:Number = bsphere.center.y - center.y;
			const z:Number = bsphere.center.z - center.z;
			const d:Number = x * x + y * y + z * z;
			return d < (bsphere.radius + radius) * (bsphere.radius + radius);
		}
		
		///////////////////////////////////
		// Ray
		///////////////////////////////////
		
		/**
		 * Orgion and delta should be translated into mesh's croodinate space.
		 */
		public static function Ray_BSphere(result:IntersectionData, orgion:Vector3D, delta:Vector3D, bsphere:BSphere):void {
			const e:Vector3D = new Vector3D(bsphere.center.x - orgion.x, bsphere.center.y - orgion.y, bsphere.center.z - orgion.z);
			const a:Number = e.dotProduct(delta) / delta.length;
			var f:Number = bsphere.radius * bsphere.radius - e.lengthSquared + a * a;
			if (f < 0) {
				// no intersection.
				result.intersected = false;
				return;
			}
			f = a - Math.sqrt(f);
			if (f > delta.length || f < 0) {
				// no intersection.
				result.intersected = false;
				return;
			}
			result.intersected = true;
			result.point.copyFrom(delta);
			result.point.scaleBy(f);
			result.point.x += orgion.x;
			result.point.y += orgion.y;
			result.point.z += orgion.z;
		}
		
		/**
		 * Orgion and delta should be translated into mesh's croodinate space.
		 * <p>Graphics Gems I p395</p>
		 */
		public static function Ray_AABB(result:IntersectionData, orgion:Vector3D, delta:Vector3D, aabb:AABB):void {
			result.intersected = false;
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
			result.intersected = true;
			result.point.copyFrom(delta);
			result.point.scaleBy(t);
			result.point.x += orgion.x;
			result.point.y += orgion.y;
			result.point.z += orgion.z;
		}
		
		/**
		 * Orgion and delta should be translated into mesh's croodinate space.
		 * <p>Graphics Gems I Dider Badouel.</p>
		 */
		public static function Ray_Triangle(orgion:Vector3D, delta:Vector3D, p0:Vertex, p1:Vertex, p2:Vertex, normal:Vector3D, minT:Number = 1):Number {
			const dot:Number = normal.dotProduct(delta);
			if (!(dot < 0)) return Number.MAX_VALUE;
			const d:Number = normal.x * p0.x + normal.y * p0.y + normal.z * p0.z;
			var t:Number = d - normal.dotProduct(orgion);
			if (!(t <= 0)) return Number.MAX_VALUE;
			if (!(t >= dot * minT)) return Number.MAX_VALUE;
			t = t / dot;
			const p:Vector3D = new Vector3D();
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
			const alpha:Number = (u0 * v2 - v0 * u2) * tmp;
			if (!(alpha >= 0)) return Number.MAX_VALUE;
			const beta:Number = (u1 * v0 - v1 * u0) * tmp;
			if (!(beta >= 0)) return Number.MAX_VALUE;
			const gamma:Number = 1 - alpha - beta;
			if (!(gamma >= 0)) return Number.MAX_VALUE;
			return t;
		}
		
		/**
		 * Orgion and delta should be translated into mesh's croodinate space.
		 */
		public static function Ray_Mesh(result:IntersectionData, orgion:Vector3D, delta:Vector3D, mesh:IMesh):void {
			if (mesh.bound is AABB) {
				Ray_AABB(result, orgion, delta, mesh.bound as AABB);
			} else {
				Ray_BSphere(result, orgion, delta, mesh.bound as BSphere);
			}
			if (result.intersected) {
				var t:Number;
				var triangle:Triangle;
				for each(triangle in mesh.data.triangles) {
					t = Ray_Triangle(orgion, delta, mesh.data.vertices[triangle.index0], 
													mesh.data.vertices[triangle.index1], 
													mesh.data.vertices[triangle.index2], 
													triangle.normal);
					if (t <= 1) {
						result.point.copyFrom(delta);
						result.point.scaleBy(t);
						result.point.x += orgion.x;
						result.point.y += orgion.y;
						result.point.z += orgion.z;
						break;
					}
				}
			}
		}
		
	}

}