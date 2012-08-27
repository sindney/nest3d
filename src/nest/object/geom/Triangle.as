package nest.object.geom
{
	import flash.geom.Vector3D;
	
	/**
	 * Triangle
	 */
	public class Triangle {
		
		public var index0:uint;
		public var index1:uint;
		public var index2:uint;
		
		public var u0:Number = 0;
		public var u1:Number = 0;
		public var u2:Number = 0;
		public var v0:Number = 0;
		public var v1:Number = 0;
		public var v2:Number = 0;
		
		public var normal:Vector3D;
		
		public function Triangle(index0:uint = 0, index1:uint = 0, index2:uint = 0) {
			this.index0 = index0;
			this.index1 = index1;
			this.index2 = index2;
			normal = new Vector3D();
		}
		
		public function contains(u:Number, v:Number):Boolean {
			var minX:Number = Math.min(u0, u1, u2);
			var maxX:Number = Math.max(u0, u1, u2);
			var minY:Number = Math.min(v0, v1, v2);
			var maxY:Number = Math.max(v0, v1, v2);
			var result:Boolean = false;
			if (u <= maxX && u >= minX && v <= maxY && v >= minY) {
				var du0:Number = u0 - u;
				var dv0:Number = v0 - v;
				var du1:Number = u1 - u;
				var dv1:Number = v1 - v;
				var du2:Number = u2 - u;
				var dv2:Number = v2 - v;
				
				var cross1:Number = du0 * dv1 - du1 * dv0;
				var cross2:Number = du1 * dv2 - du2 * dv1;
				var cross3:Number = du2 * dv0 - du0 * dv2;
				
				if ((cross1>=0&&cross2>=0&&cross3>=0)||(cross1<=0&&cross2<=0&&cross3<=0)) {
					result = true;
				}
			}
			return result;
		}
	}

}