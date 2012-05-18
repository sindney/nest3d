package nest.view 
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import nest.object.geom.Plane;
	
	/**
	 * Frustum
	 */
	public class Frustum {
		
		private var planes:Vector.<Plane>;
		
		public function Frustum() {
			planes = new Vector.<Plane>(6, true);
			planes[0] = new Plane();
			planes[1] = new Plane();
			planes[2] = new Plane();
			planes[3] = new Plane();
			planes[4] = new Plane();
			planes[5] = new Plane();
		}
		
		public function create(angle:Number, ratio:Number, near:Number, far:Number):void {
			var nTL:Vector3D, nTR:Vector3D, nBL:Vector3D, nBR:Vector3D;
			var fTL:Vector3D, fTR:Vector3D, fBL:Vector3D, fBR:Vector3D;
			var vn:Vector3D, vf:Vector3D;
			
			const r:Number = Math.tan(angle * 0.5);
			const nH:Number = near * r;
			const nW:Number = nH * ratio;
			const fH:Number = far * r;
			const fW:Number = fH * ratio;
			
			const zv:Vector3D = new Vector3D(0, 0, -1);
			const xv:Vector3D = new Vector3D( -1, 0, 0);
			const yv:Vector3D = new Vector3D(0, 1, 0);
			
			vn = scaleVector(zv, near);
			vn.negate();
			vf = scaleVector(zv, far);
			vf.negate();
			
			nTL = vn.add(scaleVector(yv, nH)).subtract(scaleVector(xv, nW));
			nTR = vn.add(scaleVector(yv, nH)).add(scaleVector(xv, nW));
			nBL = vn.subtract(scaleVector(yv, nH)).subtract(scaleVector(xv, nW));
			nBR = vn.subtract(scaleVector(yv, nH)).add(scaleVector(xv, nW));
			
			fTL = vf.add(scaleVector(yv, fH)).subtract(scaleVector(xv, fW));
			fTR = vf.add(scaleVector(yv, fH)).add(scaleVector(xv, fW));
			fBL = vf.subtract(scaleVector(yv, fH)).subtract(scaleVector(xv, fW));
			fBR = vf.subtract(scaleVector(yv, fH)).add(scaleVector(xv, fW));
			
			// top
			planes[0].create(fTR, nTR, nTL);
			// bottom
			planes[1].create(nBL, nBR, fBR);
			// left
			planes[2].create(nTL, nBL, fBL);
			// right
			planes[3].create(fBR, nBR, nTR);
			// near
			planes[4].create(nTL, nTR, nBR);
			// far
			planes[5].create(fTR, fTL, fBL);
		}
		
		public function classifyPoint(p:Vector3D):Boolean {
			var i:int;
			for (i = 0; i < 6; i++) {
				if (planes[i].getDistance(p) < 0) return false;
			}
			return true;
		}
		
		public function classifyBSphere(center:Vector3D, radius:Number):Boolean {
			var i:int
			var d:Number;
			for (i = 0; i < 6; i++) {
				d = planes[i].getDistance(center);
				if (d < 0 && radius < -d) {
					return false;
				}
			}
			return true;
		}
		
		public function classifyAABB(vertices:Vector.<Vector3D>):Boolean {
			const near:Boolean = findIntersection(vertices, planes[4]);
			const far:Boolean = findIntersection(vertices, planes[5]);
			if (near != far) return false;
			const left:Boolean = findIntersection(vertices, planes[2]);
			const right:Boolean = findIntersection(vertices, planes[3]);
			if (left != right) return false;
			const top:Boolean = findIntersection(vertices, planes[0]);
			const bottom:Boolean = findIntersection(vertices, planes[1]);
			if (top != bottom) return false;
			return true;
		}
		
		private function findIntersection(vertices:Vector.<Vector3D>, plane:Plane):Boolean {
			const index:int = findNearestPoint(vertices, plane);
			const v0:Vector3D = vertices[index];
			const v1:Vector3D = vertices[findFarestPoint(vertices, plane, index)];
			const a:Boolean = plane.getDistance(v0) > 0;
			const b:Boolean = plane.getDistance(v1) > 0;
			
			if (!a && !b) return false;
			return true;
		}
		
		private function findNearestPoint(vertices:Vector.<Vector3D>, plane:Plane):int {
			var i:int, index:int;
			var j:int, k:int;
			var v:Vector3D;
			for (i = 0; i < 8; i++) {
				v = vertices[i];
				j = Math.abs(plane.getDistance(v));
				if (!k) {
					k = j;
					index = i;
				}
				if (j < k) {
					k = j;
					index = i;
				}
			}
			return index;
		}
		
		private function findFarestPoint(vertices:Vector.<Vector3D>, plane:Plane, p:int):int {
			var i:int, index:int;
			var j:int, k:int, l:int = plane.getDistance(vertices[p]);
			var v:Vector3D;
			for (i = 0; i < 8; i++) {
				if (i != p) {
					v = vertices[i];
					j = plane.getDistance(v);
					if (!k) {
						k = j;
						index = i;
					}
					if (l > 0) {
						if (j < k) {
							k = j;
							index = i;
						}
					} else {
						if (j > k) {
							k = j;
							index = i;
						}
					}
				}
			}
			return index;
		}
		
		private function scaleVector(v:Vector3D, k:Number):Vector3D {
			return new Vector3D(v.x * k, v.y * k, v.z * k);
		}
		
		///////////////////////////////////
		// toString
		///////////////////////////////////
		
		public function toString():String {
			return "[nest.view.Frustum]";
		}
		
	}

}