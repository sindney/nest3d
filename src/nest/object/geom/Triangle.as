package nest.object.geom
{
	
	/**
	 * Triangle
	 */
	public class Triangle {
		
		public var indices:Vector.<uint> = new Vector.<uint>(3, true);
		public var uvs:Vector.<Number> = new Vector.<Number>(6, true);
		
		public function Triangle(index0:uint, index1:uint, index2:uint, 
								u0:int = 0, v0:int = 0, u1:int = 0, v1:int = 0, u2:int = 0, v2:int = 0) {
			indices[0] = index0;
			indices[1] = index1;
			indices[2] = index2;
			uvs[0] = u0;
			uvs[1] = v0;
			uvs[2] = u1;
			uvs[3] = v1;
			uvs[4] = u2;
			uvs[5] = v2;
		}
		
	}

}