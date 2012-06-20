package nest.object.data 
{
	import nest.object.geom.Joint;
	
	/**
	 * JointLinker
	 */
	public class JointLinker {
		
		public var joint:Joint;
		public var next:JointLinker;
		public var weight:Number;
		
		public function JointLinker(joint:Joint, weight:Number, next:JointLinker = null) {
			this.joint = joint;
			this.weight = weight;
			this.next = next;
		}
		
		///////////////////////////////////
		// toString
		///////////////////////////////////
		
		public function toString():String {
			return "[nest.object.data.JointLinker]";
		}
	}

}