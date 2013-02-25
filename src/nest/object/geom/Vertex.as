package nest.object.geom
{
	
	/**
	 * Vertex
	 */
	public class Vertex {
		
		public var x:Number;
		public var y:Number;
		public var z:Number;
		
		public var u:Number;
		public var v:Number;
		
		public var nx:Number = 0;
		public var ny:Number = 0;
		public var nz:Number = 0;
		
		public function Vertex(x:Number = 0, y:Number = 0, z:Number = 0, u:Number = 0, v:Number = 0) {
			this.x = x;
			this.y = y;
			this.z = z;
			this.u = u;
			this.v = v;
		}
		
	}

}