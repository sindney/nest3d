package nest.object.geom 
{
	import flash.geom.Matrix3D;
	
	/**
	 * Joint
	 */
	public class Joint {
		
		public static function calculateMatrixes(joint:Joint, parent:Matrix3D):void {
			joint.combinedMatrix.copyFrom(joint.transformMatrix);
			joint.combinedMatrix.append(parent);
			joint.finalMatrix.copyFrom(joint.combinedMatrix);
			joint.finalMatrix.append(joint.offsetMatrix);
			if (joint.sibling) calculateMatrixes(joint.sibling, parent);
			if (joint.firstChild) calculateMatrixes(joint.firstChild, joint.combinedMatrix);
		}
		
		public var name:String;
		
		public var transformMatrix:Matrix3D = new Matrix3D();
		public var offsetMatrix:Matrix3D = new Matrix3D();
		public var combinedMatrix:Matrix3D = new Matrix3D();
		public var finalMatrix:Matrix3D = new Matrix3D();
		
		public var sibling:Joint;
		public var firstChild:Joint;
		
	}

}