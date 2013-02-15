package nest.object.geom
{
	import flash.geom.Matrix3D;

	public class Bone {

		public static function calculateCombinedMatrix(bone:Bone, parent:Matrix3D) {
			bone.transformMatrix = bone.transformMatrix.multiply(parent);
			if(bone.sibling)calculateCombinedMatrix(bone.sibling, parent);
			if(bone.firstChild)calculateCombinedMatrix(bone.firstChild, bone.combinedMatrix);
		}

		public var name:String;
		public var transformMatrix:Matrix3D;
		public var offsetMatrix:Matrix3D;
		public var combinedMatrix:Matrix3D;
		public var sibling:Bone;
		public var firstChild:Bone;
	}
}