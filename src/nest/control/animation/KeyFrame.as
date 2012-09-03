package nest.control.animation 
{
	import flash.geom.Vector3D;
	
	/**
	 * KeyFrame
	 */
	public class KeyFrame {
		
		public var time:int;
		
		public var name:String;
		
		public var next:KeyFrame;
		
		public function KeyFrame() {
			
		}
		
		public static function interpolate(k1:KeyFrame, k2:KeyFrame,w:Number):KeyFrame {
			var result:KeyFrame = new KeyFrame();
			result.time = k1.time * w + (1 - w) * k2.time;
			result.next = k2;
			return result;
		}
		
		public function clone():KeyFrame {
			var result:KeyFrame = new KeyFrame();
			result.time = time;
			result.name = name;
			result.next = next;
			return result;
		}
		
	}

}