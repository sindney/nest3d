package nest.object.geom
{
	
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
		
		public function Triangle(index0:uint = 0, index1:uint = 0, index2:uint = 0) {
			this.index0 = index0;
			this.index1 = index1;
			this.index2 = index2;
		}
		
	}

}