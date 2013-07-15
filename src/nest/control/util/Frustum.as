package nest.control.util 
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
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
			var r:Number = Math.tan(angle * 0.5);
			var nH:Number = near * r;
			var nW:Number = nH * ratio;
			var fH:Number = far * r;
			var fW:Number = fH * ratio;
			
			var zv:Vector3D = new Vector3D(0, 0, -1);
			var xv:Vector3D = new Vector3D( -1, 0, 0);
			var yv:Vector3D = new Vector3D(0, 1, 0);
			
			var vn:Vector3D = new Vector3D(zv.x * near, zv.y * near, zv.z * near);
			vn.negate();
			var vf:Vector3D = new Vector3D(zv.x * far, zv.y * far, zv.z * far);
			vf.negate();
			
			var yv_nH:Vector3D = new Vector3D(yv.x * nH, yv.y * nH, yv.z * nH);
			var xv_nW:Vector3D = new Vector3D(xv.x * nW, xv.y * nW, xv.z * nW);
			
			var nTL:Vector3D = vn.add(yv_nH).subtract(xv_nW);
			var nTR:Vector3D = vn.add(yv_nH).add(xv_nW);
			var nBL:Vector3D = vn.subtract(yv_nH).subtract(xv_nW);
			var nBR:Vector3D = vn.subtract(yv_nH).add(xv_nW);
			
			var yv_fH:Vector3D = new Vector3D(yv.x * fH, yv.y * fH, yv.z * fH);
			var xv_fW:Vector3D = new Vector3D(xv.x * fW, xv.y * fW, xv.z * fW);
			
			var fTL:Vector3D = vf.add(yv_fH).subtract(xv_fW);
			var fTR:Vector3D = vf.add(yv_fH).add(xv_fW);
			var fBL:Vector3D = vf.subtract(yv_fH).subtract(xv_fW);
			var fBR:Vector3D = vf.subtract(yv_fH).add(xv_fW);
			
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
		
		public function classifyAABB(max:Vector3D, min:Vector3D, ivm:Matrix3D):Boolean {
			var vertices:Vector.<Vector3D> = new Vector.<Vector3D>(8, true);
			vertices[0] = ivm.transformVector(new Vector3D(min.x, min.y, min.z));
			vertices[1] = ivm.transformVector(new Vector3D(max.x, min.y, min.z));
			vertices[2] = ivm.transformVector(new Vector3D(min.x, max.y, min.z));
			vertices[3] = ivm.transformVector(new Vector3D(max.x, max.y, min.z));
			vertices[4] = ivm.transformVector(new Vector3D(min.x, min.y, max.z));
			vertices[5] = ivm.transformVector(new Vector3D(max.x, min.y, max.z));
			vertices[6] = ivm.transformVector(new Vector3D(min.x, max.y, max.z));
			vertices[7] = ivm.transformVector(new Vector3D(max.x, max.y, max.z));
			var near:Boolean = findIntersection(vertices, planes[4]);
			var far:Boolean = findIntersection(vertices, planes[5]);
			if (near != far) return false;
			var left:Boolean = findIntersection(vertices, planes[2]);
			var right:Boolean = findIntersection(vertices, planes[3]);
			if (left != right) return false;
			var top:Boolean = findIntersection(vertices, planes[0]);
			var bottom:Boolean = findIntersection(vertices, planes[1]);
			if (top != bottom) return false;
			return true;
		}
		
		private function findIntersection(vertices:Vector.<Vector3D>, plane:Plane):Boolean {
			var index:int = findNearestPoint(vertices, plane);
			var v0:Vector3D = vertices[index];
			var v1:Vector3D = vertices[findFarestPoint(vertices, plane, index)];
			var a:Boolean = plane.getDistance(v0) > 0;
			var b:Boolean = plane.getDistance(v1) > 0;
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
		
	}

}