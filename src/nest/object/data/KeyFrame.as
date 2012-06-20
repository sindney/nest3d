package nest.object.data 
{
	import flash.geom.Vector3D;
	
	/**
	 * KeyFrame
	 */
	public class KeyFrame {
		
		public var time:Number;
		
		public var next:KeyFrame;
		
		private var _components:Vector.<Vector3D> = new Vector.<Vector3D>(3, true);
		
		public function KeyFrame() {
			_components[0] = new Vector3D();
			_components[1] = new Vector3D();
			_components[2] = new Vector3D(1, 1, 1);
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		public function get components():Vector.<Vector3D> {
			return _components;
		}
		
		///////////////////////////////////
		// toString
		///////////////////////////////////
		
		public function toString():String {
			return "[nest.object.data.KeyFrame]";
		}
		
	}

}