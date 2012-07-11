package nest.object.data 
{
	import flash.geom.Vector3D;
	
	/**
	 * KeyFrame
	 */
	public class KeyFrame {
		
		public static const ROTATION:int = 0;
		public static const POSITION:int = 1;
		
		public var time:Number;
		
		public var next:KeyFrame;
		
		private var _type:int;
		
		private var _component:Vector3D;
		
		public function KeyFrame(type:int) {
			_type = type;
			_component = new Vector3D();
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		public function get type():int {
			return _type;
		}
		
		public function get component():Vector3D {
			return _component;
		}
		
	}

}