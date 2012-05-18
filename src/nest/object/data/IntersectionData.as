package nest.object.data 
{
	import flash.geom.Vector3D;
	
	/**
	 * IntersectionData
	 */
	public class IntersectionData {
		
		public var intersected:Boolean;
		public var point:Vector3D;
		
		public function IntersectionData() {
			point = new Vector3D();
		}
		
		///////////////////////////////////
		// toString
		///////////////////////////////////
		
		public function toString():String {
			return "[nest.object.data.IntersectionData]";
		}
		
	}

}