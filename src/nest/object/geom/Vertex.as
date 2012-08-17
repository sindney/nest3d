package nest.object.geom
{
	import flash.geom.Vector3D;
	
	/**
	 * Vertex
	 */
	public class Vertex {
		
		public var x:Number;
		public var y:Number;
		public var z:Number;
		
		public var u:Number;
		public var v:Number;
		
		public var normal:Vector3D;
		
		public function Vertex(x:Number = 0, y:Number = 0, z:Number = 0, u:Number = 0, v:Number = 0) {
			this.x = x;
			this.y = y;
			this.z = z;
			this.u = u;
			this.v = v;
			normal = new Vector3D();
		}
		
	}

}