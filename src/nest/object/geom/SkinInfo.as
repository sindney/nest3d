package nest.object.geom 
{
	
	/**
	 * SkinInfo
	 */
	public class SkinInfo {
		
		public var bindPose:Vector.<Vector.<Number>> = new Vector.<Vector.<Number>>();
		
		public var root:Joint;
		public var joints:Vector.<Joint>;
		
		public function SkinInfo(root:Joint, joints:Vector.<Joint>) {
			this.root = root;
			this.joints = joints;
		}
		
	}

}