package nest.object.geom 
{
	import flash.geom.Vector3D;
	
	import nest.object.data.IntersectionData;
	import nest.object.geom.Vertex;
	import nest.object.IMesh;
	
	/**
	 * Intersection
	 */
	public class Intersection {
		
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