package nest.object.data 
{
	import flash.geom.Vector3D;
	
	/**
	 * KeyFrame
	 */
	public class KeyFrame {
		
		public static const ROTATION:int = 0;
		public static const POSITION:int = 1;
		
		public var time:int;
		
		public var next:KeyFrame;
		
		public var type:int;
		
		public var component:Vector3D;
		
		public function KeyFrame(type:int) {
			this.type = type;
			component = new Vector3D();
		}
		
	}

}