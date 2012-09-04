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
		
		public static function interpolate(k1:KeyFrame, k2:KeyFrame, w1:Number, w2:Number):KeyFrame {
			if (!k2) return k1.clone();
			var result:KeyFrame = new KeyFrame();
			result.time = k1.time * w1 + k2.time*w2;
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