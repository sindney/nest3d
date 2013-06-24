package nest.control.util 
{
	import flash.geom.Vector3D;
	
	import nest.object.Geometry;
	import nest.object.IMesh;
	
	/**
	 * RayIntersection
	 * <p>Refer to Graphics Gems I</p>
	 * @see nest.control.util.RayIntersectionResult
	 */
	public class RayIntersection {
		
		public static function RayBSphere(result:Vector3D, orgion:Vector3D, delta:Vector3D, center:Vector3D, radius:Number):void {
			const e:Vector3D = new Vector3D(center.x - orgion.x, center.y - orgion.y, center.z - orgion.z);
			const a:Number = e.dotProduct(delta) / delta.length;
			var f:Number = radius * radius - e.lengthSquared + a * a;
			if (f < 0) {
				result.w = 0;
				return;
			}
			f = a - Math.sqrt(f);
			if (f > delta.length || f < 0) {
				result.w = 0;
				return;
			}
			result.w = 1;
			result.copyFrom(delta);
			result.scaleBy(f);
			result.x += orgion.x;
			result.y += orgion.y;
			result.z += orgion.z;
		}
		
		public static function RayAABB(result:Vector3D, orgion:Vector3D, delta:Vector3D, max:Vector3D, min:Vector3D):void {
			result.w = 0;
			var inside:Boolean = true;
			var xt:Number, xn:Number;
			if (orgion.x < min.x) {
				xt = min.x - orgion.x;
				if (xt > delta.x) return;
				xt /= delta.x;
				inside = false;
				xn = -1;
			} else if (orgion.x > max.x) {
				xt = max.x - orgion.x;
				if (xt < delta.x) return;
				xt /= delta.x;
				inside = false;
				xn = 1;
			} else {
				xt = -1;
			}
			var yt:Number, yn:Number;
			if (orgion.y < min.y) {
				yt = min.y - orgion.y;
				if (yt > delta.y) return;
				yt /= delta.y;
				inside = false;
				yn = -1;
			} else if (orgion.y > max.y) {
				yt = max.y - orgion.y;
				if (yt < delta.y) return;
				yt /= delta.y;
				inside = false;
				yn = 1;
			}else {
				yt = -1;
			}
			var zt:Number, zn:Number;
			if (orgion.z < min.z) {
				zt = min.z - orgion.z;
				if (zt > delta.z) return;
				zt /= delta.z;
				inside = false;
				zn = -1;
			} else if (orgion.z > max.z) {
				zt = max.z - orgion.z;
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
					if (y < min.y || y > max.y) return;
					z = orgion.z + delta.z * t;
					if (z < min.z || z > max.z) return;
					break;
				case 1:
					// xz
					x = orgion.x + delta.x * t;
					if (x < min.x || x > max.x) return;
					z = orgion.z + delta.z * t;
					if (z < min.z || z > max.z) return;
					break;
				case 2:
					// xy
					x = orgion.x + delta.x * t;
					if (x < min.x || x > max.x) return;
					y = orgion.y + delta.y * t;
					if (y < min.y || y > max.y) return;
					break;
			}
			result.w = 1;
			result.copyFrom(delta);
			result.scaleBy(t);
			result.x += orgion.x;
			result.y += orgion.y;
			result.z += orgion.z;
		}
		
		public static function RayTriangle(orgion:Vector3D, delta:Vector3D, p0:Vector3D, p1:Vector3D, p2:Vector3D, normal:Vector3D, minT:Number = 1):Number {
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
		 * Translate ray orgion and delta to mesh's local coordinate space before intersection test.
		 */
		public static function RayMesh(result:RayIntersectionResult, results:Vector.<RayIntersectionResult>, orgion:Vector3D, delta:Vector3D, mesh:IMesh):void {
			var vt1:Vector3D = new Vector3D(); 
			RayAABB(vt1, orgion, delta, mesh.geometry.max, mesh.geometry.min);
			var flag:Boolean = (result != null);
			var current:RayIntersectionResult = flag ? result : new RayIntersectionResult();
			current.flag = (vt1.w != 0);
			if (!current.flag) return;
			current.flag = false;
			var vt2:Vector3D = new Vector3D();
			var v1:Vector3D = new Vector3D(), v2:Vector3D = new Vector3D(), v3:Vector3D = new Vector3D();
			var geom:Geometry = mesh.geometry;
			var t:Number;
			var i:int, j:int, k:int;
			for (i = 0; i < geom.numTriangles; i++) {
				j = i * 3;
				k = geom.indices[j] * 3;
				v1.x = geom.vertices[k];
				v1.y = geom.vertices[k + 1];
				v1.z = geom.vertices[k + 2];
				k = geom.indices[j + 1] * 3;
				v2.x = geom.vertices[k];
				v2.y = geom.vertices[k + 1];
				v2.z = geom.vertices[k + 2];
				k = geom.indices[j + 2] * 3;
				v3.x = geom.vertices[k];
				v3.y = geom.vertices[k + 1];
				v3.z = geom.vertices[k + 2];
				vt1.setTo(v2.x - v1.x, v2.y - v1.y, v2.z - v1.z);
				vt2.setTo(v3.x - v2.x, v3.y - v2.y, v3.z - v2.z);
				vt1 = vt1.crossProduct(vt2);
				vt1.normalize();
				t = RayTriangle(orgion, delta, v1, v2, v3, vt1);
				if (t <= 1) {
					current.point.copyFrom(delta);
					current.point.scaleBy(t);
					current.point.x += orgion.x;
					current.point.y += orgion.y;
					current.point.z += orgion.z;
					current.index = geom.indices[j];
					current.flag = true;
					if (flag) {
						return;
					} else {
						results.push(current);
						current = new RayIntersectionResult();
					}
				}
			}
		}
		
	}

}